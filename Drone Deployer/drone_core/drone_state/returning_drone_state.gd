extends DroneState


func enter() -> void:
	# Set target for the DDCC
	pass

func exit() -> void:
	pass

func input(_event: InputEvent) -> int:
	return STATE.NULL

func process(delta: float) -> int:
	return drone.drain_battery(delta)

func physics_process(delta: float) -> int:
	drone.move(delta)
	return STATE.NULL
