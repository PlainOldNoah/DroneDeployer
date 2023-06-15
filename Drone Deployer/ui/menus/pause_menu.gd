extends Control


func _on_resume_btn_pressed():
	GameplayManager.toggle_pause()


func _on_quit_btn_pressed():
	GameplayManager.toggle_pause()
	GameplayManager.quit_to_title()
