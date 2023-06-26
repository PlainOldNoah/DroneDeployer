extends Control

@onready var stat_label:Label = %DroneStats
@onready var drone_name := $DroneName

var linked_drone:Drone = null

func link_to_drone(drone:Drone):
	if drone != linked_drone:

		if linked_drone != null:
			linked_drone.disconnect("stats_updated", update_stat_labels)

		linked_drone = drone
		update_stat_labels(linked_drone)
		var _ok := linked_drone.connect("stats_updated", update_stat_labels)


func update_stat_labels(drone:Drone):
	var lds:Dictionary = drone.stats
	stat_label.set_text("Speed: %d\nDamage: %d\nBattery: %d" % [lds.max_speed, lds.damage, lds.max_battery])
	
	lds.display_name = drone.name if lds.display_name.is_empty() else lds.display_name
	
	drone_name.set_text("%s" % lds.display_name)


func _on_drone_name_text_submitted(new_text):
	linked_drone.set_stat("display_name", new_text)
	get_viewport().gui_release_focus()


var drone_counter:int = 0
func _on_previous_drone_pressed():
	var max_drones:int = DroneManager.drone_queue.size()
	
	drone_counter -= 1
	if drone_counter < 0:
		drone_counter = max_drones - 1
	
	link_to_drone(DroneManager.drone_queue[drone_counter])
#	print(drone_counter)


func _on_next_drone_pressed():
	var max_drones:int = DroneManager.drone_queue.size()
	
	drone_counter += 1
	if drone_counter >= max_drones:
		drone_counter = 0
	
	link_to_drone(DroneManager.drone_queue[drone_counter])
#	print(drone_counter)


