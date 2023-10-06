extends DroneState

## Returning State; Heading towards the core for collection

func process(delta: float) -> int:
	return drone.drain_battery(delta)


func physics_process(delta: float) -> int:
	move(delta)
	return STATE.NULL


## Inject code to navigate to home for each collision
func handle_collision(collision:KinematicCollision2D):
	super(collision)
	drone.facing = drone.data.home_pos - drone.get_global_position()


#const LERP_WEIGHT:int = 10

## Gradually go to the DDCC
#func lerp_home(delta:float):
#	var home_vec:Vector2 = drone.data.home_pos - drone.get_global_position()
#	drone.facing = drone.facing.lerp(home_vec, delta * LERP_WEIGHT)
