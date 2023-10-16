class_name UpgradeDisplay
extends Control

## Shows an icon for a given Drone Upgrade, displays more info on mouse hover

signal upgrade_selected(upgrade:UpgradeDisplay) 

@onready var icon := $PanelContainer/Icon
@onready var hover_text_box := $Label

## If the augment is selected or not, used with [StorageMenu]
#var selected:bool = false:
#	set(new_state):
#		selected = new_state
#		emit_signal("upgrade_selected", self)


## Augment itself; Where the display gets its info from
var upgrade_data:DroneUpgradeData = null:
	set(new_data):
		upgrade_data = new_data
		if upgrade_data != null:
			update_display()


func update_display():
	hover_text_box.text = upgrade_data.short_desc


func _on_interaction_area_pressed():
#	selected = !selected
	emit_signal("upgrade_selected", self)


func _on_interaction_area_mouse_entered():
	hover_text_box.visible = true


func _on_interaction_area_mouse_exited():
	hover_text_box.visible = false
