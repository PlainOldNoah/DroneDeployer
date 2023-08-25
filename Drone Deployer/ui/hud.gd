class_name HUD
extends CanvasLayer

## Listens for signals and updates information accordingly

@onready var health_lbl := %HealthLabel
@onready var time_lbl := %TimeLabel
@onready var scrap_lbl := %"Scrap Label"

func _ready():
	var _ok = GameplayManager.connect("ddcc_health_changed", _on_update_health_label)
	_ok = GameplayManager.connect("playtime_updated", _on_update_playtime_label)
	_ok = GameplayManager.connect("curr_scrap_updated", _on_update_scrap_label)


## Updates the health label
func _on_update_health_label(new_health:int):
	health_lbl.text = "Health: %d" % new_health
	
## Updates the playtime label
func _on_update_playtime_label(new_time:int):
	time_lbl.text = "Time: %d:%02d" % [new_time/60, new_time%60]
	
## Updates the total collected scrap label
func _on_update_scrap_label(new_scrap_amnt:int):
	scrap_lbl.text = "Scrap: %d" % new_scrap_amnt
