extends Control

## Group menu consisting of [HangerMenu], [StorageMenu], and [Fabricator]
##
## Pseudo manager type that handles connections between various menus

@onready var hanger := $HBoxContainer/Hanger
@onready var storage := $HBoxContainer/Storage
@onready var fabricator := $HBoxContainer/Fabricator


## Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
