class_name GamestateManager
extends Node

## Handles changing gamestate and passing data into them

## The state that the game starts in
@export var starting_state:GameState.STATE

## State enums for state names that way every script has the same interface
@onready var states:Dictionary = {
	GameState.STATE.TITLE: $TitleGamestate,
	GameState.STATE.STARTING: $StartingGamestate,
	GameState.STATE.RUNNING: $RunningGamestate,
	GameState.STATE.PAUSED: $PausedGamestate,
#	GameState.STATE.GAMEOVER: $GameoverGamestate,
#	GameState.STATE.MENU: $MenuGamestate,
}


## The current state the state machine is in
var current_state: GameState
##
var current_state_enum:int

## Intialize the state manager with the starting state
func init():
	await MenuManager.ready
#	change_state(starting_state)


## Exit the old state and enter the new state
func change_state(new_state:int) -> void:
	if current_state:
		current_state.exit()
	
	current_state = states[new_state]
	current_state_enum = new_state
	print("GAME STATE: ", current_state.name)
	
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
