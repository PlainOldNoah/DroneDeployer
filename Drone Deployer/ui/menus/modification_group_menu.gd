extends Control

## Group menu consisting of [HangerMenu], [StorageMenu], and [Fabricator]
##
## Pseudo manager type that handles connections between various menus

@onready var hanger:HangerMenu = $HBoxContainer/Hanger
@onready var storage:StorageMenu = $HBoxContainer/Storage
@onready var fabricator:Fabricator = $HBoxContainer/Fabricator

## Currently selected augments from the [StorageMenu]
var selected_augments:Array[AugmentDisplay] = []
## 
var augmented_drone_stats:DroneData = null


## Called when the node enters the scene tree for the first time.
func _ready():
	hanger.focused_drone_updated.connect(update_drone_stat_info)
	storage.augment_selected.connect(_on_augment_selected)
	hanger.augment_commit_request.connect(commit_augments_to_drone)
#	storage.selected_augments_updated.connect(update_drone_stat_info)


## Shows the hanger and hides the fabricator
func set_hanger_view():
	pass
#	hanger.show()
#	fabricator.hide()
## Shows the fabricator and hides the hanger
func set_fabricator_view():
	pass
#	hanger.hide()
#	fabricator.show()


## Recieved from [StorageMenu] when augment is clicked
func _on_augment_selected(augment:AugmentDisplay):
	if (augment.selected == false) and (selected_augments.has(augment)):
		selected_augments.erase(augment)
	else:
		selected_augments.append(augment)
	
	update_drone_stat_info()


## Refresh the Hanger's selected drone's stat block
func update_drone_stat_info():
	augmented_drone_stats = hanger.augment_drone_stats(selected_augments)
	hanger.update_display(augmented_drone_stats)


func commit_augments_to_drone():
#	for i in selected_augments:
#		i.queue_free()
#
	selected_augments.clear()
	
	hanger.focused_drone.data = augmented_drone_stats.duplicate()
