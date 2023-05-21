extends Node2D
# DRONE DEPLOYING CONTROL CORE

@export var rotation_weight:float = 0.2
@onready var deployer := $Sprites/Deployer
@onready var deploy_pnt := $Sprites/Deployer/DeployPoint

func _ready():
	var _ok := DroneManager.connect("drone_deployed", deploy_drone)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotate_deployer()


func rotate_deployer():
	var angle = (get_global_mouse_position() - self.global_position).angle()
	deployer.global_rotation = lerp_angle(deployer.global_rotation, angle, rotation_weight)


func deploy_drone(drone:Drone):
	drone.deploy(deploy_pnt.global_position, deployer.rotation)


func skip_drone():
	pass


func _on_collection_range_body_entered(body):
	if body.is_in_group("drone"):
		body.store()
