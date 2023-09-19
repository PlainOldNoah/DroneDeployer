extends MovingDroneState

## Active State; Traveling around the board, normal movement state

func enter() -> void:
#	drone.set_collision_mask_value(2, true)
	
	pass
#	drone.set_process(true)
#	drone.set_physics_process(true)
#	drone.disable_collision_shapes(false, false)
#	drone.set_visible(true)
#	drone.exited_shield_area = false
#	drone.collectable = false

func input(_event: InputEvent) -> int:
	return STATE.NULL

func process(delta: float) -> int:
	return drone.drain_battery(delta)
