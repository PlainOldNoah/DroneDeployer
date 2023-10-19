extends GameState

## Starting Gamestate; Initialize the game

func enter() -> void:
	GameplayManager.reset_game()
	GameplayManager.start_game()
	
