extends DroneState


func enter() -> void:
	drone.set_physics_process(false)
	drone.disable_collision_shapes(false, true)
	drone.set_velocity_from_vector(drone.velocity, 0)

func exit() -> void:
	pass

func input(_event: InputEvent) -> int:
	return STATE.NULL

func process(_delta: float) -> int:
	return STATE.NULL

func physics_process(_delta: float) -> int:
	return STATE.NULL



