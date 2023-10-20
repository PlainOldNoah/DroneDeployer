extends Menu

## Group menu consisting of [HangerMenu], [StorageMenu], and [Fabricator]
##
## Pseudo manager type that handles connections between various menus

@onready var hanger:HangerMenu = $HBoxContainer/Hanger
@onready var storage:StorageMenu = $HBoxContainer/Storage
@onready var fabricator:Fabricator = $HBoxContainer/Fabricator

## Currently selected augments from the [StorageMenu]
var selected_augments:Array[AugmentDisplay] = []
## 
var augmented_drone_stats:DroneData = null


func input(event: InputEvent) -> MENU:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("toggle_modification_menu"):
		return MENU.NONE
	elif event.is_action_pressed("toggle_drone_overview"):
		return MENU.DRONE_OVERVIEW
	return MENU.NULL


## Called when the node enters the scene tree for the first time.
func _ready():
	# Tell hanger about currently selected augments/upgrades
	storage.augment_selected.connect(hanger._on_augment_selected)
	storage.upgrade_selected.connect(_on_upgrade_selected)
	# Storage handles putting upgrades together
	fabricator.create_upgrade.connect(storage._on_upgrade_created)


## Controls the flow of Upgrades between Storage and Hanger
func _on_upgrade_selected(upgrade:UpgradeDisplay):
	if upgrade.owner is StorageMenu:
		upgrade.get_parent().remove_child(upgrade)
		hanger.added_upgrades.add_child(upgrade)
		upgrade.owner = hanger

		hanger.link_upgrade(upgrade)
		
		DroneManager.add_upgrade_to_drone(hanger.focused_drone, upgrade.upgrade_data)
		
	elif upgrade.owner is HangerMenu:
		DroneManager.remove_upgrade_from_drone(hanger.focused_drone, upgrade.upgrade_data)
		
		hanger.unlink_upgrade(upgrade)

		upgrade.get_parent().remove_child(upgrade)
		storage.augment_storage.add_child(upgrade)
		upgrade.owner = storage
