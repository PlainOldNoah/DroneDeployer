extends Node

signal ddcc_health_changed(ddcc_max_health:int)

@export_range(0, 999) var ddcc_max_health:int = 10
var playtime:int = 0


func _ready():
	await get_tree().root.ready
	emit_signal("ddcc_health_changed", ddcc_max_health)


# Handles the ddcc's health and reduces it by damage recieved
func _on_ddcc_take_damage(damage:int):
	ddcc_max_health = clampi(ddcc_max_health - damage, 0, ddcc_max_health)
	emit_signal("ddcc_health_changed", ddcc_max_health)


func _on_gameplay_timer_timeout():
	playtime += 1
