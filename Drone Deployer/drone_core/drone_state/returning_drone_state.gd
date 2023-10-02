extends DroneState

## Returning State; Heading towards the core for collection

const LERP_WEIGHT:int = 10


func process(delta: float) -> int:
	drone.scale = drone.scale.lerp(Vector2(0.25, 0.25), delta * 1)
	return drone.drain_battery(delta)


func physics_process(delta: float) -> int:
	move(delta)
	lerp_home(delta)
	return STATE.NULL


## Gradually go to the DDCC
func lerp_home(delta:float):
	var home_vec:Vector2 = drone.data.home_pos - drone.get_global_position()
	drone.facing = drone.facing.lerp(home_vec, delta * LERP_WEIGHT)
