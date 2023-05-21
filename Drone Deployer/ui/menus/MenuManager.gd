extends CanvasLayer

#enum MENUS {NONE, MAIN}
#var current_menu:int = MENUS.NONE

@onready var main_menu := $MainMenu

var menu_list:Dictionary = {
	"none":{
		"scene":null,
		"locked":[]
	},
	"main":{
		"scene":main_menu,
		"locked":[]
	}
}

#var unlocked_menus:Array = []

#func request_menu(new_menu:int):
#	pass


#func dismiss_menu():
#	pass
