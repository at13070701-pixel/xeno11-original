extends Control

const CONTRASENA_CORRECTA = "hamilton"

@onready var campo = $LineEdit
@onready var boton = $Button
@onready var resultado = $Resultado

signal contrasena_correcta

var terminado := false

func _ready():
	boton.pressed.connect(_verificar)
	campo.text_submitted.connect(func(_texto): _verificar())

func _verificar():
	if terminado:
		return
	var intento = campo.text.strip_edges().to_lower()
	if intento == CONTRASENA_CORRECTA:
		terminado = true
		resultado.text = "¡Correcto!"
		contrasena_correcta.emit()
		await get_tree().create_timer(1.5).timeout
		GameState.terminar_minijuego(10)
	else:
		resultado.text = "Contraseña incorrecta"
		campo.clear()
