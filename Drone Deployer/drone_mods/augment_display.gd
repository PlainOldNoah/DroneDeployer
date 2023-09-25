class_name AugmentDisplay
extends Control

## Takes an augment ([AugmentData]) and formats its information

signal augment_selected(augment:AugmentDisplay)

@onready var main_panel := $PanelContainer
@onready var battery_drain_lbl := %BatteryDrainLabel
@onready var icon := %AugmentIcon
@onready var stat_lbl := %StatLabel

## If the augment is selected or not, used with [StorageMenu]
var selected:bool = false:
	set(new_state):
		selected = new_state
		emit_signal("augment_selected", self)


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
#	"ACCELERATION":"⏩",
#	"DAMAGE":"⚔",
#	"MASS":"⚖",
#	"MAX_BATTERY":"🔋",
#	"MAX_SPEED":"⚡",
#}

## What is shown to the player vs what is seen by the game
var stat_symbol:Dictionary = {
	"ACCELERATION":"Acceleration",
	"DAMAGE":"Damage",
	"MASS":"Mass",
	"MAX_BATTERY":"Battery",
	"MAX_SPEED":"Speed",
}

func clear_display():
	main_panel.self_modulate = Color.WHITE
	battery_drain_lbl.text = ""
	stat_lbl.text = ""

## Populates display with info from augment_display for FLOATS and INTS
func update_display():
	main_panel.self_modulate = tier_colors[augment_data.tier]
	battery_drain_lbl.text = "🔌 %2.1f" % augment_data.battery_drain
	
	for key in augment_data.stats.keys():
		if augment_data.stats[key] is int:
			stat_lbl.text += "%s: %d\n" % [stat_symbol[key], augment_data.stats[key]]
		else:
			stat_lbl.text += "%s: %1.1f\n" % [stat_symbol[key], augment_data.stats[key]]


## Echos the click signal
func _on_click_area_pressed():
	selected = !selected
