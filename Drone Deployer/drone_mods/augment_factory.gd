extends Node

## Singleton script that handles creation of all augments

## Emitted when an augment is created
signal augment_created(augment:AugmentData)

## Resource containing data used in augment generation; [AugmentFactoryData]
var aug_factory_data:AugmentFactoryData = AugmentFactoryData.new()

# ==============================================================================
## 1. select tier
## 2. add unadded stats up to tier amount
## 3. assign values to each stat
## 4. sort by highest to lowest value
## 5. return new dict
# ==============================================================================


## Main creation function for creating augments
func create_rand_augment():
	var new_aug:AugmentData = AugmentData.new()
	
	# 1. Select Tier
	var tier:int = get_rand_tier()
	new_aug.tier = tier
	
	# 2. Generate random stats with random values based on tier
	new_aug.stats = (populate_stat_dict(generate_empty_rand_stats(tier), tier))
	
	# 3. Generate a battery drain value based on tier
	var battery_drain_values = aug_factory_data.battery_drain_values[tier]
	new_aug.battery_drain = randf_range(battery_drain_values[0], battery_drain_values[1])
	
	new_aug.craft_cost = 1
	emit_signal("augment_created", new_aug)


## Returns a tier number based on random value compared against tier_arr
func get_rand_tier() -> int:
	var rand_value:int = randi_range(1, aug_factory_data.tier_weight_arr.back())
	for i in aug_factory_data.tier_weight_arr.size():
		if rand_value <= aug_factory_data.tier_weight_arr[i]:
			return i
	return 1


## Returns an array ('count' sized) of randomized augment stats
func generate_empty_rand_stats(count:int):
	var stat_arr:Array = aug_factory_data.STATS.keys()
	stat_arr.shuffle()
	
	count = min(count, stat_arr.size())
	
	var output:Dictionary = {}
	for i in count:
		output[(stat_arr.pop_back())] = 0
	
	return output


## Adds values to each stat in 'stat_dict' based on 'tier'
func populate_stat_dict(stat_dict:Dictionary, tier:int):
	for i in stat_dict:
		var value_arr:Array = aug_factory_data.stat_values[aug_factory_data.STATS[i]][tier]
		
		if value_arr[0] is int:
			stat_dict[i] = randi_range(value_arr[0], value_arr[1])
		else:
			stat_dict[i] = snappedf(randf_range(value_arr[0], value_arr[1]), 0.1)
		
	return stat_dict


## Renames keys in the stat dict for usage in [AugmentDisplay]
#func clean_stat_dict(stat_dict:Dictionary):
#	var cleaned:Dictionary = {}
#	for i in stat_dict:
#		cleaned[aug_factory_data.stat_to_string(aug_factory_data.STATS[i])] = stat_dict[i]
#
#	return cleaned


#func get_random_stat(tier_lookup:int) -> Dictionary:
#	# Get a random stat
#	var rand_stat:int = (randi_range(0, aug_factory_data.STATS.size() - 1))
#
#	# Get a value for the stat
#	var stat_val_arr:Array = aug_factory_data.stat_values[rand_stat][tier_lookup]
#	@warning_ignore("incompatible_ternary")
#	var stat_val = randf_range(stat_val_arr[0], stat_val_arr[1]) if stat_val_arr[0] is int else randi_range(stat_val_arr[0], stat_val_arr[1])
#	stat_val = snappedf(stat_val, 0.1)
#
#	var output:Dictionary = {aug_factory_data.stat_to_string(rand_stat):stat_val}
#	return output
