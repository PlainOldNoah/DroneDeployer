extends Area2D

@export_range(0,999,0.5) var points := 1.0

var attract_force:int = 40
var target_body:Node = null
var acceleration:Vector2 = Vector2.ZERO
var velocity:Vector2 = Vector2.ZERO


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


# Moves to the paramaterized body
func magnet_towards(new_body:Node):
	set_physics_process(true)
	target_body = new_body
