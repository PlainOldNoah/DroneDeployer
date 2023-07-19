extends Area2D

@export_range(0,999,0.5) var points := 1.0

var attract_force:int = 20
var acceleration:Vector2 = Vector2.ZERO
var velocity:Vector2 = Vector2.ZERO

var target_body:Node = null:
	set(new_body):
		target_body = new_body
#		if target_body != null:
#			magnet_active = magnet_active

#var magnet_active:bool = false:
#	set(new_value):
#		magnet_active = new_value
#		if not magnet_active:
#			set_physics_process(false)
#		else:
#			if target_body != null:
#				set_physics_process(true)


func _ready():
	add_to_group("pickup")
	set_z_index(10)
	set_physics_process(false)


func randomize_sprite():
	var sprite := $Sprite2D
	var total_frames:int = sprite.get_vframes() * sprite.get_hframes()
	sprite.set_frame(randi_range(0, total_frames - 1))


func _physics_process(delta):
	acceleration = Vector2()
	var dir = (target_body.position - position).normalized()
	acceleration += dir * attract_force

	velocity += acceleration * delta
	position += velocity


## Activates physics process and sets a new target body
func magnet_towards(new_body:Node):
	set_physics_process(true)
	target_body = new_body
