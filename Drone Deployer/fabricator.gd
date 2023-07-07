extends Control

## Spend scrap to create augments and upgrades for [Drone]

@onready var ddcc_options := %DDCCOptions
@onready var augment_options := %AugmentsOptions
@onready var upgrade_options := %UpgradesOptions

## The different available crafting options
enum CRAFT_CATEGORIES {DDCC, AUGMENT, UPGRADE}
## The currently selected crafting category
var craft_category:CRAFT_CATEGORIES:
	set(new_category):
		if craft_category != new_category:
			craft_category = new_category
			change_craft_option_tab(new_category)


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


## Emitted when any of the craft option buttons are pressed
func _on_craft_category_btn_pressed(new_category:CRAFT_CATEGORIES):
	craft_category = new_category


## Create a random augment
func _on_random_augment_pressed():
	AugmentFactory.create_rand_augment()
