extends Area2D

## Pickups that spawn on the map such as scrap
##
## Spawn in the NEW state and do not do anything until a Drone gets close
## LERPs it's position to that of the Drone while in the moving state until collected

## Available states
enum STATE {
	IDLE, ## Returned to a non-moving state
	MOVING, ## Currently chasing after a Drone
	NEW ## Just spawned in
	}
## Current state of the scrap
## Toggles physics_process depending on the state
var state:STATE = STATE.NEW:
	set(new_state):
		state = new_state
		match state:
			STATE.IDLE, STATE.NEW:
				set_physics_process(false)
			STATE.MOVING:
				set_physics_process(true)

## Value of the scrap when collected
@export_range(0,999,0.5) var points := 1.0
## Multiply the scale by this value
@export_range(0.1, 2.0) var size_variance := 0.2

## Weight used in moving scrap to designated drone
var lerp_weight:float = 0.5
## How much to increase the lerp_weight by each physics frame
var lerp_increase:float = 0.5


## Current node (Drone?) that this scrap is currently attracted towards
## Conditionals dictate what state and what signals this item should be connected to
var attract_target:Node = null:
	set(new_target):
		if attract_target == null:
			attract_target = new_target
			state = STATE.MOVING
		
		elif new_target == null:
			state = STATE.IDLE
			if attract_target.state_changed.is_connected(attract_target_unavailable):
				attract_target.state_changed.disconnect(attract_target_unavailable)
		
		# If new target is closer than old target
		elif position.distance_to(new_target.position) > position.distance_to(attract_target.position):
			if attract_target.state_changed.is_connected(attract_target_unavailable):
				attract_target.state_changed.disconnect(attract_target_unavailable)
			attract_target = new_target
			state = STATE.MOVING
			
#		if not attract_target.state_changed.is_connected(attract_target_unavailable):
#			attract_target.state_changed.connect(attract_target_unavailable)


## Signal reciever for if the current attract_target becomes unavailable
func attract_target_unavailable(_drone:Drone, drone_state:int):
	print("ATU: ", _drone.get_drone_state(), " // ", DroneState.STATE.IDLE)
#	if _drone.get_drone_state() == DroneState.STATE.IDLE:
#	if drone_state == Drone.STATES.STORED:
#		attract_target = null

# =================================================================================================

func _ready():
	add_to_group("pickup")
	set_z_index(10)


func _physics_process(delta):
	if state == STATE.MOVING:
		move_towards(delta)
		rotate(0.05)
#	elif state == STATE.IDLE:
#		rotate(0.1)


## Selects a sprite from the sprite sheet
func randomize_sprite():
	var sprite := $Sprite2D
	var total_frames:int = sprite.get_vframes() * sprite.get_hframes()
	sprite.set_frame(randi_range(0, total_frames - 1))
	
	var rand_size_mult:float = randf_range(1 - size_variance, 1 + size_variance)
	scale *= rand_size_mult


## Move to the attracted target
func move_towards(delta):
	lerp_weight += lerp_increase
	position = position.lerp(attract_target.position, lerp_weight * delta)


## Activates physics process and sets a new target body
func collection_range_entered(new_body:Node):
	attract_target = new_body
