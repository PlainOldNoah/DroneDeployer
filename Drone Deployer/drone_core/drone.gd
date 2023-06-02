class_name Drone
extends CharacterBody2D

signal state_changed(drone:Drone, new_state:int)

enum STATES {STORED, DEPLOYED, RETURNING, ARMING} # PAUSED RETURNING
var state:int = -1

@onready var collision_shape := $CollisionShape2D

var stats:Dictionary = {
	"max_speed":100.0,
	"speed":100.0
}

var bounces:int = 1

var collectable:bool = false
var home_pos:Vector2 = Vector2.ZERO

var acceleration:float = 2
var do_knockback:bool = false
var kb_resist:float = 1
var kb_min_speed:float = stats.max_speed / 2.0


func _ready():
	add_to_group("drone")
	set_state(STATES.STORED)


func _physics_process(delta):
	handle_movement(delta)


# Controls knockback and kb recovery plus normal movement
func handle_movement(delta):
	if do_knockback:
		stats.speed = lerpf(stats.speed, 0.0, kb_resist*delta)
		if int(stats.speed) <= kb_min_speed:
			do_knockback = false
			bounces -= 1
			set_velocity_from_vector(-velocity)
	elif stats.speed < stats.max_speed:
		stats.speed = lerpf(stats.speed, stats.max_speed, delta*acceleration)
	
	set_velocity_from_vector(velocity, stats.speed)
	
	# Normal Movement, Collides with walls and props
	var collision := move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


# Puts the drone into knockback mode and reverses the velocity
func activate_knockback():
	do_knockback = true
	set_velocity_from_vector(-velocity)


# ===== STATE MACHINE =====


# FOR INTERNAL CALLING ONLY
# State machine for the Drone; enables/disables collisions, sprites, movement, etc.
func set_state(new_state:int):
#	print(self.name, ": ", new_state)
	if new_state == state:
		print_debug("WARNING: Already in state <", state, ">")
	
	state = new_state
	match state:
			
		STATES.DEPLOYED:
			set_physics_process(true)
			collision_shape.set_deferred("disabled", false)
			set_visible(true)
			collectable = false
			
		STATES.RETURNING:
			pass
		
		STATES.STORED:
			set_physics_process(false)
			collision_shape.set_deferred("disabled", true)
			set_visible(false)
			set_velocity_from_vector(Vector2i.ZERO, 0)
			global_position = Vector2.ZERO
		_:
			print_debug("ERROR: STATE NOT DEFINED <", new_state, ">")
			return
	
	emit_signal("state_changed", self, new_state)


# Activates a Drone for the map with a starting point and angle (in radians)
func deploy(deploy_pos:Vector2, deploy_angle:float):
	if state == STATES.STORED:
		set_state(STATES.DEPLOYED)
		set_global_position(deploy_pos)
		set_velocity_from_radians(deploy_angle)
	else:
		print_debug("ERROR: ILLEGAL STATE TRANSITION", state)


# Deactivates a Drone from deployment and "hides" it
func store():
	set_state(STATES.STORED)


func ddcc_collection_range_entered():
	if collectable == true:
		set_state(STATES.RETURNING)
		go_to(home_pos)


func ddcc_collection_range_exited():
	collectable = true


# ===== COLLISION & MOVEMENT =====


# Determines what a Drone should do upon hitting something
func handle_collision(collision:KinematicCollision2D):
	var collider = collision.get_collider()
	
	if collider.is_in_group("drone"):
		set_velocity_from_vector(velocity.bounce(collision.get_normal()))
		# Fixes two drones from colliding many times at once
		collider.set_velocity_from_vector(velocity.bounce(collision.get_normal()))
		collider.change_facing_direction()
	elif bounces <= 0:
		set_velocity_from_vector(velocity.bounce(collision.get_normal()))
		bounces = 1
	else:
		activate_knockback() # TEMP FOR TESTING PURPOSES
		
#	change_facing_direction()


# Sets the current heading to that of the provided point
func go_to(point:Vector2):
	set_velocity_from_vector(point - self.get_global_position())


# Adjusts the rotation to that of the current velocity
func change_facing_direction():
#	rotation = lerp_angle(rotation, velocity.angle() + PI/2, 0.1)
	set_rotation(velocity.angle() + PI/2)


# Sets the velocity from a provided angle in radians and speed
func set_velocity_from_radians(radians:float, speed:int=stats.speed):
	set_velocity_from_vector(Vector2.from_angle(radians), speed)


# Sets the velocity from a provided vector
func set_velocity_from_vector(vector:Vector2, speed:int=stats.speed):
	set_velocity(vector.normalized() * speed)
	if (speed > 0) and (do_knockback == false):
		change_facing_direction()


# Sets the home position
func set_home(home:Node):
	home_pos = home.get_global_position()
