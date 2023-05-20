extends Control

@onready var centerer := $Centerer
@onready var lvl_obj := $LevelObjects
@onready var ddcc := $Centerer/Midpoint/DDCC

@onready var top_bound := $MapBounds/Top
@onready var bottom_bound := $MapBounds/Bottom
@onready var left_bound := $MapBounds/Left
@onready var right_bound := $MapBounds/Right


func _ready():
	set_boundries()
	var _ok := DroneManager.connect("drone_created", add_node_to_lvl_obj)


func set_boundries():
	top_bound.position = centerer.position
	bottom_bound.position = centerer.size + centerer.position
	left_bound.position = centerer.position
	right_bound.position = centerer.size + centerer.position


func add_node_to_lvl_obj(object:Node):
	lvl_obj.add_child(object)


func _input(event):
	if event.is_action_pressed("deploy_drone"):
		DroneManager.deploy_next_drone()
	elif event.is_action_pressed("skip_drone"):
		pass
