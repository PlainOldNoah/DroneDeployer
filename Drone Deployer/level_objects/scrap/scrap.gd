class_name Scrap
extends Area2D

@export var value:float = 1
@export var size_variance:float = 0.2

@onready var sprite := $Sprite2D

var attract_target:Node = null:
	set(new_target):
		attract_target = new_target
		if attract_target == null:
			set_physics_process(false)
		else:
			set_physics_process(true)


func _ready():
	add_to_group("scrap")
	randomize_texture_variation()
	randomize_size()
	
	set_physics_process(false)


func _physics_process(delta):
	move_to(attract_target.global_position)


## For sprite sheets, select one sprite
func randomize_texture_variation():
	var frame_count:int = sprite.hframes * sprite.vframes
	sprite.frame = randi_range(0, frame_count - 1)
	sprite.rotate(randf_range(0, TAU))

## Scales up or down the scrap based on defined size_variance
func randomize_size():
	var rand_size_mult:float = randf_range(1 - size_variance, 1 + size_variance)
	scale *= rand_size_mult

## Lerps from current position to location
func move_to(location:Vector2):
	global_position = global_position.lerp(location, 0.1)
