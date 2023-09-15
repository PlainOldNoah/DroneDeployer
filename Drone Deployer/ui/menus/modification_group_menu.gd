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
	# Tell hanger about currently selected augments
	storage.augment_selected.connect(hanger._on_augment_selected)


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
