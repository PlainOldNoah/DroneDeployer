extends DroneUpgrade

## Mock Drone Behavior, used for debugging and testing

func init(linked_drone:Drone):
	super(linked_drone)
	linked_drone.state_changed.connect(_on_state_change)


func _process(_delta):
	$Sprite2D.rotate(0.1)


## Change behavior based on [DroneState]
func _on_state_change(new_state:DroneState.STATE):
	match new_state:
		DroneState.STATE.LOW_BATTERY:
			modulate = Color.DARK_RED
		DroneState.STATE.ACTIVE:
			modulate = Color.FOREST_GREEN
		DroneState.STATE.IDLE:
			modulate = Color.WHITE
