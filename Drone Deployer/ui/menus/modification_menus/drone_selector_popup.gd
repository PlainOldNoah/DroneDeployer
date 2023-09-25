extends MarginContainer

## Handles the popup menu and adding drones to it

signal d_mirror_selected(drone:Drone)

@onready var display := $Panel/MarginContainer/VBoxContainer/GridContainer

@export var drone_mirror_scene:PackedScene = null


## Create a new [DroneMirror] and add it to the grid
func add_drone_mirror(link_drone:Drone):
	var d_mirror_inst:DroneMirror = drone_mirror_scene.instantiate()
	display.add_child(d_mirror_inst)
	
	d_mirror_inst.pressed.connect(_on_mirror_clicked.bind(d_mirror_inst))
	d_mirror_inst.linked_drone = link_drone

## Hides the popup
func close_popup():
	self.hide()

## Close the popup and return the mirror that was clicked
func _on_mirror_clicked(mirror:DroneMirror):
	close_popup()
	emit_signal("d_mirror_selected", mirror.linked_drone)

## Close the popup when CloseBtn is pressed
func _on_close_btn_pressed():
	close_popup()
