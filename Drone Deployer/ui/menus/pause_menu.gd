extends Control


func _on_resume_btn_pressed():
	GameplayManager._on_resume_game_requested()


func _on_title_quit_btn_pressed():
	GameplayManager.quit_to_title()
