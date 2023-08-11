class_name HangerMenu
extends Control

## [Drone] customization and enhancement menu

@onready var drone_name := %DroneName
@onready var stat_label:Label = %DroneStats
@onready var drone_stats := %DroneStats
@onready var added_augment_view := %AddedAugments
@onready var available_augments := $HBoxContainer/VBoxContainer/AvailableAugments

## Selected drone to apply all current operations to
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
## Keeps track of current linked_drone position in the drone_queue
var drone_counter:int = 0
## Duplicate of [member linked_drone] stats
var augmented_drone_stats:Dictionary = {}
## Selected augments that are staged to be committed
var added_augments:Array[Augment] = []


#func _ready():
#	if DroneManager.drone_queue.size() >= 1:
#		linked_drone = (DroneManager.drone_queue[0])
		
#	var _ok := AugmentFactory.connect("augment_created", add_free_augment)


## Adds the augment to the available augment window
func add_free_augment(augment:Augment):
	available_augments.add_child(augment)
	var _ok := augment.connect("augment_selected", _on_augment_selected)


## Repeated signal from augment when selected/clicked
func _on_augment_selected(augment:Augment):
#	print(augment.name, " // ", augment.stat," // ",  augment.value, " // ", augment.get_modulate())
	
	if added_augments.has(augment):
		added_augments.erase(augment)
	else:
		added_augments.append(augment)
	
	refresh_aug_drone_stats()


## Duplicate linked_drone's stats and apply each added augment to it
func refresh_aug_drone_stats():
	augmented_drone_stats = linked_drone.stats.duplicate(true)
	for i in added_augments:
		if augmented_drone_stats.has(i.stat):
			augmented_drone_stats[i.stat] += i.value
	
	print("ADD: ", added_augments)
	print("ADS: ", augmented_drone_stats)
	print("----------------------------------------------")
	update_labels_w_augments()


## Updates the stat labels with the new stats in parenthesis
func update_labels_w_augments():
	var lds:Dictionary = linked_drone.stats
	var ads:Dictionary = augmented_drone_stats
	
	var stat_text:String = ("Speed: %d (%d)\nDamage: %d (%d)\nBattery: %d (%d)")
	stat_label.set_text(stat_text % [lds.max_speed, ads.max_speed, lds.damage, ads.damage, lds.max_battery, ads.max_battery])


## Applies the selected augments to the currently focused [Drone]
func _on_assemble_btn_pressed():
	linked_drone.stats = augmented_drone_stats.duplicate(true)
	for i in added_augments:
		i.queue_free()
	added_augments.clear()
	update_stat_labels(linked_drone)


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

