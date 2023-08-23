extends BaseState

## Menu Gamestate; Menus except for Pause and Debug


func enter() -> void:
	get_tree().set_pause(true)


func exit() -> void:
	get_tree().set_pause(false)
	MenuManager.request_menu(MenuManager.MENUS.NULL)


func input(event: InputEvent) -> int:
	if event.is_action_pressed("ui_cancel"):
		return STATE.RUNNING
		
	elif event.is_action_pressed("toggle_fabricator_menu"):
		if MenuManager.is_current_menu(MenuManager.MENUS.FABRICATOR):
#			MenuManager.request_menu(MenuManager.MENUS.NULL)
			return STATE.RUNNING
		else:
			MenuManager.request_menu(MenuManager.MENUS.FABRICATOR)
		
	elif event.is_action_pressed("toggle_hanger_menu"):
		if MenuManager.is_current_menu(MenuManager.MENUS.HANGER):
#			MenuManager.request_menu(MenuManager.MENUS.NULL)
			return STATE.RUNNING
		else:
			MenuManager.request_menu(MenuManager.MENUS.HANGER)
		
	return STATE.NULL
