class_name HangerMenu
extends Control

## [Drone] customization and enhancement menu

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
var stats_format_string:String = "Damage: %d\nMax Speed: %d\nMax Battery: %f\nBattery: %f"


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

## Update to display the current focused_drone's stats
func update_display():
	var d:DroneData = focused_drone.data
	drone_name.text = focused_drone.data.display_name
	drone_stats.text = stats_format_string % [d.damage, d.max_speed, d.max_battery, d.battery]

# CURRENTLY USED FOR DEBUGGING PURPOSES
## Applies the selected augments to the currently focused [Drone]
func _on_assemble_btn_pressed():
	for i in DroneManager.drone_library:
		if i.is_drone_state(DroneState.STATE.IDLE):
			print(i)

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
