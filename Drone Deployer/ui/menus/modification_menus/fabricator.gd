class_name Fabricator
extends Control

## Spend scrap to create augments and upgrades

@onready var scrap_amt_label := %ScrapAmount

func _ready():
	var _ok := GameplayManager.connect("curr_scrap_updated", _on_update_scrap_label)


## Verifies item_name is in the CraftingDb then expends the scrap and sets the item to be made
func fabricate_item(item_type:String, item_name:String):
	print_debug("You shouldn't be here")
	pass
#	1. Check that craftables:Dictionary has item_name
#	var craft_db_item:Dictionary = {}
#	if CraftingDb[item_type].has(item_name):
#		craft_db_item = CraftingDb[item_type][item_name]
#	else:
#		print_debug("ERROR: <", item_name, "> is not a craftable item")
#		return
#
##	2. Checks if the necessary scrap is available
#	if GameplayManager.remove_scrap(craft_db_item["base_cost"]):
#
##		print_debug(craft_db_item, " // ", CraftingDb[item_type][item_name])
##	3. Handles the specifics for each craftable item
#		match craft_db_item:
#			CraftingDb.drone_augments.random:
#				AugmentFactory.create_rand_augment()
#			CraftingDb.general.stock_drone:
#				DroneManager.create_new_drone()
#			CraftingDb.general.repair_kit:
#				print_debug("This should heal some health")
#			_:
#				print_debug("ERROR: unable to complete craft")
#	else:
#		print_debug("Insufficient Scrap <", GameplayManager.current_scrap, "/", craft_db_item["base_cost"],">")


## Updates the scrap_amt_label value
func _on_update_scrap_label(scrap_value:float):
	scrap_amt_label.text = "Scrap: %d" % scrap_value


## All craft buttons connect here and pass item as a string to specify what they link to
func _on_fabricate_item_button_pressed(item:String):
	print_debug("You shouldn't be here")
	pass
#	match item:
#		"drone_augment_random":
#			fabricate_item("drone_augments", "random")
#		"new_stock_drone":
#			fabricate_item("general", "stock_drone")
#		"repair_kit":
#			fabricate_item("general", "repair_kit")
#		_:
#			print_debug("ERROR: Unknown item_specific <", item, ">")


## Craft a random augment
func _on_craft_random_augment_pressed(craftable_data:CraftableData):
	if GameplayManager.remove_scrap(craftable_data.base_cost):
		AugmentFactory.create_rand_augment()

## Craft a new, blank, drone
func _on_craft_stock_drone_pressed(craftable_data:CraftableData):
	if GameplayManager.remove_scrap(craftable_data.base_cost):
		DroneManager.create_new_drone()

func _on_craft_repair_kit_pressed(craftable_data:CraftableData):
	if GameplayManager.remove_scrap(craftable_data.base_cost):
		print_debug("This should heal some health")
