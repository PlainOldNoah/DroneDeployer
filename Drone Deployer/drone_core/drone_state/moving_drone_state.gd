class_name MovingDroneState
extends DroneState

## Intermediate state to better handle ARMING, ACTIVE, and RETURNING

func enter() -> void:
	pass

func exit() -> void:
	pass

func input(_event: InputEvent) -> int:
	return STATE.NULL

func process(_delta: float) -> int:
	return STATE.NULL

func physics_process(_delta: float) -> int:
	return STATE.NULL
