extends CanvasLayer

#enum MENUS {NONE, MAIN}
#var current_menu:int = MENUS.NONE

@onready var main_menu := $MainMenu


@onready var menu_list:Dictionary = {
	"none":{
		"scene":null,
		"locked":[]
	},
	"main_menu":{
		"scene":main_menu,
		"locked":[]
	},
}

var current_menu:Dictionary = {}

func _ready():
	var _ok := main_menu.connect("start_game_requested", _on_start_game_requested)


func _input(event):
	pass


func _on_start_game_requested():
	request_menu(menu_list.none)


func request_menu(new_menu:Dictionary):
	match new_menu:
		menu_list.none:
			print("NONE")
			dismiss_all_except()
		menu_list.main_menu:
			pass
		_:
			print_debug("ERROR: invalid menu requested <", new_menu, ">")
			printerr("ERROR: invalid menu requested <", new_menu, ">")


# Hides all menus EXCEPT for one provided as parameter
func dismiss_all_except(menu_exception:Dictionary = {}):
	for i in menu_list.keys():
		if menu_list[i]["scene"] != null and menu_list[i] != menu_exception:
			menu_list[i]["scene"].hide()
		print(i, ": ", menu_list[i])

#func dismiss_menu():
#	pass
