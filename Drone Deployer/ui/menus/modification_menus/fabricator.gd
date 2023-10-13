class_name Fabricator
extends Control

## Spend scrap to create augments and upgrades

## Emitted when new upgrade data is created
signal create_upgrade(new_upgrade:DroneUpgradeData)

@onready var scrap_amt_label := %ScrapAmount

func _ready():
	var _ok := GameplayManager.connect("curr_scrap_updated", _on_update_scrap_label)

## Updates the scrap_amt_label value
func _on_update_scrap_label(scrap_value:float):
	scrap_amt_label.text = "Scrap: %d" % scrap_value


# === Crafting Buttons ===

## Craft a random augment
func _on_craft_random_augment_pressed(craftable_data:CraftableData):
	if GameplayManager.remove_scrap(craftable_data.base_cost):
		AugmentFactory.create_rand_augment()

## Craft a new, blank, drone
func _on_craft_stock_drone_pressed(craftable_data:CraftableData):
	if GameplayManager.remove_scrap(craftable_data.base_cost):
		DroneManager.create_new_drone()

## Heal the DDCC an amount
func _on_craft_repair_kit_pressed(craftable_data:CraftableData):
	if GameplayManager.remove_scrap(craftable_data.base_cost):
		GameplayManager.ddcc_health += 3


func _on_craft_drone_upgrade_pressed(craftable_data:CraftableData):
	if GameplayManager.remove_scrap(craftable_data.base_cost):
		create_mock_upgrade()


# === Move Later ===
func create_mock_upgrade():
	var new_upgrade:DroneUpgradeData = load("res://drone_mods/upgrades/mock_upgrade_data.tres")
	emit_signal("create_upgrade", new_upgrade)
