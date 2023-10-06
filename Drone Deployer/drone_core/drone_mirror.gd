class_name DroneMirror
extends Button

## Displays a linked drone's graphical information and is clickable

@onready var btn_icon := $MarginContainer/TextureRect

## The [Drone] that this mirror is linked to
var linked_drone:Drone = null:
	set(new_ld):
		linked_drone = new_ld
		if linked_drone != null:
			update_icon()


## Update the button icon color to that of the linked_drone's
func update_icon():
	if linked_drone != null:
#		$MarginContainer/TextureRect.modulate = linked_drone.data.modulate_color
#		await self.ready # Wait for btn_icon to 'exist'
		btn_icon.modulate = linked_drone.data.modulate_color
