extends CanvasLayer

@onready var main_menu := $MainMenu
@onready var pause_menu := $PausePopup
@onready var game_over_menu := $GameOverPopup
@onready var debug_menu := $DebugMenu
@onready var mod_group_menu := $ModificationGroupMenu

@onready var menu_network:Dictionary = {
	"main_menu":{
		"scene":main_menu,
		"cancel_to":null,
	},
	"no_menu":{
		"scene":null,
		"cancel_to":"pause_menu",
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

@onready var current_menu:Dictionary = {}


func _ready():
	main_menu.echo_on_start_game_btn_pressed.connect(request_menu.bind("no_menu"))
#	var _ok = main_menu.connect("echo_on_start_game_btn_pressed", test("E"))
#	player.hit.connect(_on_player_hit.bind("sword", 100))
#button.button_down.connect(Callable(self, "_on_button_down"))

	request_menu("main_menu")


func test(poop:String):
	print("TEST", poop)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if current_menu["cancel_to"] != null:
			request_menu(current_menu["cancel_to"])


##
func request_menu(requested_menu:String):
	if menu_network[requested_menu]["scene"] != null:
		menu_network[requested_menu]["scene"].show()
	else:
		current_menu["scene"].hide()
	current_menu = menu_network[requested_menu]

### Ask for a new menu, returns menu if accepted
#func select_new_menu(menu_id:String):
#	match current_menu:
#		main_menu:
#			pass
#
#		pause_menu:
#			pass
#
#		game_over_menu:
#			pass
#
#		debug_menu:
#			pass
#
#		mod_group_menu:
#			pass
#
#		_:
#			print_debug("ERROR")
#
#
### Sets the current menu to the new_menu
#func set_new_menu(new_menu:Control):
#	pass

# -----------------------------------------------------------------------------

#extends CanvasLayer
#
### Handles all menus and menu requests
###
### Adding a Menu
###[br] 1. Add its path as an @onready
###[br] 2. Add its hotkey to the _input func
###[br] 3. Add its menu to request menu
#
#@onready var main_menu := $MainMenu
#@onready var hanger_menu := $ModificationGroupMenu
##@onready var hanger_menu := $HangerMenu
#@onready var pause_menu := $PausePopup
#@onready var game_over_menu := $GameOverPopup
#@onready var debug_menu := $DebugMenu
##@onready var fabricator_menu := $Fabricator
#@onready var fabricator_menu := $ModificationGroupMenu
#
#@onready var menu_list:Dictionary = {
#	"none":{
#		"scene":null, # Path to menu scene
#		"pause_gameplay":false, # Pauses gameplay while menu is active
#		"escapable":true, # Can be exited with hotkey/escape
#	},
#	"main_menu":{
#		"scene":main_menu,
#		"pause_gameplay":true,
#		"escapable":false,
#	},
#	"hanger_menu":{
#		"scene":hanger_menu,
#		"pause_gameplay":true,
#		"escapable":true,
#	},
#	"pause_menu":{
#		"scene":pause_menu,
#		"pause_gameplay":true,
#		"escapable":true,
#	},
#	"game_over_menu":{
#		"scene":game_over_menu,
#		"pause_gameplay":false,
#		"escapable":false,
#	},
#	"debug_menu":{
#		"scene":debug_menu,
#		"pause_gameplay":true,
#		"escapable":true,
#	},
#	"fabricator_menu":{
#		"scene":fabricator_menu,
#		"pause_gameplay":true,
#		"escapable":true,
#	},
#}
#
#var current_menu:Dictionary = {}
#
#
##func _process(delta):
##	print(get_viewport().gui_get_focus_owner())
#
#
#func _ready():
#	var _ok := GameplayManager.connect("game_state_updated", _on_game_state_updated)
#	request_menu(menu_list.main_menu)
#
#
## _input func for ALL menu calling actions
#func _unhandled_input(event):
#	if current_menu["escapable"] == false:
#		return
#
#	if event.is_action_pressed("ui_cancel"):
#		if current_menu != menu_list.none:
#			request_menu(menu_list.none)
#		else:
#			request_menu(menu_list.pause_menu)
#
#	elif event.is_action_pressed("toggle_hanger_menu"):
#		if current_menu == menu_list.hanger_menu:
#			request_menu(menu_list.none)
#		else:
#			request_menu(menu_list.hanger_menu)
#
#	elif event.is_action_pressed("toggle_fabricator_menu"):
#		if current_menu == menu_list.fabricator_menu:
#			request_menu(menu_list.none)
#		else:
#			request_menu(menu_list.fabricator_menu)
#
#	elif event.is_action_pressed("toggle_debug_menu"):
#		if current_menu == menu_list.debug_menu:
#			request_menu(menu_list.none)
#		else:
#			request_menu(menu_list.debug_menu)
#
#
## Handles the dismissing and summoning on menu items
#func request_menu(new_menu:Dictionary):
#	dismiss_all()
#
#	match new_menu:
#		menu_list.none:
#			GameplayManager.toggle_pause(false)
#
#		menu_list.main_menu:
#			GameplayManager.toggle_pause(true)
#			menu_list.main_menu["scene"].show()
#
#		menu_list.hanger_menu:
#			GameplayManager.toggle_pause(true)
#			menu_list.hanger_menu["scene"].show()
#
#		menu_list.pause_menu:
#			GameplayManager.toggle_pause(true)
#			menu_list.pause_menu["scene"].show()
#
#		menu_list.game_over_menu:
#			GameplayManager.toggle_pause(false)
#			menu_list.game_over_menu["scene"].show()
#
#		menu_list.debug_menu:
#			GameplayManager.toggle_pause(true)
#			menu_list.debug_menu["scene"].show()
#
#		menu_list.fabricator_menu:
#			GameplayManager.toggle_pause(true)
#			menu_list.fabricator_menu["scene"].show()
#
#		_:
#			print_debug("ERROR: invalid menu requested <", new_menu, ">")
#			printerr("ERROR: invalid menu requested <", new_menu, ">")
#
#	current_menu = new_menu
#
#
## Signal reciever from GameplayManager
#func _on_game_state_updated(state:int):
#	match state:
#		GameplayManager.GAMESTATE.TITLE:
#			request_menu(menu_list.main_menu)
#		GameplayManager.GAMESTATE.STARTING:
#			request_menu(menu_list.none)
#		GameplayManager.GAMESTATE.RUNNING:
#			dismiss_all()
##		GameplayManager.GAMESTATE.PAUSED:
##			request_menu(menu_list.pause_menu)
#		GameplayManager.GAMESTATE.ENDING:
#			request_menu(menu_list.game_over_menu)
#
#
## Hides every menu
#func dismiss_all():
#	for i in menu_list.keys():
#		if menu_list[i]["scene"] != null:
#			menu_list[i]["scene"].hide()
#	current_menu = menu_list.none
