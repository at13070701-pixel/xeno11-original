extends ColorRect

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if get_global_rect().has_point(event.global_position):
				print("Iniciando juego...")
				get_tree().change_scene_to_file("res://misiones.tscn")
