extends Area2D

signal died(enemy:Node)

@export_range(0,999) var speed = 0
@export_range(0,999) var max_hp = 0
@export_range(0,999) var damage = 0

var health:int = max_hp
var velocity:Vector2 = Vector2()
var target_pos = null


func _ready():
	add_to_group("enemy")
	set_z_index(20)
	health = max_hp


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
func set_velocity_from_vector(vector:Vector2, speed_override:int=speed):
	velocity = (vector.normalized() * speed_override)
	change_facing_direction()


# Adjusts the facing direction to that of the current velocity
func change_facing_direction():
	if velocity.x < 1:
		apply_scale(Vector2(-1,1))


# Return the current health
func get_health():
	return health


# Subtracks damage from health, handles death at 0 hp
func take_hit(damage_pts:int):
	health -= damage_pts
	if health <= 0:
		emit_signal("died", self)


# On death spawn drop items
func _on_death():
	pass
