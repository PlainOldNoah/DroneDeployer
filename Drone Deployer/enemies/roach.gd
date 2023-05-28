extends "res://enemies/base_enemy.gd"

var roach_stats:Dictionary = {
	"speed":50,
	"max_hp":1
}


func _ready():
	stats = roach_stats
	super._ready()
