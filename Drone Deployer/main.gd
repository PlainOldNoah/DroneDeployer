extends Node

func _ready():
	for i in 20:
		DroneManager.create_new_drone()
		await get_tree().create_timer(1).timeout
