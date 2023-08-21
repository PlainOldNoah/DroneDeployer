extends BaseState

@export_node_path("BaseState") var gameover_node
@export_node_path("BaseState") var paused_node

@onready var gameover_state:BaseState = get_node(gameover_node)
@onready var paused_state:BaseState = get_node(paused_node)


func enter() -> void:
	pass
