class_name DroneStateManager
extends Node

## Handles changing drone states and passing data into them

## The state that the drone starts in
@export var starting_state:DroneState.STATE

## State enums for state names that way every script has the same interface
@onready var states:Dictionary = {
	DroneState.STATE.IDLE: $IdleDroneState,
	DroneState.STATE.ACTIVE: $ActiveDroneState,
	DroneState.STATE.RETURNING: $ReturningDroneState,
	DroneState.STATE.DEAD: $DeadDroneState, 
}


## The current state the state machine is in
var current_state: DroneState


## Intialize the state manager with the starting state
func init(linked_drone:Drone):
	for child in get_children():
		child.drone = linked_drone
		
	change_state(starting_state)


## Exit the old state and enter the new state
func change_state(new_state:int) -> void:
	if current_state:
		current_state.exit()
	
	current_state = states[new_state]
	print("DS//", owner.name, ": ", current_state.name)
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


