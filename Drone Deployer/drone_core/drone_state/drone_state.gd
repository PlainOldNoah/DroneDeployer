class_name DroneState
extends Node

## Base state for all of the drone states
##
## @tutorial(State Machine Example): https://www.youtube.com/watch?v=Bm3sRxDb3js
## @tutorial(Advanced State Machine): https://www.youtube.com/watch?v=DPxIMVC0oZA
## @tutorial(Example Git Repo): https://github.com/theshaggydev/the-shaggy-dev-projects/tree/main/projects/godot-3/advanced-state-machine

enum STATE {
	NULL, ## No State
	IDLE, ## Waiting to be deployed
	PREPARING, ## Getting ready to be Active
	ACTIVE, ## Currently deployed
	LOW_BATTERY, ## Battery is below the set threshold
	PENDING_RETRIEVAL, ## Drone is waiting to be collected
	DEAD, ## No battery, dead in the water
}

var drone:Drone

func enter() -> void:
	pass

func exit() -> void:
	pass

func input(_event: InputEvent) -> STATE:
	return STATE.NULL

func process(_delta: float) -> STATE:
	return STATE.NULL

func physics_process(_delta: float) -> STATE:
	return STATE.NULL


# === ADDITIONAL FUNCTIONS ===

# --- Movement ---

## Moves and collides both normally and with knockback
func move(delta:float) -> STATE:
	# Doing knockback
	if drone.data.knockback_velocity.length() > drone.data.knockback_cutoff:
		return knockback_movement(delta)
	# Regular movement
	else:
		return default_movement(delta)


## Reduces the 'knockback_velocity' and calls 'move_and_collide' with that velocity
func knockback_movement(delta:float) -> STATE:
	drone.data.knockback_velocity = drone.data.knockback_velocity.lerp(Vector2.ZERO, drone.data.acceleration * delta)
	var collision:KinematicCollision2D = drone.move_and_collide(drone.data.knockback_velocity * delta)
	if collision:
		handle_collision(collision)
	
	return STATE.NULL


## How should the drone move when not affected by knockback or other effects
func default_movement(delta:float) -> STATE:
	speed_up(delta)
	var collision:KinematicCollision2D = drone.move_and_collide(drone.velocity * delta)
	if collision:
			return handle_collision(collision)
	
	return STATE.NULL

# --- Collisions ---

## Handles what happens when drone is colliding
func handle_collision(collision:KinematicCollision2D) -> STATE:
	var collider = collision.get_collider()
	
	# Stop movement
	drone.data.speed = 0
	
	# Drone collision
	if collider.is_in_group("drone"):
		return drone_collision(collision)
	# DDCC collision
	elif collider.is_in_group("ddcc"):
		return ddcc_collision(collision)
	# Anything else collision
	else:
		return default_collision(collision)


## For collisions involving [Drone]
func drone_collision(collision:KinematicCollision2D) -> STATE:
	var collider = collision.get_collider()
	drone.data.knockback_velocity = collider.global_position.direction_to(drone.global_position) * 50 # Drone Mass
	return STATE.NULL

## For collisions involving [DDCC]
func ddcc_collision(collision:KinematicCollision2D) -> STATE:
	default_collision(collision)
	return STATE.NULL

## For normal collisions just bounce off of the collider
func default_collision(collision:KinematicCollision2D) -> STATE:
	drone.facing = drone.velocity.bounce(collision.get_normal())
	return STATE.NULL

# --- Misc ---

## Lerps from current speed to max speed at the rate of acceleration
func speed_up(delta:float):
	drone.data.speed = lerp(drone.data.speed, drone.data.max_speed, drone.data.acceleration * delta)
	drone.update_velocity()
