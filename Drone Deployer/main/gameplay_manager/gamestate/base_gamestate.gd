class_name BaseState
extends Node

## Base state for all of the Gamestates
##
## @tutorial(State Machine Example): https://www.youtube.com/watch?v=Bm3sRxDb3js
## @tutorial(Advanced State Machine): https://www.youtube.com/watch?v=DPxIMVC0oZA
## @tutorial(Example Git Repo): https://github.com/theshaggydev/the-shaggy-dev-projects/tree/main/projects/godot-3/advanced-state-machine

enum STATE {
	NULL, ## No State
	TITLE, ## Title Screen
	STARTING, ## Initialize the start of the game
	RUNNING, ## Main gameplay occuring
	PAUSED, ## In the Pause menu
	GAMEOVER, ## Player has lost the game
	MENU, ## Non Debug or Pause menus
}

#func _ready():
#	add_to_group("gamestate")


func enter() -> void:
	pass

func exit() -> void:
	pass


func input(_event: InputEvent) -> int:
	return STATE.NULL

func process(_delta: float) -> int:
	return STATE.NULL

func physics_process(_delta: float) -> int:
	return STATE.NULL
