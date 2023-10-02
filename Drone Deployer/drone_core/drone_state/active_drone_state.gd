extends DroneState

## Active State; Traveling around the board, normal movement state


func process(delta: float) -> int:
	return drone.drain_battery(delta)


func physics_process(delta: float) -> int:
	move(delta)
	return STATE.NULL
