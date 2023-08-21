extends BaseState

@export_node_path("BaseState") var starting_node
@export_node_path("BaseState") var title_node

@onready var starting_state:BaseState = get_node(starting_node)
@onready var title_state:BaseState = get_node(title_node)
