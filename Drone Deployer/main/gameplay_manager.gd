extends Node

signal ddcc_health_changed(new_health:int)
signal playtime_updated(time:int)
signal total_scrap_updated(TCS:float)

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
var total_collected_scrap:float = 0.0
var ddcc_invincible:bool = false # Debugger function to toggle DDCC take_hit
var playtime:int = 0
var game_running:bool = false


# Setter for the gamestate
func set_gamestate(new_gamestate:GAMESTATE):
#	print_debug("SETSTATE: ", new_gamestate)
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
	total_collected_scrap = 0.0
	emit_signal("playtime_updated", playtime)
	emit_signal("ddcc_health_changed", ddcc_health)
	emit_signal("total_scrap_updated", total_collected_scrap)
	
	DroneManager.clear_drone_queue()


# Pauses if unpaused and vice versa
func toggle_pause(value:bool):
	get_tree().set_pause(value)
	
	if get_tree().is_paused():
		set_gamestate(GAMESTATE.PAUSED)
	else:
		set_gamestate(GAMESTATE.RUNNING)


func quit_to_title():
	end_game()
	reset_game()
	set_gamestate(GAMESTATE.TITLE)


# Handles the ddcc's health and reduces it by damage recieved
func ddcc_take_hit(damage:int):
	if not ddcc_invincible:
		ddcc_health = clampi(ddcc_health - damage, 0, ddcc_max_health)
		if ddcc_health <= 0:
			GameplayManager.set_gamestate(GAMESTATE.ENDING)
	emit_signal("ddcc_health_changed", ddcc_health)


# Increments the total collected scrap by amount and emits the signal
func adjust_total_scrap(amount:float):
	total_collected_scrap += amount
	emit_signal("total_scrap_updated", total_collected_scrap)


func _on_gameplay_timer_timeout():
	playtime += 1
	emit_signal("playtime_updated", playtime)
