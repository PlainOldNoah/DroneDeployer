extends Node

## Singleton script that handles creation of all augments

## Emitted when an augment is created
signal augment_created(augment:AugmentData)

var stat_options:Dictionary = {
	"acceleration":10,
	"damage":20,
	"mass":30,
	"max_battery":40,
	"max_speed":50,
}

func create_rand_augment():
	var new_aug:AugmentData = AugmentData.new()
	new_aug.stats = stat_options.duplicate()
	new_aug.battery_drain = randi_range(0, 10)
	new_aug.tier = randi_range(1, 5)
	new_aug.craft_cost = 1
	emit_signal("augment_created", new_aug)


### Reference path to augment scene
##var augment_scene := preload("res://drone_mods/augment.tscn")
#var augment_scene := preload("res://drone_mods/augment_v2.tscn")
#
### Available stat options that an augment can have
#var options:Dictionary = {
##	"empty": {
##		"min_val":0,
##		"max_val":0,
##	},
#	"max_speed": {
#		"min_val":20,
#		"max_val":300,
#	},
#	"damage": {
#		"min_val":1,
#		"max_val":3,
#	},
#	"max_battery": {
#		"min_val":20,
#		"max_val":100,
#	},
#}
#
### Main function to create and return augments
#func create_augment(hue:float=0.0, value:int=0, stat:String="") -> Augment:
#	var augment := augment_scene.instantiate()
##	augment.stat = stat
##	augment.value = value
#	augment.add_stat(stat, value)
#	augment.hue = hue
#
#	emit_signal("augment_created", augment)
#	return augment
#
#
### Creates an augment with completely randomized stats
#func create_rand_augment() -> Augment:
#	var rand_stat = options.keys()[randi() % options.keys().size()]
#	var rand_value:int = randi_range(options[rand_stat].min_val, options[rand_stat].max_val)
#
#	var pos = options.keys().find(rand_stat)
#	var rand_hue:float = (float(pos) / options.keys().size())
#
#	return create_augment(rand_hue, rand_value, rand_stat)
