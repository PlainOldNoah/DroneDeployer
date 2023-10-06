extends Camera2D

#func _unhandled_input(event):
	

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		offset = Vector2.ZERO
	elif event.is_action_pressed("zoom_in"):
		zoom += Vector2(0.025, 0.025)
	elif event.is_action_pressed("zoom_out"):
		zoom -= Vector2(0.025, 0.025)
	
	zoom = zoom.clamp(Vector2(0.56, 0.56), Vector2(1,1))


func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	offset += input_direction * 10

func _physics_process(_delta):
	get_input()
