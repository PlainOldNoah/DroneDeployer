extends "res://enemies/base_enemy.gd"

var roach_stats:Dictionary = {
	"speed":50,
	"max_hp":1,
	"health":0,
	"damage":1,
}


func _ready():
	stats = roach_stats
	
	stats.max_hp = randi_range(1,2)
	
	super._ready()
