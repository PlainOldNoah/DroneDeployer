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
#	ARMING, ## Preparing to be active
	PREPARING, ## Getting ready to be Active
	ACTIVE, ## Currently deployed
#	RETURNING, ## Low battery, going home
	LOW_BATTERY, ## Battery is below the set threshold
	PENDING_RETRIEVAL, ## Drone is waiting to be collected
	DEAD, ## No battery, dead in the water
}

var drone:Drone


func enter() -> void:
	pass

func exit() -> void:
	pass

func input(_event: InputEvent) -> int:
	return STATE.NULL

func process(_delta: float) -> int:
	return STATE.NULL

func physics_process(_delta: float) -> int:
	return STATE.NULL


# === ADDITIONAL FUNCTIONS ===

## Moves and collides both normally and with knockback
func move(delta:float):
	var collision:KinematicCollision2D
	
	# Doing knockback
	if drone.data.knockback_velocity.length() > drone.data.knockback_cutoff:
		knockback_movement(delta)
	# Regular movement
	else:
		default_movement(delta)


## Reduces the 'knockback_velocity' and calls 'move_and_collide' with that velocity
func knockback_movement(delta:float):
	drone.data.knockback_velocity = drone.data.knockback_velocity.lerp(Vector2.ZERO, drone.data.acceleration * delta)
	var collision:KinematicCollision2D = drone.move_and_collide(drone.data.knockback_velocity * delta)
	if collision:
		handle_collision(collision)


## How should the drone move when not affected by knockback or other effects
func default_movement(delta:float):
	speed_up(delta)
	var collision:KinematicCollision2D = drone.move_and_collide(drone.velocity * delta)
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
	# Hit anything else
	else:
		default_collision(collision)


## For normal collisions just bounce off of the collider
func default_collision(collision:KinematicCollision2D):
	drone.facing = drone.velocity.bounce(collision.get_normal())


## Lerps from current speed to max speed at the rate of acceleration
func speed_up(delta:float):
	drone.data.speed = lerp(drone.data.speed, drone.data.max_speed, drone.data.acceleration * delta)
	drone.update_velocity()



