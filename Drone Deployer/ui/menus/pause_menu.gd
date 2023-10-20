extends Menu

## Pause Menu

func input(event: InputEvent) -> MENU:
	if event.is_action_pressed("ui_cancel"):
		return MENU.NONE
	return MENU.NULL

func _on_resume_btn_pressed():
	GameplayManager._on_resume_game_requested()


func _on_title_quit_btn_pressed():
	GameplayManager.quit_to_title()
