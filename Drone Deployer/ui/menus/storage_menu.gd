class_name StorageMenu
extends Control

## Container for holding unused augments and upgrades
##
## Augments and upgrades created in the fabricator are sent here

@onready var augment_storage := %AugmentStorage

@onready var augment_display_scene:PackedScene = preload("res://drone_mods/AugmentDisplay.tscn")


func _ready():
	AugmentFactory.augment_created.connect(add_augment)


## Adds an [Augment] to the augment storage
func add_augment(augment:AugmentData):
	var aug_display:AugmentDisplay = augment_display_scene.instantiate()
	augment_storage.add_child(aug_display)
	
	aug_display.augment_data = augment


## Emitted when [Augment] in storage is clicked
#func _on_augment_selected(augment:Augment):
#	print(augment.stats)
