extends Node

func _ready():
	for i in 12:
		DroneManager.create_new_drone()
