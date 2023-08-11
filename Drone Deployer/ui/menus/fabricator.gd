class_name Fabricator
extends Control

## Spend scrap to create augments and upgrades

## Emitted when a new augment is fabricated
signal augment_fabricated(new_augment:Augment)

@onready var ddcc_options := %DDCCOptions
@onready var augment_options := %AugmentsOptions
@onready var upgrade_options := %UpgradesOptions
@onready var scrap_amt_label := %ScrapAmount

## The different available crafting options
enum CRAFT_CATEGORIES {DDCC, AUGMENT, UPGRADE}
## The currently selected crafting category
var craft_category:CRAFT_CATEGORIES:
	set(new_category):
		if craft_category != new_category:
			craft_category = new_category
			change_craft_option_tab(new_category)


func _ready():
	change_craft_option_tab(CRAFT_CATEGORIES.DDCC)
	var _ok := GameplayManager.connect("curr_scrap_updated", _on_update_scrap_label)


## Shows and hides the different craft option categories
func change_craft_option_tab(new_category:CRAFT_CATEGORIES):
	ddcc_options.hide()
	augment_options.hide()
	upgrade_options.hide()

	match new_category:
		CRAFT_CATEGORIES.DDCC:
			ddcc_options.show()
		CRAFT_CATEGORIES.AUGMENT:
			augment_options.show()
		CRAFT_CATEGORIES.UPGRADE:
			upgrade_options.show()


## Verifies item_name is in the CraftingDb then expends the scrap and sets the item to be made
func fabricate_item(item_type:String, item_name:String):
#	1. Check that craftables:Dictionary has item_name
	var craft_db_item:Dictionary = {}
	if CraftingDb[item_type].has(item_name):
		craft_db_item = CraftingDb[item_type][item_name]
	else:
		print_debug("ERROR: <", item_name, "> is not a craftable item")
		return
		
#	2. Checks if the necessary scrap is available
	if GameplayManager.remove_scrap(craft_db_item["base_cost"]):
		
#	3. Handles the specifics for each craftable item
		match craft_db_item:
			CraftingDb.drone_augments.random:
				emit_signal("augment_fabricated", AugmentFactory.create_rand_augment())
			CraftingDb.general.stock_drone:
				DroneManager.create_new_drone()
			_:
				print_debug("ERROR: unable to complete craft")
	else:
		print_debug("Insufficient Scrap <", GameplayManager.current_scrap, "/", craft_db_item["base_cost"],">")


## Updates the scrap_amt_label value
func _on_update_scrap_label(scrap_value:float):
	scrap_amt_label.text = "Scrap: %d" % scrap_value


## Emitted when any of the craft option buttons are pressed
func _on_craft_category_btn_pressed(new_category:CRAFT_CATEGORIES):
	craft_category = new_category


## All craft buttons connect here and pass item as a string to specify what they link to
func _on_fabricate_item_button_pressed(item:String):
	match item:
		"drone_augment_random":
			fabricate_item("drone_augments", "random")
		"new_stock_drone":
			fabricate_item("general", "stock_drone")
		_:
			print_debug("ERROR: Unknown item_specific <", item, ">")
