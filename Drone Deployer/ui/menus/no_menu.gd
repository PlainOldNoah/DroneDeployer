extends Menu

## No Menu; Pseudo node to represent not having a menu open

func input(event: InputEvent) -> MENU:
	if event.is_action_pressed("toggle_drone_overview"):
		return(MENU.DRONE_OVERVIEW)
	elif event.is_action_pressed("toggle_modification_menu"):
		return(MENU.MODIFICATION)
	elif event.is_action_pressed("ui_cancel"):
		return(MENU.PAUSE)
	
	return MENU.NULL
