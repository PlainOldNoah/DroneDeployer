extends HBoxContainer

## Group menu consisting of [HangerMenu], [StorageMenu], and [Fabricator]
##
## Pseudo manager type that handles connections between various menus

@onready var hanger := $Hanger
@onready var storage := $Storage
@onready var fabricator := $Fabricator

## Called when the node enters the scene tree for the first time.
func _ready():
	var _ok := fabricator.connect("augment_fabricated", storage.add_augment)
