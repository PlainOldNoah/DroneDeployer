@tool
class_name CraftableButton
extends Control

## Interface between player and [CraftableData]

## Emitted when clicked; Echoed from internal button press
signal pressed(craftable_data:CraftableData)

## [CraftableData] that button will reference
@export var craftable_data:CraftableData = null:
	set(new_data):
		craftable_data = new_data
		if craftable_data:
			update_labels()
		else:
			clear_labels()


## Reset all labels to default/empty values
func clear_labels():
	%NameLabel.text = "No Data"
	%DescLabel.text = "No Data"
	%CostLabel.text = "No Data"

## Updates labels and icon to match craftable_data
func update_labels():
	%NameLabel.text = craftable_data.craftable_name
	%DescLabel.text = craftable_data.description
	%CostLabel.text = "Cost: " + str(craftable_data.base_cost)


func _on_button_pressed():
	emit_signal("pressed", craftable_data)
