extends Node

func _ready():
	for i in 20:
		DroneManager.create_new_drone()
