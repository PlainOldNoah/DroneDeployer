class_name BaseState
extends Node

##

## Available states for reference
enum STATE {
	NULL, ## No State
	TITLE, ## Title Screen
	STARTING, ## Initialize the start of the game
	RUNNING, ## Main gameplay occuring
	PAUSED, ## In a menu
	GAMEOVER, ## Player has lost the game
}

## Entering the state
func enter() -> void:
	pass


## Exiting the state
func exit() -> void:
	pass
