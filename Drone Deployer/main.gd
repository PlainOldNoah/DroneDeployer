extends Node

func _ready():
	for i in 1:
		DroneManager.create_new_drone()
