extends CharacterBody2D

var stats:Dictionary = {
	"speed":0,
	"max_hp":0
}

var target_pos = null


func _ready():
	add_to_group("enemy")


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
#	if collision:
#		handle_collision(collision)


#func handle_collision(_collision:KinematicCollision2D):
#	var collider = collision.get_collider()


# Sets the target
func set_target(new_target:Node):
	target_pos = new_target.get_global_position()
	go_to(target_pos)


# Aims the velocity to that of the provided point
func go_to(point:Vector2):
	set_velocity_from_vector(point - self.get_global_position())


# Sets the velocity from a provided vector
func set_velocity_from_vector(vector:Vector2, speed:int=stats.speed):
	set_velocity(vector.normalized() * speed)
	change_facing_direction()


# Adjusts the facing direction to that of the current velocity
func change_facing_direction():
	if velocity.x < 1:
		apply_scale(Vector2(-1,1))
