extends DroneUpgrade

## Mock Drone Behavior, used for debugging and testing

func _process(_delta):
	$Sprite2D.rotate(0.1)
