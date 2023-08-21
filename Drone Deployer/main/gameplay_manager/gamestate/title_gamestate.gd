extends BaseState

@export_node_path("BaseState") var starting_node

@onready var starting_state:BaseState = get_node(starting_node)


func enter() -> void:
	# bring up main menu
	pass


func exit() -> void:
	# hide main menu
	pass
