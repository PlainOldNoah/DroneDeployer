class_name StorageMenu
extends Control

## Container for holding unused augments and upgrades
##
## Augments and upgrades created in the fabricator are sent here
## From this menu items can be searched, sorted, and selected for use in the [HangerMenu]

@onready var augment_storage := %AugmentStorage


## Adds an [Augment] to the augment storage
func add_augment(augment:Augment):
	augment_storage.add_child(augment)
	var _ok := augment.connect("augment_selected", _on_augment_selected)


## Emitted when [Augment] in storage is clicked
func _on_augment_selected(augment:Augment):
	print(augment.stat)

# Functions
# Select Augment
# Diselect Augment
#
