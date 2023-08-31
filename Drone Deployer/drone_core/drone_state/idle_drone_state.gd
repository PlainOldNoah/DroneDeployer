extends DroneState

func enter() -> void:
#	drone.set_process(false)
	drone.set_physics_process(false)
	drone.disable_collision_shapes(true, true)
	drone.set_visible(false)
	drone.set_velocity_from_vector(Vector2i.ZERO, 0)
	drone.global_position = drone.data.home_pos
	
	DroneManager.add_drone_to_queue(drone)


func exit() -> void:
	pass


func process(delta: float) -> int:
	if drone.charge_battery(delta):
		drone.set_process(false)
	return STATE.NULL
