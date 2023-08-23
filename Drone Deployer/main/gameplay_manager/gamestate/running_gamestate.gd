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
		
	elif event.is_action_pressed("toggle_fabricator_menu"):
		MenuManager.request_menu(MenuManager.MENUS.FABRICATOR)
		return STATE.MENU
		
	elif event.is_action_pressed("toggle_hanger_menu"):
		MenuManager.request_menu(MenuManager.MENUS.HANGER)
		return STATE.MENU
		
	return STATE.NULL
