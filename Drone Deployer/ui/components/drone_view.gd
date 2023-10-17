class_name DroneView
extends Control

## Mini display that displays basic drone information

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
		update_view()


func establish_connections():
	linked_drone.state_changed.connect(_on_state_change)
#	signals from the drone are emitted and recieved here
#	link battery to the progress bar
	pass


func update_view():
	drone_name.text = linked_drone.data.display_name
	battery_percent_bar.value = linked_drone.data.battery / linked_drone.data.max_battery
	drone_icon.modulate = linked_drone.data.modulate_color


## Recieved when the 'linked_drone' state changes
func _on_state_change(state:DroneState.STATE):
	match state:
		DroneState.STATE.IDLE:
			print("Drone is in idle state")
