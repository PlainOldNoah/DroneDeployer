extends DroneState

## Idle State; Inside the DDCC

func enter() -> void:
	drone.set_physics_process(false)
	drone.disable_collision_shapes(true, true)
	drone.set_visible(false)
#	drone.scale = Vector2.ONE * 0.25

	drone.data.speed = 0
	drone.update_velocity()
	
	drone.global_position = drone.data.home_pos
	
	DroneManager.add_drone_to_queue(drone)
	offload_scrap()
	
	drone.emit_signal("state_changed", DroneState.STATE.IDLE)


#func exit() -> void:
#	drone.scale = Vector2.ONE * 0.4


func process(delta: float) -> int:
	if drone.charge_battery(delta):
		drone.set_process(false)
	
#	drone.scale = drone.scale.lerp(Vector2(0.4, 0.4), delta * 10)
	
	return STATE.NULL


## Transfer scrap to GameplayManager and resets storage to 0
func offload_scrap():
	GameplayManager.add_scrap(drone.get_and_reset_scrap())
