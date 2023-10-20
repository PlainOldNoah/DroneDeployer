extends GameState

## Paused Gamestate; Stop the game and handle menus

#func enter() -> void:
#	get_tree().set_pause(true)
#	MenuManager.request_menu(Menu.MENU.PAUSE)
#
#
#func exit() -> void:
#	get_tree().set_pause(false)
#	MenuManager.request_menu(Menu.MENU.NONE)


#func input(event: InputEvent) -> int:
#	if event.is_action_pressed("ui_cancel"):
#		return STATE.RUNNING
#	elif event.is_action_pressed("toggle_fabricator_menu"):
#		MenuManager.request_menu(MenuManager.MENUS.FABRICATOR)
#	elif event.is_action_pressed("toggle_hanger_menu"):
#		MenuManager.request_menu(MenuManager.MENUS.HANGER)
#	return STATE.NULL
