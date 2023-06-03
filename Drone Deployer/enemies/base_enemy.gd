extends Area2D

var stats:Dictionary = {
	"speed":0,
	"max_hp":0,
	"health":0,
}

var velocity:Vector2 = Vector2()
var target_pos = null


func _ready():
	add_to_group("enemy")
	stats.health = stats.max_hp


func _physics_process(delta):
	move(delta)


# Heads towards target_pos by the velocity until point reached
func move(delta):
	velocity.move_toward(target_pos, delta)
	
	if int(global_position.distance_squared_to(target_pos)) != 0:
		global_position += velocity * delta


# Sets the target
func set_target(new_target:Node):
	target_pos = new_target.get_global_position()
	go_to(target_pos)


# Aims the velocity to that of the provided point
func go_to(point:Vector2):
	set_velocity_from_vector(point - self.get_global_position())


# Sets the velocity from a provided vector
func set_velocity_from_vector(vector:Vector2, speed:int=stats.speed):
	velocity = (vector.normalized() * speed)
	change_facing_direction()


# Adjusts the facing direction to that of the current velocity
func change_facing_direction():
	if velocity.x < 1:
		apply_scale(Vector2(-1,1))


func get_health():
	return stats.health


func take_hit(damage:int):
	stats.health -= damage
	if stats.health <= 0:
		print("DEAD")
		queue_free()
