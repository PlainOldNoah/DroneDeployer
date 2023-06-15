extends Control

func _on_start_game_btn_pressed():
	GameplayManager.reset_game()
	GameplayManager.start_game()


func _on_quit_btn_pressed():
	get_tree().quit()
