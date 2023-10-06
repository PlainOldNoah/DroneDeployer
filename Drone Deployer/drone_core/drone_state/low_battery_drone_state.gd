extends DroneState

## Low Battery State; Battery is below the threshold

func process(delta: float) -> STATE:
	return drone.drain_battery(delta)


func physics_process(delta: float) -> STATE:
	return move(delta)
#	return STATE.NULL


## Inject code to navigate to home for each collision
#func handle_collision(collision:KinematicCollision2D):
#	super(collision)
#	drone.facing = drone.data.home_pos - drone.get_global_position()


func ddcc_collision(_collision:KinematicCollision2D) -> STATE:
	return STATE.PENDING_RETRIEVAL

## For collisions involving [Drone]
func drone_collision(collision:KinematicCollision2D) -> STATE:
	super(collision)
	drone.facing = drone.data.home_pos - drone.get_global_position()
	return STATE.NULL

## For normal collisions just bounce off of the collider
func default_collision(collision:KinematicCollision2D) -> STATE:
	super(collision)
	drone.facing = drone.data.home_pos - drone.get_global_position()
	return STATE.NULL

#const LERP_WEIGHT:int = 10

## Gradually go to the DDCC
#func lerp_home(delta:float):
#	var home_vec:Vector2 = drone.data.home_pos - drone.get_global_position()
#	drone.facing = drone.facing.lerp(home_vec, delta * LERP_WEIGHT)
