extends Node

## Main script for handling all aspects to running and playing the game

## Emitted when the [DDCC] health changes
signal ddcc_health_changed(new_health:int)
## Emitted when the elapsed playtime changes
signal playtime_updated(time:int)
## Emitted when the current scrap count changes
signal curr_scrap_updated(scrap:float)
## Emitted when the total collected scrap changes
signal total_scrap_updated(TCS:float)


@onready var gamestate_manager:GamestateManager = $GamestateManager
@onready var gameplay_timer := $GameplayTimer

@export_category("Enemies")
## Toggle for if enemies should spawn or not, used in debugging
@export var enable_enemy_spawning:bool = true

@export_category("DDCC")
## Maximum health of the [DDCC]
@export_range(0, 999) var ddcc_max_health:int = 10

@export_category("Drones")
## How many drones the player have at game start
@export_range(0, 99) var starting_drones:int = 1
## Upper limit on how many drones there can be at once
@export_range(0, 50) var max_drones:int = 50


## Current health of the [DDCC]
## [br]Setter clamps health between 0 and ddcc_max_health
## [br]If health is <= 0 set the gamestate to ENDING
var ddcc_health:int = ddcc_max_health:
	set(new_health):
		ddcc_health = clampi(new_health, 0, ddcc_max_health)
		emit_signal("ddcc_health_changed", ddcc_health)
		if ddcc_health <= 0:
			gamestate_manager.change_state(gamestate_manager.title_gamestate)
#			GameplayManager.set_gamestate(GAMESTATE.ENDING)

## Total quantity of collected scrap
var total_collected_scrap:int = 0:
	set(new_tcs):
		total_collected_scrap = new_tcs
		emit_signal("total_scrap_updated", total_collected_scrap)

## Current available scrap, cannot go negative
var current_scrap:int = 0:
	set(new_value):
		current_scrap = new_value
		emit_signal("curr_scrap_updated", current_scrap)

## Toggle if the [DDCC] should be allowed to take damage, used for debugging
var ddcc_invincible:bool = false

## Total elapsed playtime for the current run
var playtime:int = 0:
	set(new_playtime):
		playtime = new_playtime
		emit_signal("playtime_updated", playtime)

## Status if the game is running or not
var game_running:bool = false


func _ready():
	gamestate_manager.init()


func _unhandled_input(event):
	if event.is_action_pressed("toggle_debug_menu"):
		print_debug("TOGGLE DEBUG MODE")
	gamestate_manager.input(event)


## Runs though all the steps required to start the game
func start_game():
	starting_drones = clampi(starting_drones, 1, max_drones)
	
	for i in starting_drones:
		DroneManager.create_new_drone()
	
	gameplay_timer.start()
	
	_on_game_initialized()


## Runs though all the steps needed to safely end the game
func end_game():
	gameplay_timer.stop()


## Puts all necessary variables to their default values
func reset_game():
	ddcc_health = ddcc_max_health
	playtime = 0
	current_scrap = 0
	total_collected_scrap = 0

	DroneManager.clear_drone_queue()


## Pasues and unpauses the game
func toggle_pause(value:bool):
	get_tree().set_pause(value)


## Safely quits to the main menu
func quit_to_title():
	end_game()
	reset_game()
	gamestate_manager.change_state(BaseState.STATE.TITLE)


## Reduces the [DDCC] health, setter handles the rest
func ddcc_take_hit(damage:int):
	if not ddcc_invincible:
		ddcc_health -= damage


## Adds scrap to the current and total scrap amounts
func add_scrap(amount:int):
	amount = max(0, amount)
	current_scrap += amount
	total_collected_scrap += amount


## Removes scrap if current scrap remains >=0, otherwise do nothing
func remove_scrap(amount:int) -> bool:
	if amount > current_scrap:
		return false
	else:
		current_scrap -= amount
		return true


## User input on resume button in pause menu
func _on_resume_game_requested():
	gamestate_manager.change_state(BaseState.STATE.RUNNING)

## When we want the game to start call this
func _on_start_game_requested():
	gamestate_manager.change_state(BaseState.STATE.STARTING)


## When the game as finished initializating
func _on_game_initialized():
	gamestate_manager.change_state(BaseState.STATE.RUNNING)


## Increments playtime by 1
func _on_gameplay_timer_timeout():
	playtime += 1