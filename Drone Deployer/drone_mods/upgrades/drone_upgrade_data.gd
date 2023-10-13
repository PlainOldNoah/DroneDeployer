class_name DroneUpgradeData
extends Resource

## Contains data about [DroneUpgrade]

## Brief description of what this upgrade will do
@export_multiline var short_desc:String = ""
## Full details on what this upgrade will do
@export_multiline var long_desc:String = ""
## What texture will represent this upgrade in menus
@export var icon:Texture2D = null

## What [DroneUpgrade] behavior scene should be added to [Drone]
@export var upgrade_behavior:PackedScene = null

## Specific reference to the 'upgrade_behavior' created
var behavior_scene_ref:DroneUpgrade = null
