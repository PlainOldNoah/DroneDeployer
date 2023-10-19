extends CanvasLayer

## MenuManager; Handler for all in-game menus

## Menu that the game starts in
@export var starting_menu:Menu.MENU

## Menu names and locations so that every Menu has the same interface
@onready var menus:Dictionary = {
	Menu.MENU.NONE: $NoMenu,
	Menu.MENU.MAIN: $MainMenu,
	Menu.MENU.PAUSE: $PauseMenu,
	Menu.MENU.GAMEOVER: $GameOverMenu,
	Menu.MENU.DEBUG: $DebugMenu,
	Menu.MENU.MODIFICATION: $ModificationMenu,
	Menu.MENU.DRONE_OVERVIEW: $DroneOverviewMenu,
}

## Current menu that the game is in as a SCENE
var current_menu: Menu
## Current menu that the game is in as a Menu.MENU
var current_menu_enum: Menu.MENU

## Intialize the state manager with the starting state
func _ready():
	change_menu(starting_menu)


func _unhandled_input(event):
	input(event)


func input(event:InputEvent) -> void:
	var new_menu = current_menu.input(event)
	if new_menu:
		request_menu(new_menu)


## Exit the old menu and enter the new menu
func change_menu(new_menu:Menu.MENU):
	if current_menu:
		current_menu.close()
	
	current_menu = menus[new_menu]
	current_menu_enum = new_menu
	
	## We can have more dynamic menu swapping here. ie the exclusive menu idea
	
	GameplayManager.gamestate_manager.change_state(current_menu.gamestate)
	
	current_menu.open()


## Limiter for what menu can lead to what other menus
func request_menu(new_menu:Menu.MENU):
	print("new_menu: ", new_menu, ", current_menu_enum: ", current_menu_enum)
	
	match current_menu_enum:
		Menu.MENU.MAIN:
			if new_menu == Menu.MENU.NONE:
				change_menu(new_menu)
		Menu.MENU.PAUSE:
			if [Menu.MENU.NONE, Menu.MENU.MAIN].has(new_menu):
				change_menu(new_menu)
		Menu.MENU.GAMEOVER:
			if new_menu == Menu.MENU.MAIN:
				change_menu(new_menu)
		Menu.MENU.DEBUG:
			pass
		Menu.MENU.MODIFICATION:
			if [Menu.MENU.NONE, Menu.MENU.DRONE_OVERVIEW].has(new_menu):
				change_menu(new_menu)
		Menu.MENU.DRONE_OVERVIEW:
			if [Menu.MENU.NONE, Menu.MENU.MODIFICATION].has(new_menu):
				change_menu(new_menu)
		Menu.MENU.NONE:
			if [Menu.MENU.DRONE_OVERVIEW, Menu.MENU.MODIFICATION, \
				Menu.MENU.PAUSE, Menu.MENU.GAMEOVER].has(new_menu):
				change_menu(new_menu)
		_:
			print_debug("ERROR: Invalid menu request <", new_menu, ">")




### List of available menus
#enum MENUS {
#	NULL, ## No menu selected, typically gameboard
#	MAIN, ## Title screen
#	PAUSE, ## Pause menu
#	GAMEOVER, ## Gameover menu
#	DEBUG, ## Debug menu
#	FABRICATOR, ## Fabricator menu
#	HANGER, ## Hanger menu
#	}
#
#@onready var menus:Dictionary = {
#	MENUS.MAIN: $MainMenu,
#	MENUS.PAUSE: $PauseMenu,
#	MENUS.HANGER: $ModificationMenu,
#	MENUS.FABRICATOR: $ModificationMenu,
#	MENUS.GAMEOVER: $GameOverMenu,
#}
#
### The currently selected menu
#@onready var current_menu:MENUS
#
#
### Hides the current menu and shows the requested menu
#func request_menu(new_menu:MENUS):
#	if menus.has(current_menu):
#		menus[current_menu].hide()
#
#	if menus.has(new_menu):
#		current_menu = new_menu
#		menus[current_menu].show()
#
#		# Fabricator/Hanger share a scene
#		if new_menu == MENUS.FABRICATOR:
#			menus[current_menu].set_fabricator_view()
#		elif new_menu == MENUS.HANGER:
#			menus[current_menu].set_hanger_view()
#
#
#
### Returns true if the current_menu matches the check_menu
#func is_current_menu(check_menu:MENUS):
#	return current_menu == check_menu
