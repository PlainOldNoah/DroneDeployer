extends CanvasLayer

## Handler for all in-game menus

## List of available menus
enum MENUS {
	NULL, ## No menu selected, typically gameboard
	MAIN, ## Title screen
	PAUSE, ## Pause menu
	GAMEOVER, ## Gameover menu
	DEBUG, ## Debug menu
	FABRICATOR, ## Fabricator menu
	HANGER, ## Hanger menu
	}

@onready var menus:Dictionary = {
	MENUS.MAIN: $MainMenu,
	MENUS.PAUSE: $PauseMenu,
	MENUS.HANGER: $ModificationGroupMenu,
	MENUS.FABRICATOR: $ModificationGroupMenu,
	MENUS.GAMEOVER: $GameOverMenu,
}

## The currently selected menu
@onready var current_menu:MENUS


## Hides the current menu and shows the requested menu
func request_menu(new_menu:int):
	if menus.has(current_menu):
		menus[current_menu].hide()
	
	if menus.has(new_menu):
		current_menu = new_menu
		menus[current_menu].show()


## Returns true if the current_menu matches the check_menu
func is_current_menu(check_menu:int):
	return current_menu == check_menu
