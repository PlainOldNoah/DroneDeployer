extends Menu

@onready var view_container := %ViewContainer
@onready var sort_popup := %SortPopup
@onready var sort_popup_btn := %SortPopupBtn

var drone_view_scene := preload("res://ui/components/drone_view.tscn")


func input(event: InputEvent) -> MENU:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("toggle_drone_overview"):
		return MENU.NONE
	elif event.is_action_pressed("toggle_modification_menu"):
		return MENU.MODIFICATION
	return MENU.NULL


func _ready():
	DroneManager.drone_created.connect(create_drone_view)


## Create a new [DroneView] and link 'drone' to it
func create_drone_view(drone:Drone):
	var new_view:DroneView = drone_view_scene.instantiate()
	view_container.add_child(new_view)
	new_view.linked_drone = drone


## Sort the [DroneView] children [DroneData] value- 'sort_by'
func sort_views(sort_by:String):
	assert(sort_by in DroneData.new())
	
	var views:Array = view_container.get_children()
	
	views.sort_custom(func(a, b): return a.linked_drone.data[sort_by] > b.linked_drone.data[sort_by])
	
	for i in views.size():
		view_container.move_child(views[i], i)


## Button press hub for all sort buttons
func sort_btn_pressed(sort_string:String):
	sort_views(sort_string)
	sort_popup_btn.text = "SORT: %s" % sort_string


func _on_sort_popup_btn_pressed():
	sort_popup.visible = !sort_popup.visible


func debug_print_view(arr:Array):
	for i in arr:
		print(i.linked_drone.data.display_name, ": ", i.linked_drone.data.max_speed, ": ", i.linked_drone.data.damage)
	print(" // ")
