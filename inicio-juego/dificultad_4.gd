extends Label

var presupuesto_base: int = 1401
var presupuesto_actual: int = 1401
var presupuesto_infinito: bool = false


var modo_seleccionado: String = "" # Aqui se juarda la opcion


@onready var boton_facil: Sprite2D = $facil4
@onready var boton_normal: Sprite2D = $normal4
@onready var boton_sandbox: Sprite2D = $sadbox4
@onready var boton_construir: Sprite2D = $AConstruir4


@onready var label_presupuesto: Label = $"../presupuesto4"


func _ready():
	actualizar_interfaz()


# DETECTAR CLICS DEL MOUSE
func _input(event):

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			if esta_sobre(boton_facil):
				seleccionar_modo("facil")

			elif esta_sobre(boton_normal):
				seleccionar_modo("normal")

			elif esta_sobre(boton_sandbox):
				print("Clic en SANDBOX")
				seleccionar_modo("sandbox")

			elif esta_sobre(boton_construir):
				if modo_seleccionado != "":
					print("Construcción habilitada")



func esta_sobre(sprite: Sprite2D) -> bool:

	if not is_instance_valid(sprite):
		return false

	var posicion_mouse = sprite.to_local(get_global_mouse_position())

	return sprite.get_rect().has_point(posicion_mouse)



func seleccionar_modo(modo: String):

	modo_seleccionado = modo

	match modo:

		"facil":
			presupuesto_actual = presupuesto_base + 100
			presupuesto_infinito = false

		"normal":
			presupuesto_actual = presupuesto_base
			presupuesto_infinito = false

		"sandbox":
			presupuesto_infinito = true

	actualizar_interfaz()

	print("Dificultad seleccionada: ", modo_seleccionado)

	actualizar_interfaz()

	print("Dificultad seleccionada: ", modo_seleccionado)
	

func actualizar_interfaz():


	if presupuesto_infinito:
		label_presupuesto.text = "Presupuesto: INFINITO"
	else:
		label_presupuesto.text = "Presupuesto: " + str(presupuesto_actual)


	if modo_seleccionado == "":
		boton_construir.modulate = Color(0.45, 0.45, 0.45, 1)
	else:
		boton_construir.modulate = Color.WHITE
