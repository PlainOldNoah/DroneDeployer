class_name Drone
extends CharacterBody2D

# STORED=Waiting in DDCC / DEPLOYED=Actively on the map / RETURNING=Heading back to DDCC / SPAWNING=Leaving DDCC / PAUSED=Speed set to 0
enum STATES {STORED, DEPLOYED} # PAUSED RETURNING
var state:int = STATES.STORED

@onready var collision_shape := $CollisionShape2D

var stats:Dictionary = {
	"speed":100
}

func _ready():
	add_to_group("drone")
	store()


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


# ===== STATE MACHINE =====


# FOR INTERNAL CALLING ONLY
# State machine for the Drone; enables/disables collisions, sprites, movement, etc.
func set_state(new_state:int):
	state = new_state
	match state:
		STATES.STORED:
			collision_shape.set_deferred("disabled", true)
			set_visible(false)
			set_velocity_from_vector(Vector2i.ZERO, 0)
			global_position = Vector2.ZERO
			
		STATES.DEPLOYED:
			collision_shape.set_deferred("disabled", false)
			set_visible(true)
		_:
			print_debug("ERROR: ILLEGAL STATE TRANSITION ATTEMPT")


# Activates a Drone for the map with a starting point and angle (in radians)
func deploy(deploy_pos:Vector2, deploy_angle:float):
	set_state(STATES.DEPLOYED)
	set_global_position(deploy_pos)
	set_velocity_from_radians(deploy_angle)


# Deactivates a Drone from deployment and "hides" it
func store():
	set_state(STATES.STORED)


#func pause():
#	pass


#func resume():
#	pass


#func return_home():
#	pass


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
