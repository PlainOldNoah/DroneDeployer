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

@onready var main_menu := $MainMenu
@onready var pause_menu := $PausePopup
@onready var game_over_menu := $GameOverPopup
@onready var debug_menu := $DebugMenu
@onready var mod_group_menu := $ModificationGroupMenu

## All available menus and their required data for handling
@onready var menu_network:Dictionary = {
	"main_menu":{
		"scene":main_menu,
		"cancel_to":null, ## on ui_cancel go to this menu
	},
	"no_menu":{
		"scene":null,
		"cancel_to":MENUS.PAUSE,
	},
	"pause_menu":{
		"scene":pause_menu,
		"cancel_to":"no_menu",
	},
	"gameover_menu":{
		"scene":game_over_menu,
		"cancel_to":null,
	},
	"debug_menu":{
		"scene":debug_menu,
		"cancel_to":"no_menu",
	},
	"hanger_menu":{
		"scene":mod_group_menu,
		"cancel_to":"no_menu",
	},
	"fabricator_menu":{
		"scene":mod_group_menu,
		"cancel_to":"no_menu",
	},
}

## The currently selected menu
@onready var current_menu:Dictionary = {}


## Returns the specific menu dict, safer using enums
func get_menu_dict(menu:MENUS) -> Dictionary:
	match menu:
		MENUS.NULL:
			return menu_network["no_menu"]
		MENUS.MAIN:
			return menu_network["main_menu"]
		MENUS.PAUSE:
			return menu_network["pause_menu"]
		MENUS.GAMEOVER:
			return menu_network["gameover_menu"]
		MENUS.DEBUG:
			return menu_network["debug_menu"]
		MENUS.FABRICATOR:
			return menu_network["fabricator_menu"]
		MENUS.HANGER:
			return menu_network["hanger_menu"]
		_:
			return menu_network["no_menu"]


## Sets the requested menu if possible
func request_menu(requested_menu:MENUS):
	var rqst_menu_dict:Dictionary = get_menu_dict(requested_menu)
	
	if rqst_menu_dict["scene"] != null:
		rqst_menu_dict["scene"].show()
#	else:
#		current_menu["scene"].hide()

	current_menu = rqst_menu_dict
	cleanup()


## Hides all scenes except for the current one
func cleanup():
	for i in menu_network.keys():
		if (menu_network[i] != current_menu) and (menu_network[i]["scene"] != null):
			menu_network[i]["scene"].hide()
