class_name DDCC
extends Node2D

## Drone Deploying Command Core; Central hub that deploys drones
##
## Acts as main controlling object, most functionality offloaded to gameplay manager

@export var rotation_weight:float = 0.2
@onready var deployer := $Sprites
@onready var deploy_pnt := $Sprites/DeployPoint
@onready var deploy_clearing := $Sprites/DeploymentClearing


#func _ready():
#	$Sprites/Core.set_z_index(40)
#	$Sprites/Inside.set_z_index(20)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotate_deployer()


## Follow the mouse cursor and ease the deployer to face in that direction
func rotate_deployer():
	var angle = (get_global_mouse_position() - self.global_position).angle()
	deployer.global_rotation = lerp_angle(deployer.global_rotation, angle, rotation_weight)


## Returns true if the deployer is free from obstacles
func is_deployer_clear() -> bool:
	if deploy_clearing.get_overlapping_bodies().size() == 0:
		return true
	else:
		return false


## Deploy the drone next in queue if the deploy_clearing is open
func deploy_next_drone():
	if deploy_clearing.get_overlapping_bodies().size() == 0:

		var drone:Drone = DroneManager.get_and_pop_next_drone()
		if drone != null:
			drone.deploy(deploy_pnt.global_position, deployer.rotation)

# ----- Signals -----

## Drone enters the shield area
func _on_shield_area_body_entered(body):
	if body.is_in_group("drone"):
		body._on_ddcc_shield_area_entered()

## Drone leaves the shield area
func _on_shield_area_body_exited(body):
	if body.is_in_group("drone"):
		body._on_ddcc_shield_area_exited()

## Drone enters the collection area/point
func _on_drone_collect_area_body_entered(body):
	if body.is_in_group("drone"):
		body._on_ddcc_collection_pt_entered()

## Drone leaves the collection area/point
func _on_drone_collect_area_body_exited(body):
	if body.is_in_group("drone"):
		body._on_ddcc_collection_pt_exited()

## -=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=

func _on_perimeter_area_entered(_area):
	pass
#	if area.is_in_group("enemy"):
#		GameplayManager.ddcc_take_hit(area.damage)
#		area.queue_free()
#	elif area.is_in_group("scrap"):
#		GameplayManager.add_scrap(area.scrap_value)
#		area.queue_free()


func _on_perimeter_body_entered(_body):
	pass
#	if body.is_in_group("drone") and body.collectable == true:
#		GameplayManager.add_scrap(body.transfer_scrap())
#		body.store()


func _on_perimeter_body_exited(_body):
	pass
#	if body.is_in_group("drone"):
#		body.collectable = true


func _on_collection_range_body_entered(_body):
	pass
#	if body.is_in_group("drone") and body.collectable == true:
#		body.ddcc_collection_range_entered()


#func _on_collection_range_area_entered(area): # TODO
#	if area.is_in_group("scrap"):
#		print("SCRAP IN AREA")












