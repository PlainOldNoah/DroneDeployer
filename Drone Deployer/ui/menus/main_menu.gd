extends Control

signal start_game_requested()

func _on_start_game_btn_pressed():
	emit_signal("start_game_requested")
	GameplayManager.reset_game()
	GameplayManager.start_game()


func _on_quit_btn_pressed():
	get_tree().quit()
