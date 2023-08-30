extends MovingDroneState

## Arming State; Transition from Idle to Active

func enter() -> void:
	drone.set_process(true)
	drone.set_physics_process(true)
	drone.disable_collision_shapes(false, false)
	drone.set_visible(true)

func exit() -> void:
	pass

func input(_event: InputEvent) -> int:
	return STATE.NULL

func process(_delta: float) -> int:
	return STATE.NULL

func physics_process(delta: float) -> int:
	drone.move(delta)
	return STATE.NULL
