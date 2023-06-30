extends Control
class_name Augment

## Stat upgrade for Drones

@onready var texture_rect:TextureRect = $TextureRect

## What stat this augment will modify
var stat:String = "":
	set(new_stat):
		stat = new_stat

## How much the given stat will change by
var value:int = 0:
	set(new_value):
		value = new_value

## How much battery will this augment drain (p/sec)
var battery_drain:float = 0.0:
	set(new_value):
		battery_drain = new_value

##
var hue:float = 0.0:
	set(new_hue):
		set_modulate(Color.from_hsv(new_hue, 1, 1))


## Sets the modulate of the augment's sprite
func set_color(color:Color):
	set_modulate(color)


## Setter for value variable
func set_value(new_value:int):
	value = new_value


## Handles when augment is clicked on
func _on_gui_input(event):
	if (event is InputEventMouseButton) and (event.pressed):
		print(name, " // ", stat," // ",  value, " // ", get_modulate())
