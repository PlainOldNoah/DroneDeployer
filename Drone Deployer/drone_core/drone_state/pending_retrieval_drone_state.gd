extends DroneState

## Pending Retrieval State; Waiting for collection by [DDCC]

func physics_process(delta: float) -> STATE:
	if drone.data.speed >= 10:
		slow_down(delta)
		drone.move_and_collide(drone.velocity * delta)
	else:
		drone.rotate(0.2)
		
	return STATE.NULL


#func process(_delta: float) -> STATE:
#	drone.rotate(0.2)
#	return STATE.NULL


## Reduces movement to 0 to allow for DDCC pickup
func slow_down(delta:float):
	drone.data.speed = lerp(drone.data.speed, 0.0, 10 * delta)
	drone.update_velocity()
