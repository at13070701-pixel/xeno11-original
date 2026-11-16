extends Sprite2D

signal soltada(pieza)

var celda_correcta: Vector2i
var celda_actual: Vector2i
var bloqueada := false

var arrastrando := false
var desfase := Vector2.ZERO

func _input(event):
	if bloqueada:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(get_global_mouse_position())):
			arrastrando = true
			desfase = global_position - get_global_mouse_position()
			z_index = 10  
		elif not event.pressed and arrastrando:
			arrastrando = false
			z_index = 0
			soltada.emit(self)
	elif event is InputEventMouseMotion and arrastrando:
		global_position = get_global_mouse_position() + desfase
