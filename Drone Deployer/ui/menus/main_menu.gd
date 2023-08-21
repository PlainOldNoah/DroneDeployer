extends Control

#signal echo_on_start_game_btn_pressed()

func _on_start_game_btn_pressed():
	GameplayManager.reset_game()
	GameplayManager.start_game()
#	emit_signal("echo_on_start_game_btn_pressed")


func _on_quit_btn_pressed():
	get_tree().quit()
