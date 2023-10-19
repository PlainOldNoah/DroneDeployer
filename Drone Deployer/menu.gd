class_name Menu
extends Control

## Base menu in which all other menus inherit from

## List of all available menus
enum MENU {
	NULL, 
	NONE, ## No menu shown, typically gameboard
	MAIN,
	PAUSE,
	GAMEOVER,
	DEBUG,
	MODIFICATION,
	DRONE_OVERVIEW,
}

## Pause the game while open and resume when closed
@export var pause_game:bool = true
## Hide all other menus when this one is opened
@export var exclusive:bool = true
## If hotkey available, open if closed & close if open
@export var toggle:bool = true
## Enter this [GameState] when opening this menu
@export var gamestate:GameState.STATE

func open():
	show()
	if pause_game:
		get_tree().set_pause(true)


func close():
	hide()
	if pause_game:
		get_tree().set_pause(false)

func input(_event: InputEvent) -> MENU:
	return MENU.NULL
