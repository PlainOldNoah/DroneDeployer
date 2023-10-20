class_name DDCC
extends Node2D

## Drone Deploying Command Core; Central hub that deploys drones
##
## Acts as main controlling object, most functionality offloaded to gameplay manager

@export var rotation_weight:float = 0.2
@onready var deployer := $Sprites
@onready var deploy_pnt := $Sprites/DeployPoint
@onready var deploy_clearing := $Sprites/DeploymentClearing


func _ready():
	add_to_group("ddcc")
#	$Sprites/Core.set_z_index(40)
#	$Sprites/Inside.set_z_index(20)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_deployer(delta)


## Follow the mouse cursor and ease the deployer to face in that direction
func rotate_deployer(delta:float):
	var angle = (get_global_mouse_position() - self.global_position).angle()
	global_rotation = lerp_angle(global_rotation, angle, rotation_weight * delta)
#	deployer.global_rotation = lerp_angle(deployer.global_rotation, angle, rotation_weight * delta)


## Returns true if the deployer is free from obstacles
func is_deployer_clear() -> bool:
#	return true
	if deploy_clearing.get_overlapping_bodies().size() == 0:
		return true
	else:
		return false


## Deploy the drone next in queue if the deploy_clearing is open
func deploy_next_drone():
	if is_deployer_clear():

		var drone:Drone = DroneManager.get_and_pop_next_drone()
		if drone != null:
			drone.deploy(deploy_pnt.global_position, deployer.global_rotation)


## When an enemy hits the shield take damage and remove the enemy
func take_hit(enemy:BaseEnemy):
	GameplayManager.ddcc_take_hit(enemy.damage)
	enemy.queue_free()


## When a scrap item enters the shield area, collect it
func collect_scrap(scrap:Scrap):
	GameplayManager.add_scrap(scrap._on_collected())
#	GameplayManager.add_scrap(round(scrap.value))
#	scrap.queue_free()


# ----- Signals -----

## Enemy enters shield area
func _on_shield_area_area_entered(area):
	if area.is_in_group("enemy"):
		take_hit(area)
	elif area.is_in_group("scrap"):
		collect_scrap(area)


func _on_shield_area_body_exited(body):
	if body is Drone:
		body.ddcc_shield_area_exited()


func _on_shield_area_body_entered(body):
	if body is Drone:
		body.ddcc_shield_area_entered()


func _on_receiver_body_entered(body):
	if body is Drone:
		body.collect()





