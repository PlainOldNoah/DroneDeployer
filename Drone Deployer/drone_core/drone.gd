class_name Drone
extends CharacterBody2D

## Deployable object that can defeat enemies and pick up items

## Emitted when any of the drone stats change
signal stats_updated(drone:Drone)

## Physical body; Only used in collisions/bounces
@onready var collision_shape := $CollisionShape2D
## Acts as the drone's body for collection items and hitting enemies
@onready var pseudo_body := $PseudoBody
## Area2D responsible for pulling map items towards self
@onready var collection_range := $CollectionRange
## Drone State Manager, handles drone states
@onready var drone_state_manager:DroneStateManager = $DroneStateManager

var stats:Dictionary = {
	"max_speed":100.0,
	"speed":200,

	"damage":1,

	"max_battery":100,
	"battery":100.0,
	"battery_drain":0,
	"battery_return_threshold":0.1,

	"display_name":"",
}

## Number of times to be knocked back before bouncing
#var bounces:int = 1
## Can be picked up by DDCC
#var collectable:bool = false
## How much scrap is current stored within self
var collected_scrap:float = 0.0

## Point to return to when at low battery
var home_pos:Vector2 = Vector2.ZERO:
	set(new_value):
		home_pos = new_value


## Velocity only used in knockback
var knockback_velocity:Vector2
## How much the drone is affected by knockback
var mass:float
## Value in which knockback is no longer significient
var knockback_cutoff:float = 10.0

## Flag for if the drone has moved outside the shield range
var exited_shield_area:bool = false
## Flag for if the DDCC can collect this drone when it comes in contact
var ddcc_collectable:bool = false
## Distance away from DDCC in which a drone would be collected
var ddcc_collect_distance:int = 10


func _ready():
	add_to_group("drone")
	set_z_index(30)
	debug_randomize_values()
	
	drone_state_manager.init(self)

func _physics_process(delta):
	drone_state_manager.physics_process(delta)
	ddcc_collect()

func _process(delta):
	drone_state_manager.process(delta)


func debug_randomize_values():
	$Sprite.modulate = Color(randf(), randf(), randf())
	stats.max_speed = randi_range(100, 300)
	stats.damage = randi_range(1,10)
	stats.max_battery = randi_range(100,500)
	emit_signal("stats_updated", self)


## Drains the battery and returns a [DroneState]
func drain_battery(delta:float) -> int:
	stats.battery = clamp(stats.battery - (stats.battery_drain * delta), 0.0, stats.max_battery)
	emit_signal("stats_updated", self)
	
	if stats.battery <= 0.0: # Dead Battery
		return DroneState.STATE.DEAD
		
#		NOTE: Check battery threshold after colliding since that's when drone can go home
		
#	elif (stats.battery / stats.max_battery) <= stats.battery_return_threshold:
#		return DroneState.STATE.RETURNING
	
	return DroneState.STATE.NULL


## Charges the battery, returns true when battery is full
func charge_battery(delta:float) -> bool:
	stats.battery = clamp(stats.battery + (stats.battery_drain * 2 * delta), 0.0, stats.max_battery)
	emit_signal("stats_updated", self)
	
	if stats.battery == stats.max_battery:
		return true
	return false


## Activates a Drone for the map with a starting point and angle (in radians)
func deploy(deploy_pos:Vector2, deploy_angle:float):
	set_global_position(deploy_pos)
	set_velocity_from_radians(deploy_angle)
	set_facing_direction(true)
	drone_state_manager.change_state(DroneState.STATE.ACTIVE)


## Returns the current state the drone is in
func get_drone_state() -> DroneState:
	return drone_state_manager.current_state


## When the drone moves far enough away set ddcc_collectable to true
## Once true if the drone gets within that distance to the ddcc, go to hanger
func ddcc_collect():
	if ddcc_collectable == false:
		if self.global_position.distance_to(home_pos) > ddcc_collect_distance:
			ddcc_collectable = true
	else:
		if self.global_position.distance_to(home_pos) <= ddcc_collect_distance:
			drone_state_manager.change_state(DroneState.STATE.IDLE)


## Moves and collides both normally and with knockback
func move(delta:float):
	var collision:KinematicCollision2D
	
#	print(knockback_velocity.length(), " // ", knockback_velocity)
	
	if knockback_velocity.length() > knockback_cutoff:
		handle_knockback(delta)
		move_and_collide(knockback_velocity * delta)
	else:
		collision = move_and_collide(velocity * delta)
		set_facing_direction(false)
	
	if collision:
		handle_collision(collision)


## Handles what happens when drone is colliding
func handle_collision(collision:KinematicCollision2D):
	var collider = collision.get_collider()

	if collider.is_in_group("drone"):
		knockback_velocity = collider.global_position.direction_to(global_position) * 50
	else:
		set_velocity_from_vector(velocity.bounce(collision.get_normal()))


## Lerps the knockback_velocity to 0
func handle_knockback(delta:float):
	knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, 1 * delta)


func temp():
	pass
#	if exited_shield_area:
#		drone_state_manager.change_state(DroneState.STATE.IDLE)


## When the drone enters the shield area, go to the hanger
func _on_ddcc_shield_area_entered():
	if exited_shield_area:
		drone_state_manager.change_state(DroneState.STATE.RETURNING)

## When the drone exits the shield area for the first time
func _on_ddcc_shield_area_exited():
	exited_shield_area = true

# ------------------------------------------------------------------------------

## Toggle both the solid colliding body as well as the area2d scanners
func disable_collision_shapes(solid_body_value:bool, scanner_value:bool):
	collision_shape.set_deferred("disabled", solid_body_value)
	pseudo_body.get_node("CollisionShape2D").set_deferred("disabled", scanner_value)
	collection_range.get_node("CollisionShape2D").set_deferred("disabled", scanner_value)


## Sets the rotation to the direction of the velocity; Gradually or instantly
func set_facing_direction(instantly:bool=true):
	if instantly:
		set_rotation(velocity.angle() + PI/2)
	else:
		rotation = lerp_angle(rotation, velocity.angle() + PI/2, 0.15)


## Sets the velocity from a provided angle in radians and speed
func set_velocity_from_radians(radians:float, speed:int=stats.speed):
	set_velocity_from_vector(Vector2.from_angle(radians), speed)


## Sets the velocity from a provided vector
func set_velocity_from_vector(vector:Vector2, speed:int=stats.speed):
	set_velocity(vector.normalized() * speed)

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

func ddcc_collection_range_entered():
	pass
#	if collectable == true:
#		set_state(STATES.RETURNING)
#		go_to(home_pos)


## Set the drone to collectable when outside the range
#func ddcc_perimeter_exited():
#	collectable = true


## Handles enemies that collide with the "body"
func _on_scanner_area_entered(area):
	pass
#	if area.is_in_group("enemy"):
#		if area.health > stats.damage:
#			stats.speed = stats.max_speed # TEMP FIX
#			activate_knockback()
#			area.take_hit(stats.damage)
#		else:
#			area.take_hit(stats.damage)
#	elif area.is_in_group("pickup"):
#		collected_scrap += area.scrap_value
#		area.queue_free()


func _on_collection_range_area_entered(area):
	area.collection_range_entered(self)


# ===== COLLISION & MOVEMENT =====


## Determines what a Drone should do upon hitting something
#func handle_collision(collision:KinematicCollision2D):
#	var collider = collision.get_collider()
#
#	if collider.is_in_group("drone"):
#		set_velocity_from_vector(velocity.bounce(collision.get_normal()))
#		# Fixes two drones from colliding many times at once
##		collider.set_velocity_from_vector(velocity.bounce(collision.get_normal()))
#		collider.set_velocity_from_vector(collider.get_velocity())
##		collider.change_facing_direction()
#	elif bounces <= 0:
#		set_velocity_from_vector(velocity.bounce(collision.get_normal()))
#		bounces = 1
#	else:
#		activate_knockback() # TEMP FOR TESTING PURPOSES


## Controls knockback and kb recovery plus normal movement
#func handle_movement(delta):
#	if do_knockback:
##		stats.speed = lerpf(stats.speed, 0.0, acceleration * delta)
#		stats.speed = lerpf(stats.speed, 0.0, kb_resist * delta)
#
#		if int(stats.speed) <= kb_min_speed:
#			do_knockback = false
#			bounces -= 1
##			set_velocity_from_vector(-velocity)
#			set_velocity_from_vector(velocity, -stats.speed)
#	elif stats.speed < stats.max_speed:
#		stats.speed = lerpf(stats.speed, stats.max_speed, acceleration * delta)
#
#	set_velocity_from_vector(velocity, stats.speed)
#
#	# Normal Movement, Collides with walls and props
#	var collision := move_and_collide(velocity * delta)
#	if collision:
#		handle_collision(collision)


## Puts the drone into knockback mode and reverses the velocity
#func activate_knockback():
#	if not do_knockback:
#		do_knockback = true
##		set_velocity_from_vector(-velocity)
#		set_velocity_from_vector(velocity, -stats.speed)


## Sets the current heading to that of the provided point
#func go_to(point:Vector2):
#	set_velocity_from_vector(point - self.get_global_position())


## Adjusts the rotation to that of the current velocity GRADUALLY
#func change_facing_direction():
#	rotation = lerp_angle(rotation, velocity.angle() + PI/2, 0.15)
#	set_rotation(velocity.angle() + PI/2)



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

