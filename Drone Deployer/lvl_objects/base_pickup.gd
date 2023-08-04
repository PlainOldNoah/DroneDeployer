extends Area2D

@export_range(0,999,0.5) var points := 1.0

#var attraction_multiplier:float = 0.5
#var acceleration:Vector2 = Vector2.ZERO
#var dir:Vector2 = Vector2.ZERO
#var velocity:Vector2 = Vector2.ZERO
var lerp_weight:float = 0.5


## Current node (Drone?) that this scrap is currently attracted towards
var attract_target:Node = null:
	set(new_target):
		if attract_target == null:
			attract_target = new_target
		
		elif new_target == null:
			if attract_target.state_changed.is_connected(attract_target_unavailable):
				attract_target.state_changed.disconnect(attract_target_unavailable)
		
		# If new target is closer than old target
		elif position.distance_to(new_target.position) > position.distance_to(attract_target.position):
			if attract_target.state_changed.is_connected(attract_target_unavailable):
				attract_target.state_changed.disconnect(attract_target_unavailable)
			attract_target = new_target
			
		if not attract_target.state_changed.is_connected(attract_target_unavailable):
			attract_target.state_changed.connect(attract_target_unavailable)

		# Turn off physics if attract_target is null
		set_physics_process(attract_target != null)


## Signal reciever for if the current attract_target becomes unavailable
func attract_target_unavailable(_drone:Drone, state:int):
	if state == Drone.STATES.STORED:
		attract_target = null

# =================================================================================================

func _ready():
	add_to_group("pickup")
	set_z_index(10)
#	set_physics_process(false)


func randomize_sprite():
	var sprite := $Sprite2D
	var total_frames:int = sprite.get_vframes() * sprite.get_hframes()
	sprite.set_frame(randi_range(0, total_frames - 1))


func _physics_process(delta):
	if attract_target != null:
		move_towards(delta)
#	else:
#		slow_movement(delta)


#	print("E")
#	acceleration = Vector2()
#	var dir = (attract_target.position - position).normalized()
##	var mag = position.distance_to(attract_target.position)
##	print(self, ", ", mag)
#	if attract_target != null:
#		acceleration += dir * attract_force
#	else:
#		acceleration -= dir * attract_force
#
#	velocity += acceleration * delta
#	position += velocity


## Move to the attracted target
func move_towards(delta):
	lerp_weight += 0.5
	position = position.lerp(attract_target.position, lerp_weight * delta)


func slow_movement(delta):
	pass
#	print("Hello?")
#	acceleration = Vector2()
#	acceleration *= .95

#	velocity = Vector2.ZERO
#	position += velocity


#func stop():
#	if attract_target.state_changed.is_connected():
#		disconnect(attract_target.state_changed, test)
#	attract_target = null


## Activates physics process and sets a new target body
func collection_range_entered(new_body:Node):
	attract_target = new_body
