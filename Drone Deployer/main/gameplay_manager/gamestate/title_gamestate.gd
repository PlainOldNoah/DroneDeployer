extends BaseState

## Title Gamestate; Title screen


func enter() -> void:
	MenuManager.request_menu(MenuManager.MENUS.MAIN)
#	MenuManager.request_menu(MenuManager.MENUS.MAIN)


func exit() -> void:
	MenuManager.request_menu(MenuManager.MENUS.NULL)
