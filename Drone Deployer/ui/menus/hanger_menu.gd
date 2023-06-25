extends Control

@onready var drone_stats := %DroneStats


func set_new_drone(drone:Drone):
	drone_stats.link_to_drone(drone)


# ===== DEBUG STUFF =====
var debug_counter:int = 0
func _on_test_pressed():
	var max_drones:int = DroneManager.drone_queue.size()
	set_new_drone(DroneManager.drone_queue[debug_counter])
	
	debug_counter += 1
	if debug_counter >= max_drones:
		debug_counter = 0

func _on_test_2_pressed():
	DroneManager.drone_queue[debug_counter - 1].debug_randomize_values()
