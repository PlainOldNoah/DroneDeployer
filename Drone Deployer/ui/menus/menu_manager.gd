extends CanvasLayer

# Adding a Menu
#	1. Add its path as an @onready
#	2. Add its hotkey to the _input func
#	3. Add its menu to request menu

@onready var main_menu := $MainMenu
@onready var hanger_menu := $HangerMenu
@onready var pause_menu := $PausePopup
@onready var game_over_menu := $GameOverPopup
@onready var debug_menu := $DebugMenu

@onready var menu_list:Dictionary = {
	"none":{
		"scene":null
	},
	"main_menu":{
		"scene":main_menu
	},
	"hanger_menu":{
		"scene":hanger_menu
	},
	"pause_menu":{
		"scene":pause_menu
	},
	"game_over_menu":{
		"scene":game_over_menu,
	},
	"debug_menu":{
		"scene":debug_menu,
	},
}

var current_menu:Dictionary = {}


func _ready():
	var _ok := GameplayManager.connect("game_state_updated", _on_game_state_updated)
	request_menu(menu_list.main_menu)


# _input func for ALL menu calling actions
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().is_paused():
			GameplayManager.toggle_pause(false)
		else:
			GameplayManager.toggle_pause(true)
	elif event.is_action_pressed("toggle_hanger_menu"):
		request_menu(menu_list.hanger_menu, !menu_list.hanger_menu["scene"].is_visible())
	elif event.is_action_pressed("toggle_debug_menu"):
		request_menu(menu_list.debug_menu, !menu_list.debug_menu["scene"].is_visible())


# Handles the dismissing and summoning on menu items
func request_menu(new_menu:Dictionary, show_scene:bool=true):
	match new_menu:
		menu_list.none:
			dismiss_all()
		
		menu_list.main_menu:
			dismiss_all()
			if show_scene:
				menu_list.main_menu["scene"].show()
		
		menu_list.hanger_menu:
			dismiss_all()
			if show_scene:
				menu_list.hanger_menu["scene"].show()
		
		menu_list.pause_menu:
			menu_list.pause_menu["scene"].set_visible(get_tree().is_paused())
		
		menu_list.game_over_menu:
			dismiss_all()
			if show_scene:
				menu_list.game_over_menu["scene"].show()
		
		menu_list.debug_menu:
			dismiss_all()
			if show_scene:
				menu_list.debug_menu["scene"].show()
		
		_:
			print_debug("ERROR: invalid menu requested <", new_menu, ">")
			printerr("ERROR: invalid menu requested <", new_menu, ">")
			
	current_menu = new_menu


# Signal reciever from GameplayManager
func _on_game_state_updated(state:int):
	match state:
		GameplayManager.GAMESTATE.TITLE:
			request_menu(menu_list.main_menu)
		GameplayManager.GAMESTATE.STARTING:
			request_menu(menu_list.none)
		GameplayManager.GAMESTATE.RUNNING:
			request_menu(menu_list.pause_menu)
		GameplayManager.GAMESTATE.PAUSED:
			request_menu(menu_list.pause_menu)
		GameplayManager.GAMESTATE.ENDING:
			request_menu(menu_list.game_over_menu)


# Hides every menu
func dismiss_all():
	for i in menu_list.keys():
		if menu_list[i]["scene"] != null:
			menu_list[i]["scene"].hide()
	current_menu = menu_list.none
