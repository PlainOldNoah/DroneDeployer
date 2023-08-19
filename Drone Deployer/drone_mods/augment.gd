extends Control
class_name Augment

## Stat upgrade for Drones

## Emitted when the augment gains "focus"
signal augment_selected(augment:Augment)

@onready var augment_icon := %AugmentIcon
@onready var battery_drain_label := %BatteryDrainLabel
@onready var stat_label := %StatLabel


## List of stat-value pairs that the augment contains
var stats:Dictionary = {}

## How much the given stat will change by
var value:int = 0:
	set(new_value):
		value = new_value

## How much battery will this augment drain (p/sec)
var battery_drain:float = 0.0:
	set(new_value):
		battery_drain = new_value

## The color to modulate the augment to
var hue:float = 0.0:
	set(new_hue):
		set_self_modulate(Color.from_hsv(new_hue, 1, 1))


## Adds a stat-value pair to the augment
func add_stat(new_stat:String, stat_value:float):
	match new_stat:
		"max_speed", "damage", "max_battery":
			stats[new_stat] = stat_value
			call_deferred("update_stat_label")
		_:
			print_debug("ERROR: invalid stat <", new_stat, ">")
	
	update_stat_label()


## Sets the modulate of the augment's sprite
func set_color(color:Color):
	set_modulate(color)


## Updates the stat label to display the augment's stats
func update_stat_label():
	stat_label = %StatLabel # @onready isn't called in time?
	stat_label.text = str(stats)


## Handles when augment is clicked on
func _on_click_area_pressed():
	update_stat_label()
	emit_signal("augment_selected", self)
