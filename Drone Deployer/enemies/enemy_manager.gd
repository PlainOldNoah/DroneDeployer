extends Node

signal enemy_created(enemy:Node)

func create_new_enemy(enemy_path:String):
	var enemy_inst:Node = load(enemy_path).instantiate()
	emit_signal("enemy_created", enemy_inst)
