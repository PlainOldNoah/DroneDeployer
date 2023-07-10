extends Control

@onready var centerer := $Centerer
@onready var lvl_obj := $LevelObjects
@onready var ddcc := $Centerer/Midpoint/DDCC
@onready var level_objs := $LevelObjects

@onready var top_bound := $MapBounds/Top
@onready var bottom_bound := $MapBounds/Bottom
@onready var left_bound := $MapBounds/Left
@onready var right_bound := $MapBounds/Right

@export var dist_outside_screen:int = 20

func _ready():
	set_boundries()
	set_process_input(false)
	var _ok := DroneManager.connect("drone_created", add_node_to_lvl_obj)
	_ok = EnemyManager.connect("enemy_created", add_enemy_to_map)
	_ok = GameplayManager.connect("ddcc_health_changed", _on_update_health_label)
	_ok = GameplayManager.connect("playtime_updated", _on_update_playtime_label)
	_ok = GameplayManager.connect("game_state_updated", _on_game_state_updated)
	_ok = GameplayManager.connect("curr_scrap_updated", _on_update_scrap_label)


func _on_game_state_updated(state):
	match state:
		GameplayManager.GAMESTATE.STARTING, GameplayManager.GAMESTATE.RUNNING:
			set_process_input(true)
		GameplayManager.GAMESTATE.PAUSED:
			set_process_input(false)
		GameplayManager.GAMESTATE.TITLE, GameplayManager.GAMESTATE.ENDING:
			set_process_input(false)
			clear_all_level_objs()
		_:
			print_debug("ERROR: bad state set <", state, ">")


func _input(event):
	if event.is_action_pressed("deploy_drone"):
		ddcc.deploy_next_drone()
	elif event.is_action_pressed("skip_drone"):
		pass


# Adjusts the world borders to the edge of the map
func set_boundries():
	top_bound.position = centerer.position
	bottom_bound.position = centerer.size + centerer.position
	left_bound.position = centerer.position
	right_bound.position = centerer.size + centerer.position


# Adds the object to the lvl_obj node
func add_node_to_lvl_obj(object:Node):
#	lvl_obj.add_child(object)
	lvl_obj.call_deferred("add_child", object)


# spawns and places an enemy on the gameboard
func add_enemy_to_map(enemy:Node):
	add_node_to_lvl_obj(enemy)
	enemy.set_global_position(get_random_offscreen_point())
	enemy.set_target(ddcc)
	var _ok := enemy.connect("died", _on_enemy_death)


# When an enemy dies deal with it here
func _on_enemy_death(enemy:Node):
	spawn_loot_to_map("res://lvl_objects/enemy_drop.tscn", enemy.global_position, 0.5, 5, 90)
	enemy.queue_free()


# Takes a loot item and spawns in in the given location with count/quan and item spread
func spawn_loot_to_map(loot_item:String, location:Vector2, value:float=0.0, count:int=1, spread:int=0):
	var loot_scene = load(loot_item)
	for i in count:
		var loot_inst = loot_scene.instantiate()
		var offset:Vector2 = Vector2(randf_range(-spread, spread), randf_range(-spread, spread))
		loot_inst.global_position = location + offset
		loot_inst.scrap_value = value
		loot_inst.randomize_sprite()
		add_node_to_lvl_obj(loot_inst)


# Return a random L/R cord on the map border modified by dist_outside_screen
func get_random_offscreen_point() -> Vector2i:
	var output:Vector2i = Vector2i.ZERO
	output.y = randi_range(centerer.position.y, centerer.size.y + centerer.position.y)
	output.x = (centerer.position.x - dist_outside_screen) if randi() % 2 == 0 else (centerer.size.x + centerer.position.x + dist_outside_screen)
	return output


# Calls queue_free on all children of level_objs
func clear_all_level_objs():
	for i in level_objs.get_children():
		i.queue_free()


# Updates the health label
func _on_update_health_label(new_health:int): # TEMP
	$HBoxContainer/HealthLabel.text = "Health: %d" % new_health


# Updates the playtime label
func _on_update_playtime_label(new_time:int):
	@warning_ignore("integer_division")
	$HBoxContainer/PlaytimeLabel.text = "Time: %d:%02d" % [new_time/60, new_time%60]


# Updates the total collected scrap label
func _on_update_scrap_label(scrap_value:float):
	$HBoxContainer/ScrapLabel.text = "Scrap: %d" % scrap_value


func _on_enemy_spawn_clock_timeout():
	EnemyManager.create_new_enemy("res://enemies/roach.tscn")
