class_name Drone
extends CharacterBody2D

func _ready():
	add_to_group("drone")
	velocity = Vector2i(-100, 200)
#	await get_tree().create_timer(1).timeout
#	velocity = Vector2i.ZERO


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


func handle_collision(collision:KinematicCollision2D):
	var collider = collision.get_collider()
	
	if collider.is_in_group("drone"):
		velocity = velocity.bounce(collision.get_normal())
		# Fixes two drones from colliding many times at once
		collider.velocity = velocity.bounce(collision.get_normal())
		collider.change_facing_direction()
	else:
		velocity = velocity.bounce(collision.get_normal())
		
	change_facing_direction()


func change_facing_direction():
#	rotation = lerp_angle(rotation, velocity.angle() + PI/2, 0.1)
	rotation = velocity.angle() + PI/2


func set_state():
	pass


func activate():
	pass


func deactivate():
	velocity = Vector2i.ZERO
	
