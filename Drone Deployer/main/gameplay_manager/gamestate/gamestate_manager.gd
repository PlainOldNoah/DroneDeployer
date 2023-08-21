class_name GamestateManager
extends Node

## LEFT OFF -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Start connecting the gamestates up to do what they're suppose to
# May require some major signal reworking
# Use the states to drive the code, not the other way around
# Events can change the states

@export_node_path("BaseState") var starting_state


@onready var title_gamestate:BaseState = $TitleGamestate
@onready var starting_gamestate:BaseState = $StartingGamestate
@onready var running_gamestate:BaseState = $RunningGamestate
@onready var paused_gamestate:BaseState = $PausedGamestate
@onready var gameover_gamestate:BaseState = $GameoverGamestate


## The current state the state machine is in
var current_state: BaseState


## Intialize the state manager with the starting state
func init():
	change_state(get_node(starting_state))


## Exit the old state and enter the new state
func change_state(new_state) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()


## Pass through functions for the [GameplayManager] to call & handles state changes
func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)

## Pass through functions for the [GameplayManager] to call & handles state changes
func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)

## Pass through functions for the [GameplayManager] to call & handles state changes
func process(delta: float) -> void:
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)
