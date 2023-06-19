extends Node2D

signal total_scrap_updated(total_collected_scrap:float)

@export var rotation_weight:float = 0.2
@onready var deployer := $Sprites/Deployer
@onready var deploy_pnt := $Sprites/Deployer/DeployPoint
@onready var deploy_clearing := $Sprites/Deployer/DeploymentClearing

var total_collected_scrap:float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotate_deployer()


func rotate_deployer():
	var angle = (get_global_mouse_position() - self.global_position).angle()
	deployer.global_rotation = lerp_angle(deployer.global_rotation, angle, rotation_weight)


# Returns true if the deployer is free from obstacles
func is_deployer_clear() -> bool:
	if deploy_clearing.get_overlapping_bodies().size() == 0:
		return true
	else:
		return false


# Deploy the drone next in queue if the deploy_clearing is open
func deploy_next_drone():
	if deploy_clearing.get_overlapping_bodies().size() == 0:

		var drone:Drone = DroneManager.get_and_pop_next_drone()
		if drone != null:
			drone.deploy(deploy_pnt.global_position, deployer.rotation)
			drone.set_home(self)
#		else:
#			print_debug("WARNING: no drones left in queue")


func _on_collection_range_body_entered(body):
	if body.is_in_group("drone") and body.collectable == true:
		body.ddcc_collection_range_entered()


func _on_collection_range_body_exited(body):
	if body.is_in_group("drone"):
		body.ddcc_collection_range_exited()


func _on_core_area_body_entered(body):
	if body.is_in_group("drone"):
		GameplayManager.adjust_total_scrap(body.transfer_scrap())
#		total_collected_scrap += body.transfer_scrap()
		body.store()
#		print("TCS: ", total_collected_scrap)


func _on_core_area_area_entered(area):
	if area.is_in_group("enemy"):
		GameplayManager.ddcc_take_hit(area.damage)
		area.queue_free()


func _on_arming_range_body_exited(_body):
	pass
#	if body.is_in_group("drone"):
#		body.ddcc_arming_range_exited()

