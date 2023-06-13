extends Node

signal ddcc_health_changed(ddcc_max_health:int)
signal playtime_updated(time:int)

@onready var gameplay_timer := $GameplayTimer

@export_category("Enemies")
@export var enable_enemy_spawning:bool = true

@export_category("DDCC")
@export_range(0, 999) var ddcc_max_health:int = 10
#@export var enable_take_damage:bool = true

@export_category("Drones")
@export_range(0, 99) var starting_drones:int = 1
@export_range(0, 50) var max_drones:int = 50

var ddcc_health:int = ddcc_max_health
var playtime:int = 0


func _ready():
	await get_tree().root.ready
	emit_signal("ddcc_health_changed", ddcc_max_health)
	start_game()


func start_game():
	starting_drones = clampi(starting_drones, 1, max_drones)
	
	for i in starting_drones:
		DroneManager.create_new_drone()
	gameplay_timer.start()


func reset_game():
	ddcc_health = ddcc_max_health
	playtime = 0
	DroneManager.clear_drone_queue()


# Handles the ddcc's health and reduces it by damage recieved
func _on_ddcc_take_damage(damage:int):
	ddcc_health = clampi(ddcc_health - damage, 0, ddcc_max_health)
	emit_signal("ddcc_health_changed", ddcc_health)


func _on_gameplay_timer_timeout():
	playtime += 1
	emit_signal("playtime_updated", playtime)
