class_name HangerMenu
extends Control

## [Drone] customization and enhancement menu

## Emitted when the focus_drone is assigned
signal focused_drone_updated()
## Emitted when the user wants to 'assemble' the augments to the focused_drone
signal augment_commit_request()

@onready var drone_name := %DroneName
@onready var stat_label := %DroneStats
@onready var drone_stats := %DroneStats
@onready var drone_icon:DroneMirror = %FocusDroneIcon
@onready var added_upgrades := %AddedUpgrades

## Reference to the DroneOverview menu
var drone_overview_ref:Menu

## The [DroneView] linked to the 'focused_drone'
var focused_drone_view:DroneView

## Current drone to apply augments & operations to
var focused_drone:Drone = null:
	set(new_fd):
		focused_drone = new_fd
		update_display()
		drone_icon.linked_drone = focused_drone
		emit_signal("focused_drone_updated")

## Currently selected augments from the [StorageMenu]
var selected_augments:Array[AugmentDisplay] = []

## Drone data with augments applied, used in the display
var staged_drone_data:DroneData

## How the drone stats are displayed in the window
var stats_format_string:String = \
"
	Damage: %d (%d)
	Critical Chance: %.2f%% (%.2f%%)
	Critical Damage: %.2f (%.2f)

	Max Battery: %.2f (%.2f)
	Current Battery: %.2f (%.2f)
	Battery Drain: %.2f p/sec (%.2f)
	Recharge Rate: %.2f p/sec (%.2f)

	Acceleration: %.2f (%.2f)
	Max Speed: %d (%d)

	Mass: %.2f (%.2f)
	Storage Capacity: %d (%d)
	Vacuum Radius: %d (%d)
"

## Drones with their added upgrades
var drone_upgrades:Dictionary = {}


func _ready():
	link_to_drone_overview()


## Link the DroneOverview and Hanger menus together
func link_to_drone_overview():
	await MenuManager.ready
	drone_overview_ref = MenuManager.menus[Menu.MENU.DRONE_OVERVIEW]
#	drone_overview_ref.hanger_ref = self
	drone_overview_ref.drone_selected.connect(_on_new_drone_selected)


## Refreshes the display with correct drone-augment data/stats
## [br]New Drone, New focused_drone, selecting augments, assembling
func update_display():
	# Real Data
	var rd:DroneData = focused_drone.data
	# Augmented Data
	var ad:DroneData = augment_drone_data(rd)
	
	drone_name.text = rd.display_name
	
	# Set the stats display
	drone_stats.text = stats_format_string % [\
		rd.damage,ad.damage,\
		0.0,0.0,\
		0.0,0.0,\
		rd.max_battery,ad.max_battery,\
		rd.battery,ad.battery,\
		rd.battery_drain,ad.battery_drain,\
		0.0,0.0,\
		rd.acceleration,ad.acceleration,\
		rd.max_speed,ad.max_speed,\
		rd.mass,ad.mass,\
		0,0,\
		0.0,0.0,\
		]
	
	show_drone_upgrades()


## Return a unique version of drone_data, modified by selected_augments
func augment_drone_data(drone_data:DroneData) -> DroneData:
	# Create new DroneData resource
	var d:DroneData = DroneData.new()
	
	# '.duplicate' doesn't work correctly, need to do it manually
	d.clone_from(drone_data)
	
	# Apply the augments
	for i in selected_augments:
		for j in i.augment_data.stats:
			match j:
				"ACCELERATION":
					d.acceleration += i.augment_data.stats[j]
				"DAMAGE":
					d.damage += i.augment_data.stats[j]
				"MASS":
					d.mass += i.augment_data.stats[j]
				"MAX_BATTERY":
					d.max_battery += i.augment_data.stats[j]
				"MAX_SPEED":
					d.max_speed += i.augment_data.stats[j]
				_:
					print_debug("ERROR: stat <", j, "> is not defined")
	
	return d


## === Drone Upgrades ===

## Links the current upgrade to the 'focused_drone' mirror
func link_upgrade(upgrade:UpgradeDisplay):
	if drone_upgrades.has(focused_drone):
		drone_upgrades[focused_drone].append(upgrade)
	else:
		drone_upgrades[focused_drone] = [upgrade]


## Removes the upgrade from the currently focused_drone it was attached to
func unlink_upgrade(upgrade:UpgradeDisplay):
	if drone_upgrades.has(focused_drone) and drone_upgrades[focused_drone].has(upgrade):
		drone_upgrades[focused_drone].erase(upgrade)


## Shows upgrades linked to the focused drone and hide all others
func show_drone_upgrades():
	var visible_upgrades:Array = drone_upgrades[focused_drone] if drone_upgrades.has(focused_drone) else []
	for i in added_upgrades.get_children():
		if visible_upgrades.has(i):
			i.show()
		else:
			i.hide()


## === Focus Drone selection ===

## Open up the DroneOverview menu
func _on_focus_drone_icon_pressed():
	MenuManager.request_menu(Menu.MENU.DRONE_OVERVIEW)

## 
func _on_new_drone_selected(drone_view:DroneView):
	focused_drone_view = drone_view
	focused_drone = drone_view.linked_drone
	MenuManager.request_menu(Menu.MENU.MODIFICATION)


## Cycles to the previous drone from the DroneOverview menu
func _on_previous_drone_pressed():
	if focused_drone_view:
		var new_view:DroneView = drone_overview_ref.get_view_from_offset(focused_drone_view, -1)
		_on_new_drone_selected(new_view)


## Cycles to the next drone from the DroneOverview menu
func _on_next_drone_pressed():
	if focused_drone_view:
		var new_view:DroneView = drone_overview_ref.get_view_from_offset(focused_drone_view, 1)
		_on_new_drone_selected(new_view)


## === Misc Signals ===

## Applies the selected augments to the currently focused [Drone]
func _on_assemble_btn_pressed():
	focused_drone.data = augment_drone_data(focused_drone.data)
	
	for i in selected_augments:
		i.queue_free()
	
	selected_augments.clear()
	update_display()


## Unselects all currently selected augments
func _on_clear_btn_pressed():
	selected_augments.clear()
	update_display()


## Changes the focused drone's name from the line edit
func _on_drone_name_text_submitted(new_text):
	focused_drone.data.display_name = new_text


## Recieved from [StorageMenu] when augment is clicked
func _on_augment_selected(augment:AugmentDisplay):
	if (augment.selected == false) and (selected_augments.has(augment)):
		selected_augments.erase(augment)
	else:
		selected_augments.append(augment)
	
	update_display()
