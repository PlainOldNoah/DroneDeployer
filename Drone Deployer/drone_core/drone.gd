class_name Drone
extends CharacterBody2D

## Deployable object that can defeat enemies and pick up items


## Emitted when the [DroneState] changes
signal state_changed(new_state:DroneState.STATE)

## Lerp weight for changing rotation
const LERP_ROT_WEIGHT:float = 0.10

## Physical body; Only used in collisions/bounces
@onready var collision_shape := $CollisionShape2D
## Acts as the drone's body for collection items and hitting enemies
@onready var pseudo_body := $PseudoBody
## Area2D responsible for pulling map items towards self
@onready var vacuum_area := $VacuumArea

## Parent node for hold all drone upgrades
@onready var upgrades := $Upgrades

## Drone State Manager, handles drone states
@onready var drone_state_manager:DroneStateManager = $DroneStateManager

## Create a new DroneData resource
var data:DroneData = DroneData.new()

## What direction the drone is facing
var facing:Vector2 = Vector2.ZERO:
	set(new_facing):
		facing = new_facing
		update_velocity()


# === Overridden ===

func _ready():
	add_to_group("drone")
	pseudo_body.add_to_group("drone")
	
	set_z_index(30)
	
	debug_randomize_values()
	
	drone_state_manager.init(self)


func _physics_process(delta):
	drone_state_manager.physics_process(delta)

func _process(delta):
	drone_state_manager.process(delta)


# === Battery ===

## Drains the battery and returns a [DroneState]
func drain_battery(delta:float) -> DroneState.STATE:
#	if data.battery == 0.0:
#		return DroneState.STATE.NULL
	
	data.battery = clamp(data.battery - (data.battery_drain * delta), 0.0, data.max_battery)
	
	
	# Dead Battery
	if data.battery <= 0.0:
		return DroneState.STATE.NULL
#		return DroneState.STATE.DEAD
	
	# Low Battery
	elif (data.battery / data.max_battery) <= data.low_battery_threshold:
		return DroneState.STATE.LOW_BATTERY
	
	return DroneState.STATE.NULL

## Charges the battery, returns true when battery is full
func charge_battery(delta:float) -> bool:
	data.battery = clamp(data.battery + (data.battery_drain * 2 * delta), 0.0, data.max_battery)
	
	if data.battery == data.max_battery:
		return true
	return false


# === Drone State ===

## Activates a Drone for the map with a starting point and angle (in radians)
func deploy(deploy_pos:Vector2, deploy_angle:float):
	set_global_position(deploy_pos)
	facing = Vector2.from_angle(deploy_angle)
	update_velocity(true)
	
	drone_state_manager.change_state(DroneState.STATE.PREPARING)

## Puts the drone back into the DDCC as the Idle State
func collect():
	drone_state_manager.change_state(DroneState.STATE.IDLE)

## Returns the current state the drone is in
func get_drone_state() -> DroneState.STATE:
	return drone_state_manager.current_state_enum

## Returns true if the current drone state (enum) matches the parameter state
func is_drone_state(match_state:DroneState.STATE) -> bool:
	return get_drone_state() == match_state


# === DDCC Areas ===

## Drone leaves the DDCC shield area
func ddcc_shield_area_exited():
	if get_drone_state() == DroneState.STATE.PREPARING:
		drone_state_manager.change_state(DroneState.STATE.ACTIVE)

## Drone enters the DDCC's shield area
func ddcc_shield_area_entered():
	if get_drone_state() == DroneState.STATE.LOW_BATTERY:
		drone_state_manager.change_state(DroneState.STATE.PENDING_RETRIEVAL)


# === Misc ===

## Sets the velocity to the current speed and facing direction
## [br] instant_rot to rotate immediately
func update_velocity(instant_rot:bool=false):
	velocity = data.speed * facing.normalized()
	
	if instant_rot:
		set_rotation(facing.angle() + PI/2)
	else:
		rotation = lerp_angle(rotation, facing.angle() + PI/2, LERP_ROT_WEIGHT)


## Randomizes some values for debugging purposes
func debug_randomize_values():
	data.modulate_color = Color(randf(), randf(), randf())
	$Sprite.modulate = data.modulate_color
	
	data.max_speed = randi_range(200, 400)
#	data.damage = randi_range(1,10)
	data.damage = 1
#	data.max_battery = randi_range(100,500)


## Toggle the CharacterBody2D collisions and/or the Area2D collision shapes
func disable_collision_shapes(solid_body_value:bool, area_value:bool):
	collision_shape.set_deferred("disabled", solid_body_value)
	pseudo_body.get_node("CollisionShape2D").set_deferred("disabled", area_value)
	vacuum_area.get_node("CollisionShape2D").set_deferred("disabled", area_value)


## When an enemy or pickup enters the Drone's "Body"
func _on_pseudo_body_area_entered(area):
	if area.is_in_group("enemy"):
		if area.health > data.damage:
			data.knockback_velocity = area.global_position.direction_to(global_position) * 200
			area.take_hit(data.damage)
		else:
			area.take_hit(data.damage)
	elif area.is_in_group("scrap"):
		data.collected_scrap += area.value
		area.queue_free()


## Begins attraction of scrap items
func _on_vacuum_area_area_entered(area):
	area.attract_target = self


## Returns the current scrap amount and resets it to 0
func get_and_reset_scrap() -> int:
	var output := roundi(data.collected_scrap)
	data.collected_scrap = 0
	return output
