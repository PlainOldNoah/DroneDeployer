class_name Drone
extends CharacterBody2D

## Deployable object that can defeat enemies and pick up items

## Emitted when any of the drone stats change
signal stats_updated(drone:Drone)

## Physical body; Only used in collisions/bounces
@onready var collision_shape := $CollisionShape2D
## Acts as the drone's body for collection items and hitting enemies
@onready var pseudo_body := $PseudoBody
## Area2D responsible for pulling map items towards self
@onready var collection_range := $VacuumArea
## Drone State Manager, handles drone states
@onready var drone_state_manager:DroneStateManager = $DroneStateManager

#var stats:Dictionary = {
#	"max_speed":100.0,
#	"speed":200,
#
#	"damage":1,
#
#	"max_battery":100,
#	"battery":100.0,
#	"battery_drain":0,
#	"battery_return_threshold":0.1,
#
#	"display_name":"",
#}

## Create a new DroneData resource
var data:DroneData = DroneData.new()

#print(drone_data.collected_scrap)

### Drone name as appears to the player
#@export var display_name:String = "Drone"
### How much health enemies lose when hit
##@export_range(1, 9999) var damage:int = 1
### How much scrap is current stored within self
#var collected_scrap:float = 0.0
### Point to return to when at low battery
#var home_pos:Vector2 = Vector2.ZERO

#@export_category("Speed")
### Top speed of the drone
#@export_range(0, 9999) var max_speed:int = 200
### Current moving speed
#var speed:int = 200

#@export_category("Battery")
### Total battery of drone
#@export_range(0, 9999) var max_battery:float = 100.0
### Current battery of drone
#var battery:float = max_battery
### Battery depleted per second
#@export_range(0.0, 9999) var battery_drain:float = 0.0
### Percent of battery remaining that drone returns on
#@export_range(0, 100) var low_battery_threshold = 0.10


#@export_category("Knockback")
### Velocity only used in knockback
#var knockback_velocity:Vector2
### How much the drone is affected by knockback
#@export_range(0.0, 9999) var mass:float = 10.0
### Value in which knockback is no longer significient
#@export_range(0.0, 100) var knockback_cutoff:float = 10.0

## Number of times to be knocked back before bouncing
#var bounces:int = 1
## Can be picked up by DDCC
#var collectable:bool = false

# === Overridden ===

func _ready():
	add_to_group("drone")
	set_z_index(30)
	debug_randomize_values()
	
	drone_state_manager.init(self)


func _physics_process(delta):
	drone_state_manager.physics_process(delta)

func _process(delta):
	drone_state_manager.process(delta)

# === Battery ===

## Drains the battery and returns a [DroneState]
func drain_battery(delta:float) -> int:
	data.battery = clamp(data.battery - (data.battery_drain * delta), 0.0, data.max_battery)
	emit_signal("stats_updated", self)
	
	if data.battery <= 0.0: # Dead Battery
		return DroneState.STATE.DEAD
		
#		NOTE: Check battery threshold after colliding since that's when drone can go home
		
#	elif (data.battery / data.max_battery) <= data.low_battery_threshold:
#		return DroneState.STATE.RETURNING
	
	return DroneState.STATE.NULL

## Charges the battery, returns true when battery is full
func charge_battery(delta:float) -> bool:
	data.battery = clamp(data.battery + (data.battery_drain * 2 * delta), 0.0, data.max_battery)
	emit_signal("stats_updated", self)
	
	if data.battery == data.max_battery:
		return true
	return false

# === Drone State ===

## Activates a Drone for the map with a starting point and angle (in radians)
func deploy(deploy_pos:Vector2, deploy_angle:float):
	set_global_position(deploy_pos)
	set_velocity_from_radians(deploy_angle)
	set_facing_direction(true)
	
	drone_state_manager.change_state(DroneState.STATE.ARMING)

## Returns the current state the drone is in
func get_drone_state() -> DroneState:
	return drone_state_manager.current_state

## Returns true if the current drone state matches the paramater match_state
func is_current_state(match_state:DroneState.STATE) -> int:
	return get_drone_state() == drone_state_manager.states[match_state]

# === DDCC Areas ===

## When the drone enters the shield area, go to the hanger
func _on_ddcc_shield_area_entered():
	if is_current_state(DroneState.STATE.ACTIVE):
		drone_state_manager.change_state(DroneState.STATE.RETURNING)

## When the drone exits the shield area for the first time
func _on_ddcc_shield_area_exited():
	pass

## When exiting the DDCC, enter the ACTIVE state if in the ARMING state
func _on_ddcc_collection_pt_exited():
	if is_current_state(DroneState.STATE.ARMING):
		drone_state_manager.change_state(DroneState.STATE.ACTIVE)

## When entering the DDCC, allow collection if ACTIVE or RETURNING
func _on_ddcc_collection_pt_entered():
	if is_current_state(DroneState.STATE.ACTIVE) or is_current_state(DroneState.STATE.RETURNING):
		drone_state_manager.change_state(DroneState.STATE.IDLE)

# === Velocity ===

## Sets the rotation to the direction of the velocity; Gradually or instantly
func set_facing_direction(instantly:bool=true):
	if instantly:
		set_rotation(velocity.angle() + PI/2)
	else:
		rotation = lerp_angle(rotation, velocity.angle() + PI/2, 0.15)

## Sets the velocity from a provided angle in radians and speed
func set_velocity_from_radians(radians:float, speed:int=data.speed):
	set_velocity_from_vector(Vector2.from_angle(radians), speed)

## Sets the velocity from a provided vector
func set_velocity_from_vector(vector:Vector2, speed:int=data.speed):
	set_velocity(vector.normalized() * speed)

# === Misc ===

func debug_randomize_values():
	$Sprite.modulate = Color(randf(), randf(), randf())
	data.max_speed = randi_range(100, 300)
	data.damage = randi_range(1,10)
	data.max_battery = randi_range(100,500)
	emit_signal("stats_updated", self)

## Toggle both the solid colliding body as well as the area2d scanners
func disable_collision_shapes(solid_body_value:bool, scanner_value:bool):
	collision_shape.set_deferred("disabled", solid_body_value)
	pseudo_body.get_node("CollisionShape2D").set_deferred("disabled", scanner_value)
	collection_range.get_node("CollisionShape2D").set_deferred("disabled", scanner_value)


## Set the drone to collectable when outside the range
#func ddcc_perimeter_exited():
#	collectable = true


func _on_pseudo_body_area_entered(area):
	pass
#	if area.is_in_group("enemy"):
#		if area.health > data.damage:
#			data.speed = data.max_speed # TEMP FIX
#			activate_knockback()
#			area.take_hit(data.damage)
#		else:
#			area.take_hit(data.damage)
#	elif area.is_in_group("pickup"):
#		collected_scrap += area.scrap_value
#		area.queue_free()


func _on_vacuum_area_area_entered(area):
	pass # Replace with function body.


## Returns the current scrap amount and resets it to 0
func transfer_scrap() -> int:
	var output := roundi(data.collected_scrap)
	data.collected_scrap = 0
	return output


# Setter for stats, prints warning if statically typed items are unequal
#func set_stat(stat:String, value):
#	if data.has(stat):
#		if (typeof(data.get(stat))) != (typeof(value)):
#			print_debug("WARNING: setting drone stat of type <", (typeof(data.get(stat))), "> with type <", (typeof(value)), ">")
#		data[stat] = value




