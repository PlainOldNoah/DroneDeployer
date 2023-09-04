extends Node

## Emitted when an enemy is created
signal enemy_created(enemy:Node)

var enemy_waves:Dictionary = {
	3:{
		"enemy":"res://enemy/enemies/roach.tscn",
		"count":[1,1]
	},
	12:{
		"enemy":"res://enemy/enemies/roach.tscn",
		"count":[4,8]
	},
	24:{
		"enemy":"res://enemy/enemies/roach.tscn",
		"count":[10,20]
	},
}
var enemy_wave_times:Array[int] = []
var curr_wave_key:int = 0


func _ready():
	enemy_wave_times.append(0)
	for i in enemy_waves.keys():
		enemy_wave_times.append(i)
	enemy_wave_times.sort()
#	print(enemy_wave_times)


## Create and add an instance of an enemy
func create_new_enemy(enemy_path:String):
	var enemy_inst:Node = load(enemy_path).instantiate()
	emit_signal("enemy_created", enemy_inst)


## Convert enemy_waves dict into actual enemies
func spawn_wave(wave:Dictionary):
	var enemy_count:int = randi_range(wave["count"][0], wave["count"][1])
	for i in enemy_count:
		create_new_enemy(wave["enemy"])
#	print(wave["count"][0],", ", wave["count"][1],", ", enemy_count)


## After timeout check and use playtime to determine enemy wave
func _on_enemy_spawn_clock_timeout():
	if (GameplayManager.enable_enemy_spawning) and (not enemy_wave_times.is_empty()): # Verify there are still wave times stored
		for i in enemy_wave_times:
			if GameplayManager.playtime >= i: # Compare the playtime to the next wave_key
				curr_wave_key = i
				enemy_wave_times.pop_front() # After matching remove next key
				break
	if enemy_waves.has(curr_wave_key):
		spawn_wave(enemy_waves[curr_wave_key])
