extends Control

## Spend scrap to create augments and upgrades for [Drone]
##
## To add a new craftable item:
## [br]1. Create a button within the correct CRAFT_CATEGORIES
## [br]2. Add the item to the craftables:Dictionary
## [br]3. Add the item to the fabricate_item's match statement

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


## All existing craftable items
var craftables:Dictionary = {
	"repair_kit":{
		"cost":1
	},
	"rand_augment":{
		"cost":2
	}
}


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


## Verifies item_name is in the craftables dict then expends the scrap and sets the item to be made
func fabricate_item(item_name:String):
#	1. Check that craftables:Dictionary has item_name
	if not craftables.has(item_name):
		print_debug("ERROR: <", item_name, "> is not a craftable item")
		return

#	2. Checks if the necessary scrap is available
	if GameplayManager.remove_scrap(craftables[item_name]["cost"]):

#	3. Handles the specifics for each craftable item
		match craftables[item_name]:
			craftables.rand_augment:
				AugmentFactory.create_rand_augment()
			_:
				print_debug("ERROR: unable to complete craft")
#	else:
#		print_debug("Insufficient Scrap <", GameplayManager.current_scrap, "/", craftables[item_name]["cost"],">")


## Updates the scrap_amt_label value
func _on_update_scrap_label(scrap_value:float):
	scrap_amt_label.text = "Scrap: %d" % scrap_value


## Emitted when any of the craft option buttons are pressed
func _on_craft_category_btn_pressed(new_category:CRAFT_CATEGORIES):
	craft_category = new_category


## Create a random augment
func _on_random_augment_pressed():
	fabricate_item("rand_augment")
