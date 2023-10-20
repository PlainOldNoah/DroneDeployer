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
	Menu.MENU.MODIFICATION: $ModificationMenu,
	Menu.MENU.DRONE_OVERVIEW: $DroneOverviewMenu,
	Menu.MENU.DEBUG: $DebugMenu,
}

## Current menu that the game is in as a SCENE
var current_menu: Menu
## Current menu that the game is in as a Menu.MENU
var current_menu_enum: Menu.MENU

## Intialize the state manager with the starting state
func _ready():
	for i in get_children():
		i.hide()
	
	change_menu(starting_menu)


func _unhandled_input(event):
	if event.is_action_pressed("toggle_debug_menu"):
		if current_menu_enum == Menu.MENU.DEBUG:
			change_menu(Menu.MENU.NONE)
		elif current_menu_enum == Menu.MENU.MAIN:
			pass
		else:
			change_menu(Menu.MENU.DEBUG)
	
	input(event)


## Pass the input event along to the current menu
func input(event:InputEvent) -> void:
	var new_menu = current_menu.input(event)
	if new_menu != Menu.MENU.NULL:
		request_menu(new_menu)


## Exit the old menu and enter the new menu
func change_menu(new_menu:Menu.MENU):
	if current_menu:
		current_menu.close()
	
	current_menu = menus[new_menu]
	current_menu_enum = new_menu
	
	## We can have more dynamic menu swapping here. ie the exclusive menu idea
	
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
			if [Menu.MENU.NONE, Menu.MENU.MAIN].has(new_menu):
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
