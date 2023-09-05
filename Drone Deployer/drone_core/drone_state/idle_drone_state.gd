extends DroneState

## Idle State; Inside the DDCC

func enter() -> void:
	drone.set_physics_process(false)
	drone.disable_collision_shapes(true, true)
	drone.set_visible(false)
	drone.set_velocity_from_vector(Vector2i.ZERO, 0)
	drone.global_position = drone.data.home_pos
	
	DroneManager.add_drone_to_queue(drone)
	offload_scrap()
	
	drone.emit_signal("state_changed", DroneState.STATE.IDLE)


func process(delta: float) -> int:
	if drone.charge_battery(delta):
		drone.set_process(false)
	return STATE.NULL


## Transfer scrap to GameplayManager and resets storage to 0
func offload_scrap():
	GameplayManager.add_scrap(drone.get_and_reset_scrap())
