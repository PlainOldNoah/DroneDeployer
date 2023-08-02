class_name Drone
extends CharacterBody2D

## Deployable object that can defeat enemies and pick up items

signal state_changed(drone:Drone, new_state:int)
signal stats_updated(drone:Drone)

enum STATES {
	STORED, ## Drone is waiting to be deployed, all systems off
	DEPLOYED, ## Drone is on the field as normal
	RETURNING, ## Heading back to the DDCC
	STOPPED, ## On the field but not moving, acts as a prop
	ARMING
	}

var state:int = -1

## Physical body; Only used in collisions/bounces
@onready var collision_shape := $CollisionShape2D
## Acts as the drone's body for collection items and hitting enemies
@onready var pseudo_body := $PseudoBody
## Area2D responsible for pulling map items towards self
@onready var collection_range := $CollectionRange


var stats:Dictionary = {
	"max_speed":100.0,
	"speed":100,

	"damage":1,

	"max_battery":100,
	"battery":100.0,
	"battery_drain":0.0,
	"battery_return_threshold":0.1,

	"display_name":"",
}

## Number of times to be knocked back before bouncing
var bounces:int = 1
## Can be picked up by DDCC
var collectable:bool = false

## Point to return to when at low battery
var home_pos:Vector2 = Vector2.ZERO:
	set(new_value):
		home_pos = new_value


var acceleration:float = 1
var do_knockback:bool = false
var kb_resist:float = 1
var kb_min_speed:float = stats.max_speed / 4.0

var collected_scrap:float = 0.0


func _ready():
	add_to_group("drone")
	set_z_index(30)
	set_state(STATES.STORED)
	debug_randomize_values()


func debug_randomize_values():
	$Sprite.modulate = Color(randf(), randf(), randf())
	stats.max_speed = randi_range(100, 300)
	stats.damage = randi_range(1,10)
	stats.max_battery = randi_range(100,500)
	emit_signal("stats_updated", self)


func _physics_process(delta):
	handle_movement(delta)
#	print(stats.speed)


func _process(delta):
	battery_calculation(delta)


func battery_calculation(delta:float):
	if state == STATES.STORED:
		stats.battery = clamp(stats.battery + (stats.battery_drain * 2 * delta), 0.0, stats.max_battery)
	else:
		stats.battery = clamp(stats.battery - (stats.battery_drain * delta), 0.0, stats.max_battery)

	emit_signal("stats_updated", self)
	#	emit_signal("stats_updated", self, "battery")

	if stats.battery <= 0.0: # Battery is Dead
		set_process(false)
		set_state(STATES.STOPPED)
	elif (stats.battery / stats.max_battery) <= stats.battery_return_threshold:
		pass
#		print("BATTERY RUNNING LOW")


# ===== STATE MACHINE =====


# FOR INTERNAL CALLING ONLY
# State machine for the Drone; enables/disables collisions, sprites, movement, etc.
func set_state(new_state:int):
	if new_state == state:
		print_debug("WARNING: Already in state <", state, ">")

	state = new_state
	match state:

		STATES.DEPLOYED: # On the field in play
			set_process(true)
			set_physics_process(true)
			disable_collision_shapes(false, false)
			set_visible(true)
			collectable = false

		STATES.RETURNING: # Heading back to DDCC
			pass

		STATES.STORED: # Inside the DDCC waiting to be depolyed
			set_process(false)
			set_physics_process(false)
			disable_collision_shapes(true, true)
#			set_visible(false)
			set_velocity_from_vector(Vector2i.ZERO, 0)
			global_position = home_pos

		STATES.STOPPED: # Non-moving, ie battery dead
			set_physics_process(false)
			disable_collision_shapes(false, true)
			set_velocity_from_vector(velocity, 0)

		_:
			print_debug("ERROR: STATE NOT DEFINED <", new_state, ">")
			return

	emit_signal("state_changed", self, new_state)


## Activates a Drone for the map with a starting point and angle (in radians)
func deploy(deploy_pos:Vector2, deploy_angle:float):
	if state == STATES.STORED:
		set_global_position(deploy_pos)
		set_velocity_from_radians(deploy_angle)
		set_facing_direction()
		set_state(STATES.DEPLOYED)
	else:
		print_debug("ERROR: ILLEGAL STATE TRANSITION", state)


## Deactivates a Drone from deployment and "hides" it
func store():
	set_state(STATES.STORED)


# ===== SCANNERS =====

## Toggle both the solid colliding body as well as the area2d scanners
func disable_collision_shapes(solid_body_value:bool, scanner_value:bool):
	collision_shape.set_deferred("disabled", solid_body_value)
	pseudo_body.get_node("CollisionShape2D").set_deferred("disabled", scanner_value)
	collection_range.get_node("CollisionShape2D").set_deferred("disabled", scanner_value)


func ddcc_collection_range_entered():
	if collectable == true:
		set_state(STATES.RETURNING)
		go_to(home_pos)


## Set the drone to collectable when outside the range
#func ddcc_perimeter_exited():
#	collectable = true


## Handles enemies that collide with the "body"
func _on_scanner_area_entered(area):
	if area.is_in_group("enemy"):
		if area.health > stats.damage:
			stats.speed = stats.max_speed # TEMP FIX
			activate_knockback()
			area.take_hit(stats.damage)
		else:
			area.take_hit(stats.damage)
	elif area.is_in_group("pickup"):
		collected_scrap += area.scrap_value
		area.queue_free()


func _on_collection_range_area_entered(area):
	area.collection_range_entered(self)


func _on_collection_range_area_exited(area):
	pass
#	area.stop()


# ===== COLLISION & MOVEMENT =====


## Determines what a Drone should do upon hitting something
func handle_collision(collision:KinematicCollision2D):
	var collider = collision.get_collider()

	if collider.is_in_group("drone"):
		set_velocity_from_vector(velocity.bounce(collision.get_normal()))
		# Fixes two drones from colliding many times at once
#		collider.set_velocity_from_vector(velocity.bounce(collision.get_normal()))
		collider.set_velocity_from_vector(collider.get_velocity())
#		collider.change_facing_direction()
	elif bounces <= 0:
		set_velocity_from_vector(velocity.bounce(collision.get_normal()))
		bounces = 1
	else:
		activate_knockback() # TEMP FOR TESTING PURPOSES


## Controls knockback and kb recovery plus normal movement
func handle_movement(delta):
	if do_knockback:
#		stats.speed = lerpf(stats.speed, 0.0, acceleration * delta)
		stats.speed = lerpf(stats.speed, 0.0, kb_resist * delta)

		if int(stats.speed) <= kb_min_speed:
			do_knockback = false
			bounces -= 1
#			set_velocity_from_vector(-velocity)
			set_velocity_from_vector(velocity, -stats.speed)
	elif stats.speed < stats.max_speed:
		stats.speed = lerpf(stats.speed, stats.max_speed, acceleration * delta)

	set_velocity_from_vector(velocity, stats.speed)

	# Normal Movement, Collides with walls and props
	var collision := move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


## Puts the drone into knockback mode and reverses the velocity
func activate_knockback():
	if not do_knockback:
		do_knockback = true
#		set_velocity_from_vector(-velocity)
		set_velocity_from_vector(velocity, -stats.speed)


## Sets the current heading to that of the provided point
func go_to(point:Vector2):
	set_velocity_from_vector(point - self.get_global_position())


## Adjusts the rotation to that of the current velocity GRADUALLY
func change_facing_direction():
	rotation = lerp_angle(rotation, velocity.angle() + PI/2, 0.15)
#	set_rotation(velocity.angle() + PI/2)


## Adjusts the rotation to that of the current velocity INSTANTLY
func set_facing_direction():
	set_rotation(velocity.angle() + PI/2)


## Sets the velocity from a provided angle in radians and speed
func set_velocity_from_radians(radians:float, speed:int=stats.speed):
	set_velocity_from_vector(Vector2.from_angle(radians), speed)


## Sets the velocity from a provided vector
func set_velocity_from_vector(vector:Vector2, speed:int=stats.speed):
	set_velocity(vector.normalized() * speed)
	if (speed > 0) and (do_knockback == false):
		change_facing_direction()


# ===== MISC =====


## Returns the current scrap amount and resets it to 0
func transfer_scrap() -> int:
	var output := roundi(collected_scrap)
	collected_scrap = 0
	return output


# Setter for stats, prints warning if statically typed items are unequal
func set_stat(stat:String, value):
	if stats.has(stat):
		if (typeof(stats.get(stat))) != (typeof(value)):
			print_debug("WARNING: setting drone stat of type <", (typeof(stats.get(stat))), "> with type <", (typeof(value)), ">")
		stats[stat] = value

