class_name StorageMenu
extends Control

## Container for holding unused augments and upgrades
##
## Augments and upgrades created in the fabricator are sent here

@onready var augment_storage := %AugmentStorage

## [AugmentDisplay] file path
@onready var augment_display_scene:PackedScene = preload("res://drone_mods/augment_display.tscn")

## Array of all currently selected [AugmentDisplay]
var selected_augments:Array[AugmentDisplay] = []

func _ready():
	AugmentFactory.augment_created.connect(add_augment)


## Adds an [AugmentDisplay] with [AugmentData] to the augment storage
func add_augment(augment:AugmentData):
	var aug_display:AugmentDisplay = augment_display_scene.instantiate()
	augment_storage.add_child(aug_display)
	aug_display.augment_selected.connect(_on_augment_selected)
	
	aug_display.augment_data = augment


## Emitted when [AugmentDisplay] in storage is clicked
func _on_augment_selected(augment:AugmentDisplay):
	if (augment.selected == false) and (selected_augments.has(augment)):
		selected_augments.erase(augment)
	else:
		selected_augments.append(augment)
	
	print(selected_augments)
