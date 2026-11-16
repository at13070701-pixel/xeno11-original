extends Control

const RONDAS_TOTALES := 5
const APAGADO := Color(0.4, 0.4, 0.4)   # botón "apagado" (oscurecido)
const ENCENDIDO := Color.WHITE          # colores originales del PNG

@export var hoja_botones: Texture2D
@export var area := Rect2(10, 36, 280, 285)   # zona verde de la ventana
@export var escala_botones := 2.5              # qué tan grandes se ven
@export var separacion := 8                    # espacio entre botones
@export var barra := Rect2(0, 0, 300, 28)    

# Región de cada cuadro dentro de botones.png: Rect2(x, y, ancho, alto)
# Orden = orden del Grid: arriba-izq, arriba-der, abajo-izq, abajo-der
const REGIONES := [
	Rect2(106, 40, 48, 46),   # verde
	Rect2(166, 40, 48, 46),   # rojo
	Rect2(106, 96, 48, 46),   # azul
	Rect2(166, 96, 48, 46),   # amarillo
]

var tam: Vector2
var origen: Vector2
var piezas := {}
var terminado := false
var secuencia: Array[int] = []
var indice_jugador := 0
var aceptando_input := false
var arrastrando := false
var offset_ventana := Vector2.ZERO

@onready var botones := [$Grid/Button0, $Grid/Button1, $Grid/Button2, $Grid/Button3]
@onready var boton_inicio := $BotonInicio


func _ready() -> void:
	for i in botones.size():
		var boton: TextureButton = botones[i]

		var atlas := AtlasTexture.new()
		atlas.atlas = hoja_botones
		atlas.region = REGIONES[i]
		boton.texture_normal = atlas
		boton.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST   # <- nueva

		boton.modulate = APAGADO
		boton.pressed.connect(_on_boton_presionado.bind(i))

	boton_inicio.pressed.connect(iniciar_juego)
	boton_inicio.text = "Iniciar"
	acomodar_botones()                                              # <- nueva

func acomodar_botones() -> void:
	var grid: GridContainer = $Grid
	grid.add_theme_constant_override("h_separation", separacion)
	grid.add_theme_constant_override("v_separation", separacion)
	grid.scale = Vector2.ONE * escala_botones

	# Esperar un frame para que el Grid calcule su tamaño real
	await get_tree().process_frame
	grid.size = Vector2.ZERO   # que se encoja al mínimo necesario
	var tam_grid := grid.get_combined_minimum_size() * escala_botones
	grid.position = area.position + (area.size - tam_grid) / 2.0
	
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

func iniciar_juego() -> void:
	secuencia.clear()
	boton_inicio.disabled = true
	siguiente_ronda()


func siguiente_ronda() -> void:
	secuencia.append(randi_range(0, 3))
	await mostrar_secuencia()
	indice_jugador = 0
	aceptando_input = true


func mostrar_secuencia() -> void:
	aceptando_input = false
	await get_tree().create_timer(0.8).timeout
	for i in secuencia:
		await encender(i)
		await get_tree().create_timer(0.3).timeout


func encender(i: int) -> void:
	var boton: TextureButton = botones[i]
	boton.pivot_offset = boton.size / 2
	boton.modulate = ENCENDIDO
	boton.scale = Vector2(1.1, 1.1)
	await get_tree().create_timer(0.5).timeout
	boton.modulate = APAGADO
	boton.scale = Vector2.ONE


func _on_boton_presionado(i: int) -> void:
	if not aceptando_input:
		return
	encender(i)

	if i == secuencia[indice_jugador]:
		indice_jugador += 1
		if indice_jugador == secuencia.size():
			aceptando_input = false
			if secuencia.size() == RONDAS_TOTALES:
				ganar()
			else:
				await get_tree().create_timer(1.0).timeout
				siguiente_ronda()
	else:
		perder()


# Sin label, el feedback es un parpadeo de todos los botones
func parpadear_todos(color: Color) -> void:
	for veces in 2:
		for b in botones:
			b.modulate = color
		await get_tree().create_timer(0.25).timeout
		for b in botones:
			b.modulate = APAGADO
		await get_tree().create_timer(0.25).timeout


func ganar() -> void:
	await parpadear_todos(ENCENDIDO)
	boton_inicio.text = "¡Ganaste!"
	boton_inicio.disabled = false
	GameState.terminar_minijuego(10)   # 10 puntos por ganar


func perder() -> void:
	aceptando_input = false
	await parpadear_todos(Color(1, 0.3, 0.3))
	boton_inicio.text = "Fallaste. Reintentar"
	boton_inicio.disabled = false
