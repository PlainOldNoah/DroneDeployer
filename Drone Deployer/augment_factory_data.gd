class_name AugmentFactoryData
extends Resource

## Data used in the Augment Factory

## Each drone stat that is available in an augment
enum STATS {ACCELERATION, DAMAGE, MAX_BATTERY, MAX_SPEED}

## Each tier and it's weight
var tier_weights:Dictionary = {
	1:16,
	2:8,
	3:4,
	4:2,
	5:1,
}

## Array of summed tier values
var tier_weight_arr:Array[int] = []

## Each stat and their weight 
#var stat_weight:Dictionary = {
#
#}

## Range of stat values based on tier
var stat_values:Dictionary = {
#	"TEMPLATE":{
#		1:[],
#		2:[],
#		3:[],
#		4:[],
#		5:[],
#	},
	STATS.ACCELERATION:{
		1:[0.1, 1.0],
		2:[1.0, 2.0],
		3:[2.0, 3.0],
		4:[3.0, 4.0],
		5:[4.0, 6.0],
	},
	STATS.DAMAGE:{
		1:[1, 3],
		2:[4, 6],
		3:[7, 9],
		4:[10, 12],
		5:[13, 15],
	},
	STATS.MAX_BATTERY:{
		1:[5, 10],
		2:[10, 25],
		3:[25, 50],
		4:[50, 75],
		5:[75, 100],
	},
	STATS.MAX_SPEED:{
		1:[10, 50],
		2:[50, 100],
		3:[100, 150],
		4:[150, 200],
		5:[200, 300],
	},
}


## Range of battery drain values based on tier
var battery_drain_values:Dictionary = {
	1:[2.0, 1.5],
	2:[1.5, 1.0],
	3:[1.0, 0.5],
	4:[0.5, 0.25],
	5:[0.25, 0],
}


func _init():
	generated_weight_array()


## Populates the tier array for use in randomization
func generated_weight_array():
	var weight_sum:int = 0
	tier_weight_arr.append(0)
	for key in tier_weights.keys():
		weight_sum += tier_weights[key]
		tier_weight_arr.append(weight_sum)


## Converts a STATS enum value into a string
func stat_to_string(stat:STATS) -> String:
	match stat:
		STATS.ACCELERATION:
			return "acceleration"
		STATS.DAMAGE:
			return "damage"
		STATS.MAX_BATTERY:
			return "max_battery"
		STATS.MAX_SPEED:
			return "max_speed"
		_:
			print_debug("ERROR: <", stat, "> does not have a valid string")
			return ""
