extends Menu

## Main Menu; Starting point of the game


func _on_start_game_btn_pressed():
	GameplayManager.request_start_game()


func _on_quit_btn_pressed():
	get_tree().quit()
