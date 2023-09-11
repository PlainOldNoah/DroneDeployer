class_name AugmentDisplay
extends Control

## Takes an augment ([AugmentData]) and formats its information

@onready var main_panel := $PanelContainer
@onready var battery_drain_lbl := %BatteryDrainLabel
@onready var icon := %AugmentIcon
@onready var stat_lbl := %StatLabel

## Augment itself; Where the display gets its info from
var augment_data:AugmentData = null:
	set(new_data):
		augment_data = new_data
		if augment_data != null:
			clear_display()
			update_display()


## Color of mod based on it's tier
var tier_colors:Dictionary = {
	1:Color.WHITE,
	2:Color.FOREST_GREEN,
	3:Color.BLUE,
	4:Color.DARK_ORANGE,
	5:Color.PURPLE,
}


#var stat_symbol:Dictionary = {
#	"acceleration":"⏩",
#	"damage":"⚔",
#	"mass":"⚖",
#	"max_battery":"🔋",
#	"max_speed":"⚡",
#}

var stat_symbol:Dictionary = {
	"acceleration":"Acceleration",
	"damage":"Damage",
	"mass":"Mass",
	"max_battery":"Battery",
	"max_speed":"Speed",
}

func clear_display():
	main_panel.self_modulate = Color.WHITE
	battery_drain_lbl.text = ""
	stat_lbl.text = ""

## Populates display with info from augment_display
func update_display():
	main_panel.self_modulate = tier_colors[augment_data.tier]
	battery_drain_lbl.text = "🔌 %2.1f" % augment_data.battery_drain
	
	for key in augment_data.stats.keys():
		stat_lbl.text += "%s: %1.1f\n" % [stat_symbol[key], augment_data.stats[key]]
#		print(stat_symbol[key])
#	stat_lbl.text = str(augment_data.stats)


func _on_click_area_pressed():
	pass # Replace with function body.
