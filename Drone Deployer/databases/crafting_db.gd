extends Node

## Group of Dictionaries that hold different craftable items
##
## Each group hold a related set of items that are used in the [Fabricator]
## [br][br]
## Adding New Craftable Items:
## [br]1. Add the item to the crafting_db
## [br]2. Create a new button within the [Fabricator]
## [br]3. Link up the button into the [member Fabricator._on_fabricate_item_button_pressed]
## [br]4. Add the item to [member Fabricator.fabricate_item]
## [br]5. Add in any item specific functions 


## Base items for the game
var general:Dictionary = {
	## Default Drone
	"stock_drone":{
		"base_cost":0
	},
	## Restore HP to DDCC
	"repair_kit":{
		"base_cost":10
	},
}

## Available [Drone] augments for crafting
var drone_augments:Dictionary = {
	"random":{
		"base_cost":0,
		"available_stats": ["battery_drain", "max_battery", "damage", "speed"]
	},
	"battery":{
		"base_cost":3,
		"available_stats": ["battery_drain", "max_battery"]
	},
	"damage":{
		"base_cost":3,
		"available_stats": ["damage"]
	},
	"speed":{
		"base_cost":3,
		"available_stats": ["speed"]
	},
}
