extends Control

@onready var centerer := $Centerer
@onready var lvl_obj := $LevelObjects
@onready var ddcc := $Centerer/Midpoint/DDCC

@onready var top_bound := $MapBounds/Top
@onready var bottom_bound := $MapBounds/Bottom
@onready var left_bound := $MapBounds/Left
@onready var right_bound := $MapBounds/Right

@export var dist_outside_screen:int = 20

func _ready():
	set_boundries()
	var _ok := DroneManager.connect("drone_created", add_node_to_lvl_obj)
	_ok = EnemyManager.connect("enemy_created", add_enemy_to_map)
	_ok = GameplayManager.connect("ddcc_health_changed", update_health_label)


func update_health_label(new_health:int): # TEMP
	$HealthLabel.text = "Health: " + str(new_health)



func _input(event):
	if event.is_action_pressed("deploy_drone"):
		ddcc.deploy_next_drone()
	elif event.is_action_pressed("skip_drone"):
		
		var test:float = 0
		for i in 1000000:
			test += get_random_offscreen_point().x
		print(test/1000000.0)


# Adjusts the world borders to the edge of the map
func set_boundries():
	top_bound.position = centerer.position
	bottom_bound.position = centerer.size + centerer.position
	left_bound.position = centerer.position
	right_bound.position = centerer.size + centerer.position


# Adds the object to the lvl_obj node
func add_node_to_lvl_obj(object:Node):
	lvl_obj.add_child(object)


func add_enemy_to_map(enemy:Node):
	add_node_to_lvl_obj(enemy)
	enemy.set_global_position(get_random_offscreen_point())
	enemy.set_target(ddcc)


# Return a random L/R cord on the map border modified by dist_outside_screen
func get_random_offscreen_point() -> Vector2i:
	var output:Vector2i = Vector2i.ZERO
	output.y = randi_range(centerer.position.y, centerer.size.y + centerer.position.y)
	output.x = (centerer.position.x - dist_outside_screen) if randi() % 2 == 0 else (centerer.size.x + centerer.position.x + dist_outside_screen)
	return output


func _on_enemy_spawn_clock_timeout():
	EnemyManager.create_new_enemy("res://enemies/roach.tscn")
