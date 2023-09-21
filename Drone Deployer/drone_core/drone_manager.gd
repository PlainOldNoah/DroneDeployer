extends Node

## Drone Manager; Handles [Drone]s

## Emitted when a drone is created
signal drone_created(drone:Drone)
## Emitted when a drone is deployed
signal drone_deployed(drone:Drone)

@onready var drone_scene := preload("res://drone_core/drone.tscn")

## Holds currently idle drones waiting for deployment
var drone_queue:Array[Drone] = []

## Queue for deploying drones, first in first out
#var launch_queue:Array[Drone] = []
## List of all drones in game
var drone_library:Array[Drone] = []


## Makes a new drone instance
func create_new_drone():
	var drone_inst := drone_scene.instantiate()
	drone_library.append(drone_inst)
	
	drone_inst.data.display_name = "Drone_%d" % (drone_library.size() - 1)
	
	emit_signal("drone_created", drone_inst)


## Adds the drone to the drone_queue if it is not already present
func add_drone_to_queue(drone:Drone):
	if not drone_queue.has(drone):
		drone_queue.append(drone)
	else:
		print_debug("WARNING: <",drone.name,"> already in queue")


## Remove drone from the drone_queue if it exists
func remove_drone_from_queue(drone:Drone):
	if drone_queue.has(drone):
		drone_queue.erase(drone)


## Deletes all of the drones
func clear_drone_queue():
	drone_queue.clear()


## Returns the drone_queue
func get_drone_queue():
	return drone_queue


## Returns the next drone in the queue and removes it from the queue
func get_and_pop_next_drone():
	return drone_queue.pop_front()
#	return null if drone_queue.is_empty() else drone_queue.pop_front()


## Moves the drone in position 0 to the end of the drone queue
func skip_next_drone():
	drone_queue.push_back(drone_queue.pop_front())
