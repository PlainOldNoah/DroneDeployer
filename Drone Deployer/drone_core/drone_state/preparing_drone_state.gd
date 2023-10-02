extends DroneState

## Preparing State; Transition from Idle to Active

func enter() -> void:
	drone.set_process(true)
	drone.set_physics_process(true)
	drone.disable_collision_shapes(false, false)
	drone.set_visible(true)
	
#	drone.set_collision_mask_value(2, false)

#func process(delta: float) -> int:
##	drone.scale = drone.scale.lerp(Vector2(0.5, 0.5), delta * 1)
#	return drone.drain_battery(delta)


func physics_process(delta: float) -> int:
	move(delta)
	return STATE.NULL

