class_name Menu
extends Control

## Base menu in which all other menus inherit from

## List of all available menus
enum MENU {
	NONE, ## No menu shown, typically gameboard
	MAIN,
	PAUSE,
	GAMEOVER,
	MODIFICATION,
	DRONE_OVERVIEW,
	DEBUG,
	NULL, 
}

## Pause the game while open and resume when closed
@export var pause_game:bool = true
## Hide all other menus when this one is opened
@export var exclusive:bool = true
## If hotkey available, open if closed & close if open
@export var toggle:bool = true

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
