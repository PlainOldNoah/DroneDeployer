class_name DroneView
extends Control

## Mini display that displays basic drone information

## The size of each sprite in the stats_icon texture atlas
const STATUS_ICON_SIZE:int = 64

@onready var battery_percent_bar := %BatteryPercentBar
@onready var drone_icon := %DroneIcon
@onready var drone_name := %DroneName
@onready var status_icon := %StatusIcon

## [Drone] that this view is tied to
var linked_drone:Drone:
	set(new_drone):
		linked_drone = new_drone
		establish_connections()
		await linked_drone.ready
		init_view()


## Connect signals from the drone to here
func establish_connections():
	linked_drone.state_changed.connect(_on_state_change)
	linked_drone.data.battery_updated.connect(_on_battery_change)


## Set up initial values from the 'linked_drone'
func init_view():
	drone_name.text = linked_drone.data.display_name
	battery_percent_bar.max_value = linked_drone.data.max_battery
	drone_icon.modulate = linked_drone.data.modulate_color


## Sets the progress bar to the current battery level
func _on_battery_change(new_battery:float):
	battery_percent_bar.value = new_battery


## Sets the 'status_icon' when the 'linked_drone' state changes
func _on_state_change(state:DroneState.STATE):
	var atlas_offset = 0
	
	match state:
		DroneState.STATE.IDLE:
			atlas_offset = 0
		DroneState.STATE.PREPARING:
			atlas_offset = 1
		DroneState.STATE.ACTIVE:
			atlas_offset = 2
		DroneState.STATE.LOW_BATTERY:
			atlas_offset = 3
		DroneState.STATE.PENDING_RETRIEVAL:
			atlas_offset = 4
		DroneState.STATE.DEAD:
			atlas_offset = 5
		_:
			print_debug("ERROR: Undefined state <", state, ">")
	
	status_icon.texture.region.position.x = STATUS_ICON_SIZE * atlas_offset
