extends Node

var augment_scene := preload("res://drone_mods/augment.tscn")

# This is right from Drone.stats
var options:Dictionary = {
	"empty": {
		"min_val":0,
		"max_val":0,
	},
	"max_speed": {
		"min_val":20,
		"max_val":300,
	},
	"damage": {
		"min_val":1,
		"max_val":3,
	},
	"battery": {
		"min_val":20,
		"max_val":100,
	},
}

# Main function to create and return augments
func create_augment(color:Color=Color.WHITE, value:int=0) -> Augment:
	var augment := augment_scene.instantiate()
	augment.set_color(color)
	augment.set_value(value)
	return augment


# Creates an augment with completely randomized stats
func create_rand_augment() -> Augment:
	var rand_stat = options.keys()[randi() % options.keys().size()]
	
	var pos = options.keys().find(rand_stat)
	var rand_color:Color = Color.from_hsv(float(pos) / options.keys().size(), 1, 1)
	
	var value:int = randi_range(options[rand_stat].min_val, options[rand_stat].max_val)
	
	return create_augment(rand_color, value)
