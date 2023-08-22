extends BaseState

## Paused Gamestate; Stop the game and handle menus

func enter() -> void:
	get_tree().set_pause(true)
	MenuManager.request_menu(MenuManager.MENUS.PAUSE)
	# Request menu based on what key was pressed, this is the menu state afterall


func exit() -> void:
	get_tree().set_pause(false)
	MenuManager.request_menu(MenuManager.MENUS.NULL)


func input(event: InputEvent) -> int:
	if event.is_action_pressed("ui_cancel"):
		return STATE.RUNNING
	return STATE.NULL
