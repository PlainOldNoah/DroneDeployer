extends Control


func _on_restart_btn_pressed():
	GameplayManager.reset_game()
	GameplayManager.start_game()


func _on_title_quit_btn_pressed():
	GameplayManager.toggle_pause(false)
	GameplayManager.quit_to_title()
