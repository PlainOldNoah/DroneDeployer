class_name MovingDroneState
extends DroneState

## Intermediate state to better handle ARMING, ACTIVE, and RETURNING

func enter() -> void:
	pass

func exit() -> void:
	pass

func input(_event: InputEvent) -> int:
	return STATE.NULL

func process(_delta: float) -> int:
	return STATE.NULL

func physics_process(delta: float) -> int:
	move(delta)
	return STATE.NULL


# ---------------

## Moves and collides both normally and with knockback
func move(delta:float):
	var collision:KinematicCollision2D
	
	# Doing knockback
	if drone.data.knockback_velocity.length() > drone.data.knockback_cutoff:
		handle_knockback(delta)
		drone.move_and_collide(drone.data.knockback_velocity * delta)
	# Regular movement
	else:
		speed_up(delta)
		drone.update_velocity()
		
		collision = drone.move_and_collide(drone.velocity * delta)
	
	if collision:
		handle_collision(collision)


## Handles what happens when drone is colliding
func handle_collision(collision:KinematicCollision2D):
	var collider = collision.get_collider()
	
	# Stop movement
	drone.data.speed = 0
	
	# Hit drone
	if collider.is_in_group("drone"):
		drone.data.knockback_velocity = collider.global_position.direction_to(drone.global_position) * 50 # Drone Mass
	# Battery low
	elif (drone.data.battery / drone.data.max_battery) <= drone.data.low_battery_threshold:
		drone.drone_state_manager.change_state(DroneState.STATE.RETURNING)
	# Hit anything else
	else:
		drone.facing = drone.velocity.bounce(collision.get_normal())


func speed_up(delta:float):
	drone.data.speed = lerp(drone.data.speed, drone.data.max_speed, drone.data.acceleration * delta)
	drone.update_velocity()


## Lerps the knockback_velocity to 0
func handle_knockback(delta:float):
	drone.data.knockback_velocity = drone.data.knockback_velocity.lerp(Vector2.ZERO, drone.data.acceleration * delta)
