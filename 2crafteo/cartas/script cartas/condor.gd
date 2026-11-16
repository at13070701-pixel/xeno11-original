extends Sprite2D
@export var item_id: String = "condor"
signal soltado(item)

var arrastrando := false
var posicion_original: Vector2

func _ready():
	add_to_group("items")  
	posicion_original = global_position

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(get_global_mouse_position())):
			arrastrando = true
			z_index = 10  
		elif not event.pressed and arrastrando:
			arrastrando = false
			z_index = 0
			soltado.emit(self)
	elif event is InputEventMouseMotion and arrastrando:
		global_position = get_global_mouse_position()
