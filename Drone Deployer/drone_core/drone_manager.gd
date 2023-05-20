extends Node

signal drone_created(drone:Drone)
signal drone_deployed(drone:Drone)

var drone_queue:Array = []
@onready var drone_scene := preload("res://drone_core/drone.tscn")


func create_new_drone():
	var drone_inst := drone_scene.instantiate()
	add_drone_to_queue(drone_inst)
	emit_signal("drone_created", drone_inst)


#func remove_drone():
#	pass


func add_drone_to_queue(drone:Drone):
	drone_queue.append(drone)


func remove_drone_from_queue(drone:Drone):
	if drone_queue.has(drone):
		drone_queue.erase(drone)


func get_drone_queue():
	return drone_queue


func deploy_next_drone():
	var focus_drone:Drone = drone_queue.pop_front()
	if focus_drone != null:
		emit_signal("drone_deployed", focus_drone)


func skip_next_drone():
	pass


func handle_collected_drone():
	pass
