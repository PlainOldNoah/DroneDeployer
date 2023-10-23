extends Menu

## Menu layout to display [DroneView] nodes for each drone
##
## Provides an easy way to view all drones in game and their state

## Emitted when a [DroneView] is pressed
signal drone_selected(drone_view:DroneView)

@onready var view_container := %ViewContainer
@onready var sort_popup := %SortPopup
@onready var sort_popup_btn := %SortPopupBtn

var drone_view_scene := preload("res://ui/components/drone_view.tscn")

## Reference to the DroneOverview menu
var hanger_ref:HangerMenu


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
	
	new_view.pressed.connect(_on_drone_view_selected)


## Returns a DroneView 'offset' number of children away from 'drone_view'
func get_view_from_offset(drone_view:DroneView, offset:int=0):
	if view_container.get_children().has(drone_view):
		var target_index:int = (drone_view.get_index() + offset) % view_container.get_child_count()
		return view_container.get_child(target_index)


## Emit the 'drone_selected' when a DroneView emits 'pressed'
func _on_drone_view_selected(drone_view:DroneView):
	emit_signal("drone_selected", drone_view)


# === Sorting ===

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
