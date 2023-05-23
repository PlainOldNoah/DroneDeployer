extends Node

func _ready():
	for i in 8:
		DroneManager.create_new_drone()
#		await get_tree().create_timer(1).timeout
