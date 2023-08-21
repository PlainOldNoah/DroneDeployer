extends BaseState

@export_node_path("BaseState") var running_node

@onready var running_state:BaseState = get_node(running_node)
