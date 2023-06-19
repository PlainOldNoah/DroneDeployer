extends "res://lvl_objects/base_pickup.gd"

var scrap_value := 0.0

func _ready():
	add_to_group("scrap")
	super._ready()
