class_name DroneData
extends Resource

## Data & Stats for Drones

## Drone name as appears to the player
var display_name:String = "Drone"

## How much health enemies lose when hit
var damage:int = 1:
	set(new_damage):
		damage = max(1, new_damage)

## How much scrap is current stored within self
var collected_scrap:float = 0.0

## Point to return to when at low battery
var home_pos:Vector2 = Vector2.ZERO

## Color shifted of drone, will be changed later
var modulate_color:Color = Color("ffffff")

# === Speed ===

## Top speed of the drone
var max_speed:int = 200

## Current moving speed
var speed:float = 200:
	set(new_speed):
		speed = clampf(new_speed, 0.0, max_speed)

var acceleration:float = 20.0

# === Battery ===

## Total battery of drone
var max_battery:float = 100.0:
	set(new_max):
		max_battery = max(1.0, new_max)

## Current battery of drone
var battery:float = max_battery:
	set(new_battery):
		battery = clampf(new_battery, 0.0, max_battery)

## Battery depleted per second
var battery_drain:float = 0.0

## Percent of battery remaining that drone returns on
var low_battery_threshold := 0.10

# === Knockback ===

## Velocity only used in knockback
var knockback_velocity:Vector2

## How much the drone is affected by knockback
var mass:float = 10.0

## Value in which knockback is no longer significient
var knockback_cutoff:float = 10.0

# === Statistics ===
### Total collisions and bounces
#var total_bounces:int = 0
### Count of times launched
#var number_of_deployments:int = 0
### Number of seconds in play
#var elapsed_time_deployed:int = 0
### Count of defeated enemies
#var enemies_defeated:int = 0
### Sum of all scrap collected
#var lifetime_collected_scrap:int = 0
