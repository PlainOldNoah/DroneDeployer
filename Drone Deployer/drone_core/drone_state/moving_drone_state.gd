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
	
#	print(knockback_velocity.length(), " // ", knockback_velocity)
	
	# Doing knockback
	if drone.data.knockback_velocity.length() > drone.data.knockback_cutoff:
		handle_knockback(delta)
		drone.move_and_collide(drone.data.knockback_velocity * delta)
	# Regular movement
	else:
		speed_up(delta)
#		drone.set_velocity_from_radians(drone.velocity.angle(), drone.data.speed)
		
		collision = drone.move_and_collide(drone.velocity * delta)
		drone.set_facing_direction(false)
	
	if collision:
		handle_collision(collision)


## Handles what happens when drone is colliding
func handle_collision(collision:KinematicCollision2D):
	var collider = collision.get_collider()
#	drone.data.speed = 0
	
	# Hit drone
	if collider.is_in_group("drone"):
		drone.data.knockback_velocity = collider.global_position.direction_to(drone.global_position) * 50
	# Battery low
	elif (drone.data.battery / drone.data.max_battery) <= drone.data.low_battery_threshold:
		drone.drone_state_manager.change_state(DroneState.STATE.RETURNING)
		
	else:
		drone.set_velocity_from_vector(drone.velocity.bounce(collision.get_normal()))

#var direction:Vector2 = Vector2.ZERO
func speed_up(delta:float):
#	print(drone.data.speed, ", ", drone.data.max_speed)
	print(drone.data.speed)
	drone.data.speed = lerp(drone.data.speed, drone.data.max_speed, drone.data.acceleration * delta)
	drone.velocity = drone.velocity.normalized() * drone.data.speed


## Lerps the knockback_velocity to 0
func handle_knockback(delta:float):
	drone.data.knockback_velocity = drone.data.knockback_velocity.lerp(Vector2.ZERO, 1 * delta)
