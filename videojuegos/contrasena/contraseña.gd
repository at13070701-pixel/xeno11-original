extends Control  # cambia esto si tu nodo raíz es Node2D u otro tipo

const CONTRASENA_CORRECTA = "hamilton"

@onready var campo = $LineEdit
@onready var boton = $Button
@onready var resultado = $Resultado

signal contrasena_correcta

func _ready():
	boton.pressed.connect(_verificar)
	campo.text_submitted.connect(func(_texto): _verificar())  # permite usar Enter

func _verificar():
	var intento = campo.text.strip_edges().to_lower()
	if intento == CONTRASENA_CORRECTA:
		resultado.text = "¡Correcto!"
		contrasena_correcta.emit()
		GameState.terminar_minijuego(10)   # 10 puntos por ganar
	else:
		resultado.text = "Contraseña incorrecta"
		campo.clear()
