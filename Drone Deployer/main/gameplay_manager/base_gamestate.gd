class_name BaseState
extends Node

## Base state for all of the Gamestates
##
## For each added gamestate a list of references is needed: 
## [br]@export_node_path("BaseState") var state_node 
## [br]@onready var name_state:BaseState = get_node(state_node)
##
## @tutorial(State Machine Example): https://www.youtube.com/watch?v=Bm3sRxDb3js
## @tutorial(Advanced State Machine): https://www.youtube.com/watch?v=DPxIMVC0oZA
## @tutorial(Example Git Repo): https://github.com/theshaggydev/the-shaggy-dev-projects/tree/main/projects/godot-3/advanced-state-machine

enum STATE {
	NULL, ## No State
	TITLE, ## Title Screen
	STARTING, ## Initialize the start of the game
	RUNNING, ## Main gameplay occuring
	PAUSED, ## In a menu
	GAMEOVER, ## Player has lost the game
}


func enter() -> void:
	pass

func exit() -> void:
	pass


func input(event: InputEvent) -> BaseState:
	return null

func process(delta: float) -> BaseState:
	return null

func physics_process(delta: float) -> BaseState:
	return null
