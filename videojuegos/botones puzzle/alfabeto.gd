extends Node2D

var aceptando_input := false
var arrastrando := false
var offset_ventana := Vector2.ZERO

@export var barra := Rect2(0, 0, 300, 28)    

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and barra.has_point(get_local_mouse_position()):
			arrastrando = true
			offset_ventana = get_global_mouse_position() - global_position
		elif not event.pressed:
			arrastrando = false
	elif event is InputEventMouseMotion and arrastrando:
		var nueva := get_global_mouse_position() - offset_ventana
		
		global_position = nueva.clamp(Vector2.ZERO, get_viewport_rect().size - $TextureRect.size)
