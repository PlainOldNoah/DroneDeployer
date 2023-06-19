extends Node

signal ddcc_health_changed(new_health:int)
signal playtime_updated(time:int)

signal game_state_updated(state:GAMESTATE)
enum GAMESTATE {TITLE, STARTING, RUNNING, PAUSED, ENDING}
var gamestate:GAMESTATE = GAMESTATE.TITLE

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
var game_running:bool = false


func _ready():
	await get_tree().root.ready
	emit_signal("ddcc_health_changed", ddcc_max_health)
	set_gamestate(GAMESTATE.TITLE)


# Setter for the gamestate
func set_gamestate(new_gamestate:GAMESTATE):
	if gamestate == new_gamestate:
		print_debug("WARNING: gamestate already in state <", new_gamestate, ">")
	gamestate = new_gamestate
	emit_signal("game_state_updated", new_gamestate)


func start_game():
	starting_drones = clampi(starting_drones, 1, max_drones)
	
	for i in starting_drones:
		DroneManager.create_new_drone()
	
	set_gamestate(GAMESTATE.STARTING)
	gameplay_timer.start()


func end_game():
	gameplay_timer.stop()


func reset_game():
	ddcc_health = ddcc_max_health
	playtime = 0
	emit_signal("playtime_updated", playtime)
	emit_signal("ddcc_health_changed", ddcc_health)
	DroneManager.clear_drone_queue()


# Pauses if unpaused and vice versa
func toggle_pause(value:bool):
	get_tree().set_pause(value)
#	get_tree().set_pause(!get_tree().is_paused())
	
	if get_tree().is_paused():
		set_gamestate(GAMESTATE.PAUSED)
	else:
		set_gamestate(GAMESTATE.RUNNING)


func quit_to_title():
	end_game()
	reset_game()
	set_gamestate(GAMESTATE.TITLE)


# Handles the ddcc's health and reduces it by damage recieved
func _on_ddcc_take_damage(damage:int):
	ddcc_health = clampi(ddcc_health - damage, 0, ddcc_max_health)
	if ddcc_health <= 0:
		GameplayManager.set_gamestate(GAMESTATE.ENDING)
	emit_signal("ddcc_health_changed", ddcc_health)


func _on_gameplay_timer_timeout():
	playtime += 1
	emit_signal("playtime_updated", playtime)