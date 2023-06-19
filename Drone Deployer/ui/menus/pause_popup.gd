extends Control


func _on_resume_btn_pressed():
	GameplayManager.toggle_pause(false)


func _on_title_quit_btn_pressed():
	GameplayManager.toggle_pause(false)
	GameplayManager.quit_to_title()
