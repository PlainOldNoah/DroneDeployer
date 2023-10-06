class_name DroneStateManager
extends Node

## Handles changing drone states and passing data into them

## The state that the drone starts in
@export var starting_state:DroneState.STATE

## State enums for state names that way every script has the same interface
@onready var states:Dictionary = {
	DroneState.STATE.IDLE: $Idle,
#	DroneState.STATE.ARMING: $ArmingDroneState,
	DroneState.STATE.ACTIVE: $Active,
#	DroneState.STATE.RETURNING: $ReturningDroneState,
	DroneState.STATE.DEAD: $Dead, 
	DroneState.STATE.PENDING_RETRIEVAL: $PendingRetrieval,
	DroneState.STATE.PREPARING: $Preparing,
	DroneState.STATE.LOW_BATTERY: $LowBattery,
}

## The current state the state machine is in as a SCENE
var current_state: DroneState
## The current state the state machine is in as a DroneState.STATE
var current_state_enum: DroneState.STATE
#var current_state_enum: DroneState.STATE:
#	set(new_state):
#		current_state_enum = new_state
#		get_parent().emit_signal("state_changed", current_state_enum)


## Intialize the state manager with the starting state
func init(linked_drone:Drone):
	for child in get_children():
		child.drone = linked_drone
		
	change_state(starting_state)


## Exit the old state and enter the new state
func change_state(new_state:DroneState.STATE) -> void:
	if current_state:
		current_state.exit()
	
	current_state = states[new_state]
	current_state_enum = new_state
	
	print(owner.name, " -> ", current_state.name)
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


