extends DroneState


func enter() -> void:
#	drone.set_physics_process(false)
	drone.disable_collision_shapes(false, true)
#	drone.set_velocity_from_vector(drone.velocity, 0)
#	drone.data.speed = 0
#	drone.update_velocity()
	

func exit() -> void:
	pass

func input(_event: InputEvent) -> int:
	return STATE.NULL

func process(_delta: float) -> int:
	return STATE.NULL

func physics_process(delta: float) -> int:
	drone.data.speed = lerpf(drone.data.speed, 0.0, delta * 3)
	print(drone.data.speed)
	
	if drone.data.speed <= 5:
		drone.data.speed = 0
		drone.set_physics_process(false)
		
	drone.update_velocity()
	drone.move_and_collide(drone.velocity * delta)
	return STATE.NULL

#drone.facing = drone.facing.lerp(home_vec, delta * LERP_WEIGHT)

