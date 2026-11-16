extends Sprite2D

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
			var posicion_mouse = to_local(get_global_mouse_position())

			if get_rect().has_point(posicion_mouse):
				print("Iniciando juego...")
				get_tree().change_scene_to_file("res://mision3.tscn")
