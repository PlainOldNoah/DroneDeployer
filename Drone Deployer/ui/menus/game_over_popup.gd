extends Control


func _on_restart_btn_pressed():
	pass # Replace with function body.


func _on_title_quit_btn_pressed():
	GameplayManager.toggle_pause(false)
	GameplayManager.quit_to_title()
