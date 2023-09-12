class_name HangerMenu
extends Control

## [Drone] customization and enhancement menu

signal focused_drone_updated()

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
	Damage: %d
	Critical Chance: %.2f%%
	Critical Damage: %.2f

	Max Battery: %.2f
	Current Battery: %.2f
	Battery Drain: %.2f p/sec
	Recharge Rate: %.2f p/sec

	Acceleration: %.2f
	Max Speed: %d

	Mass: %.2f
	Storage Capacity: %d
	Vacuum Radius: %d
"

var augmented_drone_stats:DroneData = null
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

## Applies each stat from each augment to the drone data
## Update to display the current focused_drone's stats
func update_display(augments:Array[AugmentDisplay]=[]):
	drone_name.text = focused_drone.data.display_name
	
	var d:DroneData = focused_drone.data.duplicate()
	
	for i in augments:
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
	
#	var d:DroneData = augmented_drone_stats # Smaller var name

	drone_stats.text = stats_format_string % [\
		d.damage, 0.0, 0.0,\
		d.max_battery, d.battery, d.battery_drain, 0.0,\
		d.acceleration, d.max_speed,\
		d.mass, 0, 0.0]


## Applies each stat from each augment to the drone data
#func augment_drone_stats(augments:Array[AugmentDisplay]=[]):
#	var d:DroneData = focused_drone.data.duplicate()
#
#	for i in augments:
#		for j in i.augment_data.stats:
#			match j:
#				"acceleration":
#					d.acceleration += i.augment_data.stats[j]
#				"damage":
#					d.damage += i.augment_data.stats[j]
#				"mass":
#					d.mass += i.augment_data.stats[j]
#				"max_battery":
#					d.max_battery += i.augment_data.stats[j]
#				"max_speed":
#					d.max_speed += i.augment_data.stats[j]
#				_:
#					print_debug("ERROR: stat <", j, "> is not defined")
#
#	augmented_drone_stats = d


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
	
	
# CURRENTLY USED FOR DEBUGGING PURPOSES
## Applies the selected augments to the currently focused [Drone]
func _on_assemble_btn_pressed():
	for i in DroneManager.drone_library:
		if i.is_drone_state(DroneState.STATE.IDLE):
			print(i)
