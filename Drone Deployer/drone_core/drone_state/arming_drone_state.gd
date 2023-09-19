extends MovingDroneState

## Arming State; Transition from Idle to Active

func enter() -> void:
	drone.set_process(true)
	drone.set_physics_process(true)
	drone.disable_collision_shapes(false, false)
	drone.set_visible(true)
	
#	drone.set_collision_mask_value(2, false)
