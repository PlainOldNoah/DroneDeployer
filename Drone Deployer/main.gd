extends Node

func _ready():
	for i in 5:
		DroneManager.create_new_drone()
