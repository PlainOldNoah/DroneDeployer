extends Menu

@onready var view_container := %ViewContainer

var drone_view_scene := preload("res://ui/components/drone_view.tscn")



func input(event: InputEvent) -> MENU:
	if event.is_action_pressed("ui_cancel"):
		return MENU.NONE
	return MENU.NULL


func _ready():
	DroneManager.drone_created.connect(create_drone_view)


## Create a new [DroneView] and link 'drone' to it
func create_drone_view(drone:Drone):
	var new_view:DroneView = drone_view_scene.instantiate()
	view_container.add_child(new_view)
	new_view.linked_drone = drone
