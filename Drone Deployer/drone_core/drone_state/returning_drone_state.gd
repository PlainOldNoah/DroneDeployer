extends MovingDroneState


func enter() -> void:
	drone.set_velocity_from_vector(drone.home_pos - drone.get_global_position()) # go home

func exit() -> void:
	pass

func input(_event: InputEvent) -> int:
	return STATE.NULL

func process(delta: float) -> int:
	return drone.drain_battery(delta)

func physics_process(delta: float) -> int:
	drone.move(delta)
	return STATE.NULL
