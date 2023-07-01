extends Node

## Singleton script that handles creation of all augments

## Emitted when a new augment is created
signal augment_created(augment:Augment)

## Reference path to augment scene
var augment_scene := preload("res://drone_mods/augment.tscn")

## Available stat options that an augment can have
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
	"max_battery": {
		"min_val":20,
		"max_val":100,
	},
}

## Main function to create and return augments
func create_augment(hue:float=0.0, value:int=0, stat:String="") -> Augment:
	var augment := augment_scene.instantiate()
	augment.stat = stat
	augment.hue = hue
	augment.value = value
	
	emit_signal("augment_created", augment)
	return augment


## Creates an augment with completely randomized stats
func create_rand_augment() -> Augment:
	var rand_stat = options.keys()[randi() % options.keys().size()]
	
	var pos = options.keys().find(rand_stat)
	var rand_hue:float = (float(pos) / options.keys().size())
	
	var rand_value:int = randi_range(options[rand_stat].min_val, options[rand_stat].max_val)
	
	return create_augment(rand_hue, rand_value, rand_stat)
