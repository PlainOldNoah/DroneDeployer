extends HBoxContainer

## Group menu consisting of [HangerMenu], [StorageMenu], and [Fabricator]
##
## Pseudo manager type that handles connections between various menus

enum SUB_VIEWS {
	HANGER, ## Hanger + Storage
	FABRICATOR, ## Fabricator + Storage
	}

@onready var hanger := $Hanger
@onready var storage := $Storage
@onready var fabricator := $Fabricator

## Called when the node enters the scene tree for the first time.
func _ready():
	var _ok := fabricator.connect("augment_fabricated", storage.add_augment)


## Sets the view to the [HangerMenu] or [Fabricator], both include [StorageMenu]
func set_view(view:SUB_VIEWS):
	match view:
		SUB_VIEWS.HANGER:
			hanger.show()
			fabricator.hide()
		SUB_VIEWS.FABRICATOR:
			hanger.hide()
			fabricator.show()
		_:
			print_debug("ERROR: view <", view, "> not defined")
