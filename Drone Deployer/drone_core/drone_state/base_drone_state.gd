class_name DroneState
extends Node

## Base state for all of the drone states
##
## @tutorial(State Machine Example): https://www.youtube.com/watch?v=Bm3sRxDb3js
## @tutorial(Advanced State Machine): https://www.youtube.com/watch?v=DPxIMVC0oZA
## @tutorial(Example Git Repo): https://github.com/theshaggydev/the-shaggy-dev-projects/tree/main/projects/godot-3/advanced-state-machine

enum STATE {
	NULL, ## No State
	IDLE, ## Waiting to be deployed
	ACTIVE, ## Currently deployed
	RETURNING, ## Low battery, going home
	DEAD, ## No battery, dead in the water
}

#func _ready():
#	add_to_group("dronestate")


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
