class_name Gameboard
extends Control

## Container for the actual game. Hold Drones, Enemies, DDCC, and other objects. Does not handle gameplay elements.

@onready var centerer := $Centerer
@onready var lvl_obj := $LevelObjects
@onready var ddcc := $Centerer/Midpoint/DDCC
@onready var level_objs := $LevelObjects

@onready var top_bound := $MapBounds/Top
@onready var bottom_bound := $MapBounds/Bottom
@onready var left_bound := $MapBounds/Left
@onready var right_bound := $MapBounds/Right

## How far outside the map should enemies spawn
@export var dist_outside_screen:int = 20
## How many Left/Right spawns should happen vs Top/Bottom
@export var lr_to_tb_ratio:int = 3

func _ready():
	set_boundries()
	set_process_input(false)
	DroneManager.connect("drone_created", add_node_to_lvl_obj)
	EnemyManager.connect("enemy_created", add_enemy_to_map)
	GameplayManager.request_drone_deploy.connect(ddcc.deploy_next_drone)


## Adjusts the world borders to the edge of the map
func set_boundries():
	top_bound.position = centerer.position
	bottom_bound.position = centerer.size + centerer.position
	left_bound.position = centerer.position
	right_bound.position = centerer.size + centerer.position


## Adds the object to the lvl_obj node
func add_node_to_lvl_obj(object:Node):
	lvl_obj.call_deferred("add_child", object)
	if object is Drone:
		object.data.home_pos = ddcc.get_global_position()


## Spawns and places an enemy on the gameboard
func add_enemy_to_map(enemy:Node):
	add_node_to_lvl_obj(enemy)
	enemy.set_global_position(get_random_offscreen_point())
	enemy.set_target(ddcc)
	var _ok := enemy.connect("died", _on_enemy_death)


## When an enemy dies deal with it here
func _on_enemy_death(enemy:BaseEnemy):
	for i in enemy.death_drops.size():
		for j in enemy.death_drops[i].count:
			var drop_inst := enemy.death_drops[i].drop_scene.instantiate()
			add_node_to_lvl_obj(drop_inst)
			
			## Random direction
			var rand_angle:Vector2 = Vector2.from_angle(randf_range(0, TAU)).normalized()
			## Random distance in random direction to offset scrap spawn
			var offset:Vector2 = rand_angle * randf_range(0, enemy.death_drops[i].spread)
			
			drop_inst.global_position = enemy.global_position + offset
			
	enemy.queue_free()


## Takes a loot item and spawns in in the given location with count/quan and item spread
#func spawn_loot_to_map(loot_item:String, location:Vector2, value:float=0.0, count:int=1, spread:int=0):
#	var loot_scene = load(loot_item)
#	for i in count:
#		var loot_inst = loot_scene.instantiate()
#		var offset:Vector2 = Vector2(randf_range(-spread, spread), randf_range(-spread, spread))
#		loot_inst.global_position = location + offset
#		loot_inst.scrap_value = value
#		loot_inst.randomize_sprite()
#		add_node_to_lvl_obj(loot_inst)


## Return a random position around the gameboard some distance away
func get_random_offscreen_point() -> Vector2i:
	var output:Vector2i = Vector2i.ZERO
	if randi() % lr_to_tb_ratio == 0: # Left/Right
		output.x = (centerer.position.x - dist_outside_screen) if randi() % 2 == 0 else (centerer.size.x + centerer.position.x + dist_outside_screen)
		output.y = randi_range(centerer.position.y, centerer.size.y + centerer.position.y)
	else: # Top/Bottom
		output.x = randi_range(centerer.position.x, centerer.size.x + centerer.position.x)
		output.y = (centerer.position.y - dist_outside_screen) if randi() % 2 == 0 else (centerer.size.y + centerer.position.y + dist_outside_screen)

	return output


## Calls queue_free on all children of level_objs
func clear_all_level_objs():
	for i in level_objs.get_children():
		i.queue_free()


## Updates the health label
func _on_update_health_label(new_health:int): # TEMP
	$HBoxContainer/HealthLabel.text = "Health: %d" % new_health


## Updates the playtime label
func _on_update_playtime_label(new_time:int):
	@warning_ignore("integer_division")
	$HBoxContainer/PlaytimeLabel.text = "Time: %d:%02d" % [new_time/60, new_time%60]


## Updates the total collected scrap label
func _on_update_scrap_label(scrap_value:float):
	$HBoxContainer/ScrapLabel.text = "Scrap: %d" % scrap_value
