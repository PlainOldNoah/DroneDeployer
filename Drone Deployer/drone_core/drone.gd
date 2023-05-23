class_name Drone
extends CharacterBody2D

signal state_changed(new_state:int)

enum STATES {STORED, DEPLOYED, RETURNING, ARMING} # PAUSED RETURNING
var state:int = -1

@onready var collision_shape := $CollisionShape2D

var stats:Dictionary = {
	"speed":100
}

var collectable:bool = false
var home_pos:Vector2 = Vector2.ZERO


func _ready():
	add_to_group("drone")
	set_state(STATES.STORED)


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


# ===== STATE MACHINE =====


# FOR INTERNAL CALLING ONLY
# State machine for the Drone; enables/disables collisions, sprites, movement, etc.
func set_state(new_state:int):
	print(self.name, ": ", new_state)
	if new_state == state:
		print_debug("WARNING: Already in state <", state, ">")
	
	state = new_state
	match state:
			
		STATES.DEPLOYED:
			set_visible(true)
			collision_shape.set_deferred("disabled", false)
			
		STATES.RETURNING:
			pass
		
		STATES.STORED:
			DroneManager.add_drone_to_queue(self)
			collision_shape.set_deferred("disabled", true)
			set_visible(false)
			set_velocity_from_vector(Vector2i.ZERO, 0)
			global_position = Vector2.ZERO
		_:
			print_debug("ERROR: STATE NOT DEFINED <", new_state, ">")
			return
	
#	emit_signal("state_changed", new_state)


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
	else:
		set_velocity_from_vector(velocity.bounce(collision.get_normal()))
		
	change_facing_direction()


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
	change_facing_direction()


# Sets the home position
func set_home(home:Node):
	home_pos = home.get_global_position()
