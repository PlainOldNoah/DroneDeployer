extends BaseState

## Running Gamestate; Middle of gameplay

func enter() -> void:
	# resume timer
	pass


func exit() -> void:
	# pause timer
	pass


func input(event: InputEvent) -> int:
	if event.is_action_pressed("ui_cancel"):
		return STATE.PAUSED
	return STATE.NULL
