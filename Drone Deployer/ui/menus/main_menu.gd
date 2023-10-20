extends Menu

## Main Menu; Starting point of the game

func open():
	show()

func close():
	hide()


func _on_start_game_btn_pressed():
	GameplayManager.request_start_game()
#	MenuManager.request_menu(Menu.MENU.NONE)
#	GameplayManager._on_start_game_requested()


func _on_quit_btn_pressed():
	get_tree().quit()
