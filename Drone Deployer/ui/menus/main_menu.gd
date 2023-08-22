extends Control


func _on_start_game_btn_pressed():
	GameplayManager._on_start_game_requested()


func _on_quit_btn_pressed():
	get_tree().quit()
