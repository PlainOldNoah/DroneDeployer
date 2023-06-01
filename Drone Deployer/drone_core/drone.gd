class_name Drone
extends Area2D

signal state_changed(drone:Drone, new_state:int)

enum STATES {STORED, DEPLOYED, RETURNING, ARMING} # PAUSED RETURNING
var state:int = -1

@onready var collision_shape := $CollisionShape2D
@onready var dir_ray := $RayCast2D

var stats:Dictionary = {
	"speed":100
}

var velocity:Vector2 = Vector2()
var collectable:bool = false
var home_pos:Vector2 = Vector2.ZERO
var heading:Vector2 = Vector2()

var acceleration:float = 5.0
# Knockback
var do_knockback:bool = false
var kb_velocity:Vector2 = Vector2.ZERO
var kb_resist:float = 1.0
var kb_recovery:float = 0.01
var kb_cuttoff:float = 0.0


func _ready():
	add_to_group("drone")
	set_state(STATES.STORED)


#func _process(delta):
#	print(velocity, "|", kb_velocity)

func _physics_process(delta):
	handle_movement(delta)
#	handle_rotation(delta)

# Heads towards target_pos by the velocity until point reached
#func move(delta):
#	velocity.move_toward(target_pos, delta)
#
#	if int(global_position.distance_squared_to(target_pos)) != 0:
#		global_position += velocity * delta


func handle_movement(delta):
#	print(heading, ", ", velocity, ", ", global_position)
	velocity.move_toward(heading, delta)
	global_position += velocity * delta


func apply_knockback(dir:Vector2, force:int):
	do_knockback = true
	set_velocity_from_vector(velocity.bounce(dir), force)
#	kb_velocity = (dir * force) / kb_resist

# NOTE: kb_vel for some reason isn't being set to anything

#func handle_knockback(delta):
#	print(kb_velocity, ", ", kb_velocity.length())
#	if kb_cuttoff < kb_velocity.length():
#		var lerp_weight:float = kb_recovery * delta
#		kb_velocity.x = lerp(kb_velocity.x, 0.0, lerp_weight)
#		kb_velocity.y = lerp(kb_velocity.y, 0.0, lerp_weight)
	


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
	elif collider.is_in_group("enemy"):
		velocity = -velocity
#		set_velocity_from_vector(velocity.bounce(collision.get_normal()), 500)
#		apply_knockback(collision.get_normal(), 100)
#		collider.queue_free()
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
#	set_velocity(vector.normalized() * speed)
	velocity = vector.normalized() * speed
	change_facing_direction()


# Sets the home position
func set_home(home:Node):
	home_pos = home.get_global_position()


func _on_body_entered(body):
#	set_velocity_from_vector(velocity.bounce(dir_ray.get_collision_normal()))
#	print(body.name)
	pass

#L 0,-1
#B 0,1
#T 0,-1
#R 0,1

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	pass
	var shape = body.shape_owner_get_owner(body_shape_index).shape
	var collision_points = $CollisionShape2D.shape.collide_and_get_contacts(global_transform, shape, body.global_transform)
#
	var collision_normal = (collision_points[0] - collision_points[1]).normalized()
	
#	dir_ray.target_position = dir_ray.target_position.bounce(collision_normal)
	dir_ray.target_position = shape.normal * 500
	print(shape.normal)
#	set_velocity_from_vector(dir_ray.target_position)
	velocity = Vector2.ZERO
	
	
#	set_velocity_from_vector(velocity.bounce(collision_normal))
#	set_velocity_from_vector(velocity.bounce(dir_ray.get_collision_normal()))
	
