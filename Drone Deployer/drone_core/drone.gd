class_name Drone
extends CharacterBody2D

## Deployable object that can defeat enemies and pick up items

## Emitted when any of the drone stats change
signal stats_updated(drone:Drone)
## Emitted when the [DroneState] changes
signal state_changed(new_state:DroneState.STATE)

## Physical body; Only used in collisions/bounces
@onready var collision_shape := $CollisionShape2D
## Acts as the drone's body for collection items and hitting enemies
@onready var pseudo_body := $PseudoBody
## Area2D responsible for pulling map items towards self
@onready var collection_range := $VacuumArea
## Drone State Manager, handles drone states
@onready var drone_state_manager:DroneStateManager = $DroneStateManager

## Create a new DroneData resource
var data:DroneData = DroneData.new()

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
func get_drone_state() -> DroneState.STATE:
	return drone_state_manager.current_state_enum

## Returns true if the current drone state (enum) matches the parameter state
func is_drone_state(match_state:DroneState.STATE) -> bool:
	return get_drone_state() == match_state

# === DDCC Areas ===

## When the drone enters the shield area, go to the hanger
func _on_ddcc_shield_area_entered():
	if is_drone_state(DroneState.STATE.ACTIVE):
		drone_state_manager.change_state(DroneState.STATE.RETURNING)

## When the drone exits the shield area for the first time
func _on_ddcc_shield_area_exited():
	pass

## When exiting the DDCC, enter the ACTIVE state if in the ARMING state
func _on_ddcc_collection_pt_exited():
	if is_drone_state(DroneState.STATE.ARMING):
		drone_state_manager.change_state(DroneState.STATE.ACTIVE)

## When entering the DDCC, allow collection if ACTIVE or RETURNING
func _on_ddcc_collection_pt_entered():
	if is_drone_state(DroneState.STATE.ACTIVE) or is_drone_state(DroneState.STATE.RETURNING):
		drone_state_manager.change_state(DroneState.STATE.IDLE)

# === Velocity ===

## Sets the rotation to the direction of the velocity; Gradually or instantly
func set_facing_direction(instantly:bool=true):
	if instantly:
		set_rotation(velocity.angle() + PI/2)
	else:
		rotation = lerp_angle(rotation, velocity.angle() + PI/2, 0.15)

## Sets the velocity from a provided angle in radians and speed
func set_velocity_from_radians(radians:float, speed:float=data.speed):
	set_velocity_from_vector(Vector2.from_angle(radians), speed)

## Sets the velocity from a provided vector
func set_velocity_from_vector(vector:Vector2, speed:float=data.speed):
	set_velocity(vector.normalized() * speed)

# === Misc ===

func debug_randomize_values():
	$Sprite.modulate = Color(randf(), randf(), randf())
	data.max_speed = randi_range(100, 300)
	data.damage = randi_range(1,10)
#	data.max_battery = randi_range(100,500)
	emit_signal("stats_updated", self)

## Toggle both the solid colliding body as well as the area2d scanners
func disable_collision_shapes(solid_body_value:bool, scanner_value:bool):
	collision_shape.set_deferred("disabled", solid_body_value)
	pseudo_body.get_node("CollisionShape2D").set_deferred("disabled", scanner_value)
	collection_range.get_node("CollisionShape2D").set_deferred("disabled", scanner_value)


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
