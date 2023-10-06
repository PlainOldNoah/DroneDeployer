extends DroneState

## Active State; Traveling around the board, normal movement state


func process(delta: float) -> STATE:
	return drone.drain_battery(delta)


func physics_process(delta: float) -> STATE:
	return move(delta)
