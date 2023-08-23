extends Control


func _on_restart_btn_pressed():
	GameplayManager._on_start_game_requested()


func _on_title_quit_btn_pressed():
	GameplayManager.quit_to_title()
