extends Menu

## Gameover Menu; After losing the game go here

func _on_restart_btn_pressed():
	MenuManager.request_menu(Menu.MENU.NONE)
	GameplayManager._on_start_game_requested()


func _on_title_quit_btn_pressed():
	MenuManager.request_menu(Menu.MENU.MAIN)
#	GameplayManager.quit_to_title()
