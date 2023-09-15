class_name HangerMenu
extends Control

## [Drone] customization and enhancement menu

## Emitted when the focus_drone is assigned
signal focused_drone_updated()
## Emitted when the user wants to 'assemble' the augments to the focused_drone
signal augment_commit_request()

@onready var drone_name := %DroneName
@onready var stat_label:Label = %DroneStats
@onready var drone_stats := %DroneStats
@onready var drone_icon:DroneMirror = %FocusDroneIcon
@onready var drone_selection_popup := %DroneSelectionPopup

#@onready var added_augment_view := %AddedAugments
#@onready var available_augments := $HBoxContainer/VBoxContainer/AvailableAugments

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

## Current position when cycling though drones in the drone library
var library_index:int = 0:
	set(new_index):
		library_index = new_index
		if library_index >= DroneManager.drone_library.size():
			library_index = 0
		elif library_index < 0:
			library_index = DroneManager.drone_library.size() - 1
	
		print("LI: ", library_index, " // ", DroneManager.drone_library.size())

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

#var augmented_drone_stats:DroneData = null
#var selected_augments:Array[AugmentDisplay] = []

func _ready():
	DroneManager.drone_created.connect(update_drone_list)
	drone_selection_popup.d_mirror_selected.connect(_on_new_drone_selected)

## Recieved when a new drone is created
func update_drone_list(drone:Drone):
	await drone.ready
	drone_selection_popup.add_drone_mirror(drone)
	
	if (focused_drone == null) and (not DroneManager.drone_library.is_empty()):
		select_focus_drone(library_index)
		update_display()


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
				"acceleration":
					d.acceleration += i.augment_data.stats[j]
				"damage":
					d.damage += i.augment_data.stats[j]
				"mass":
					d.mass += i.augment_data.stats[j]
				"max_battery":
					d.max_battery += i.augment_data.stats[j]
				"max_speed":
					d.max_speed += i.augment_data.stats[j]
				_:
					print_debug("ERROR: stat <", j, "> is not defined")
	
	return d


## --- Focus Drone selection ---

## Sets the focused_drone to the drone in the library at position 'index'
func select_focus_drone(index:int):
	focused_drone = DroneManager.drone_library[index]

## Cycles to the next drone library
func _on_next_drone_pressed():
	library_index += 1
	select_focus_drone(library_index)

## Cycles to the previous drone in the drone library
func _on_previous_drone_pressed():
	library_index -= 1
	select_focus_drone(library_index)

## Open the drone selector screen
func _on_focus_drone_icon_pressed():
	drone_selection_popup.show()

## Sets the focused_drone to drone
func _on_new_drone_selected(drone:Drone):
	focused_drone = drone
	library_index = DroneManager.drone_library.find(focused_drone)

## --- Misc Signals ---

## Applies the selected augments to the currently focused [Drone]
func _on_assemble_btn_pressed():
	focused_drone.data = augment_drone_data(focused_drone.data)
	
	for i in selected_augments:
		i.queue_free()
	
	selected_augments.clear()
	update_display()


## Recieved from [StorageMenu] when augment is clicked
func _on_augment_selected(augment:AugmentDisplay):
	if (augment.selected == false) and (selected_augments.has(augment)):
		selected_augments.erase(augment)
	else:
		selected_augments.append(augment)
	
	update_display()


## Changes the focused drone's name from the line edit
func _on_drone_name_text_submitted(new_text):
	focused_drone.data.display_name = new_text
