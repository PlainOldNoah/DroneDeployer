extends MovingDroneState

## Returning State; Heading towards the core for collection

const LERP_WEIGHT:int = 10

func physics_process(delta: float) -> int:
	lerp_home(delta)
	super.physics_process(delta)
	return STATE.NULL


## Gradually go to the DDCC
func lerp_home(delta:float):
	var home_vec:Vector2 = drone.data.home_pos - drone.get_global_position()
	drone.facing = drone.facing.lerp(home_vec, delta * LERP_WEIGHT)
