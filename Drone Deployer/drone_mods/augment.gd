extends Control
class_name Augment

@onready var texture_rect:TextureRect = $TextureRect

var value:int

func set_color(color:Color):
	set_modulate(color)


func set_value(new_value:int):
	value = new_value
