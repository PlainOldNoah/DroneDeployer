extends Control

## [Drone] customization and enhancement menu

@onready var drone_stats := %DroneStats
@onready var available_augments := $HBoxContainer/VBoxContainer/AvailableAugments
@onready var stat_label:Label = %DroneStats
@onready var drone_name := %DroneName

## Drone to apply all current operations to
var linked_drone:Drone = null:
	set(new_drone):
		if new_drone != linked_drone:
			
			if linked_drone != null:
				linked_drone.disconnect("stats_updated", update_stat_labels)
				
			linked_drone = new_drone
			update_stat_labels(linked_drone)
			var _ok := linked_drone.connect("stats_updated", update_stat_labels)
		else:
			print_debug("WARNING: <", new_drone, "> is already set as linked_drone")
	get:
		return linked_drone


func _ready():
	var _ok := AugmentFactory.connect("augment_created", add_free_augment)


## Adds the augment to the available augment window
func add_free_augment(augment:Augment):
	available_augments.add_child(augment)


## Applies the selected augments to the currently focused [Drone]
func _on_assemble_btn_pressed():
	pass # Replace with function body.


# ===== UI Updates =====

## Updates the text box with drone's stats
func update_stat_labels(drone:Drone):
	var lds:Dictionary = drone.stats
	stat_label.set_text("Speed: %d\nDamage: %d\nBattery: %d" % [lds.max_speed, lds.damage, lds.max_battery])

	lds.display_name = drone.name if lds.display_name.is_empty() else lds.display_name

	drone_name.set_text("%s" % lds.display_name)


## Called when the [LineEdit] text is changed
func _on_drone_name_text_submitted(new_text:String):
	linked_drone.set_stat("display_name", StringName(new_text))
	get_viewport().gui_release_focus()

# ===== DEBUG STUFF =====

## Keeps track of current linked_drone position in the drone_queue
var drone_counter:int = 0
## Moves one position forward in the ["drone_core/drone_manager.gd"] drone_queue
func _on_next_drone_pressed():
	var max_drones:int = DroneManager.drone_queue.size()
	
	drone_counter += 1
	if drone_counter >= max_drones:
		drone_counter = 0
	
	linked_drone = (DroneManager.drone_queue[drone_counter])


## Moves one position back in the ["drone_core/drone_manager.gd"] drone_queue
func _on_previous_drone_pressed():
	var max_drones:int = DroneManager.drone_queue.size()
	
	drone_counter -= 1
	if drone_counter < 0:
		drone_counter = max_drones - 1
	
	linked_drone = (DroneManager.drone_queue[drone_counter])

