class_name UpgradeDisplay
extends Control

## Shows an icon for a given Drone Upgrade, displays more info on mouse hover

signal upgrade_selected(upgrade:UpgradeDisplay) 

@onready var icon := $PanelContainer/Icon

## If the augment is selected or not, used with [StorageMenu]
var selected:bool = false:
	set(new_state):
		selected = new_state
		emit_signal("upgrade_selected", self)

## Augment itself; Where the display gets its info from
var upgrade_data:DroneUpgradeData = null:
	set(new_data):
		upgrade_data = new_data
		if upgrade_data != null:
			clear_display()
			update_display()

## Sets all visible elements to their default values
func clear_display():
	icon.texture = null


func update_display():
	pass
