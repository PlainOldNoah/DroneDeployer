extends Menu

## Gameover Menu; After losing the game go here

func _on_restart_btn_pressed():
	GameplayManager.request_start_game()


func _on_title_quit_btn_pressed():
	GameplayManager.quit_to_title()
