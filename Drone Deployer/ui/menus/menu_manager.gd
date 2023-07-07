extends CanvasLayer

## Handles all menus and menu requests
##
## Adding a Menu
##[br] 1. Add its path as an @onready
##[br] 2. Add its hotkey to the _input func
##[br] 3. Add its menu to request menu

@onready var main_menu := $MainMenu
@onready var hanger_menu := $HangerMenu
@onready var pause_menu := $PausePopup
@onready var game_over_menu := $GameOverPopup
@onready var debug_menu := $DebugMenu
@onready var fabricator_menu := $Fabricator

@onready var menu_list:Dictionary = {
	"none":{
		"scene":null, # Path to menu scene
		"pause_gameplay":false, # Pauses gameplay while menu is active
		"escapable":true, # Can be exited with hotkey/escape
	},
	"main_menu":{
		"scene":main_menu,
		"pause_gameplay":true,
		"escapable":false,
	},
	"hanger_menu":{
		"scene":hanger_menu,
		"pause_gameplay":true,
		"escapable":true,
	},
	"pause_menu":{
		"scene":pause_menu,
		"pause_gameplay":true,
		"escapable":true,
	},
	"game_over_menu":{
		"scene":game_over_menu,
		"pause_gameplay":false,
		"escapable":false,
	},
	"debug_menu":{
		"scene":debug_menu,
		"pause_gameplay":true,
		"escapable":true,
	},
	"fabricator_menu":{
		"scene":fabricator_menu,
		"pause_gameplay":true,
		"escapable":true,
	},
}

var current_menu:Dictionary = {}


#func _process(delta):
#	print(get_viewport().gui_get_focus_owner())


func _ready():
	var _ok := GameplayManager.connect("game_state_updated", _on_game_state_updated)
	request_menu(menu_list.main_menu)


# _input func for ALL menu calling actions
func _input(event):
	if current_menu["escapable"] == false:
		return
	
	if event.is_action_pressed("ui_cancel"):
		if current_menu != menu_list.none:
			request_menu(menu_list.none)
		else:
			request_menu(menu_list.pause_menu)
			
	elif event.is_action_pressed("toggle_hanger_menu"):
		if current_menu == menu_list.hanger_menu:
			request_menu(menu_list.none)
		else:
			request_menu(menu_list.hanger_menu)
		
	elif event.is_action_pressed("toggle_debug_menu"):
		if current_menu == menu_list.debug_menu:
			request_menu(menu_list.none)
		else:
			request_menu(menu_list.debug_menu)
	
	elif event.is_action_pressed("toggle_fabricator_menu"):
		if current_menu == menu_list.fabricator_menu:
			request_menu(menu_list.none)
		else:
			request_menu(menu_list.fabricator_menu)


# Handles the dismissing and summoning on menu items
func request_menu(new_menu:Dictionary):
	dismiss_all()
	
	match new_menu:
		menu_list.none:
			GameplayManager.toggle_pause(false)
		
		menu_list.main_menu:
			GameplayManager.toggle_pause(true)
			menu_list.main_menu["scene"].show()
		
		menu_list.hanger_menu:
			GameplayManager.toggle_pause(true)
			menu_list.hanger_menu["scene"].show()
		
		menu_list.pause_menu:
			GameplayManager.toggle_pause(true)
			menu_list.pause_menu["scene"].show()
		
		menu_list.game_over_menu:
			GameplayManager.toggle_pause(false)
			menu_list.game_over_menu["scene"].show()
		
		menu_list.debug_menu:
			GameplayManager.toggle_pause(true)
			menu_list.debug_menu["scene"].show()
		
		menu_list.fabricator_menu:
			GameplayManager.toggle_pause(true)
			menu_list.fabricator_menu["scene"].show()
		
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
			dismiss_all()
#		GameplayManager.GAMESTATE.PAUSED:
#			request_menu(menu_list.pause_menu)
		GameplayManager.GAMESTATE.ENDING:
			request_menu(menu_list.game_over_menu)


# Hides every menu
func dismiss_all():
	for i in menu_list.keys():
		if menu_list[i]["scene"] != null:
			menu_list[i]["scene"].hide()
	current_menu = menu_list.none
