class_name StorageMenu
extends Control

## Container for holding unused augments and upgrades
##
## Augments and upgrades created in the fabricator are sent here

## Emitted when an augment is selected/deselected
signal augment_selected(augment:AugmentDisplay)
## Emitted when an upgrade is selected/deselected
signal upgrade_selected(upgrade:UpgradeDisplay)

@onready var augment_storage := %AugmentStorage

## [AugmentDisplay] file path
@export var augment_display_scene:PackedScene


func _ready():
	AugmentFactory.augment_created.connect(add_augment)


## Adds an [AugmentDisplay] with [AugmentData] to the augment storage
func add_augment(augment:AugmentData):
	var aug_display:AugmentDisplay = augment_display_scene.instantiate()
	augment_storage.add_child(aug_display)
	augment_storage.move_child(aug_display, 0)
	aug_display.augment_selected.connect(_on_augment_selected)
	
	aug_display.augment_data = augment


## Emit 'augment_selected' when [AugmentDisplay] in storage is clicked
func _on_augment_selected(augment:AugmentDisplay):
	emit_signal("augment_selected", augment)


## Package [DroneUpgradeData] into [UpgradeDisplay]; Signal recieved from [Fabricator]
func _on_upgrade_created(new_upgrade:DroneUpgradeData):
	var upgrade_display = preload("res://drone_mods/upgrades/drone_upgrade_display.tscn").instantiate()
	augment_storage.add_child(upgrade_display)
	upgrade_display.owner = self
	upgrade_display.upgrade_selected.connect(_on_upgrade_selected)
	upgrade_display.upgrade_data = new_upgrade


## Emit 'upgrade_selected' when [UpgradeDisplay] in storage is clicked
func _on_upgrade_selected(upgrade:UpgradeDisplay):
	emit_signal("upgrade_selected", upgrade)
