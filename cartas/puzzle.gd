extends Node2D

const COLUMNAS := 3
const FILAS := 2

@export var imagen: Texture2D
@export var area := Rect2(10, 36, 280, 285)   # zona verde, relativa a la ventana
@export var barra := Rect2(0, 0, 300, 28)     # barra de título "PELIGRO", la parte que agarras

@onready var mensaje: Label = get_node_or_null("Mensaje")

var tam: Vector2
var origen: Vector2
var piezas := {}
var terminado := false

var arrastrando := false
var offset_ventana := Vector2.ZERO


func _ready():
	var tam_orig := Vector2(imagen.get_width() / float(COLUMNAS), imagen.get_height() / float(FILAS))
	var escala: float = min(area.size.x / imagen.get_width(), area.size.y / imagen.get_height())
	tam = tam_orig * escala

	var tablero := Vector2(COLUMNAS, FILAS) * tam
	origen = area.position + (area.size - tablero) / 2.0

	var celdas := []
	for y in FILAS:
		for x in COLUMNAS:
			celdas.append(Vector2i(x, y))
	var mezcladas := celdas.duplicate()
	mezcladas.shuffle()

	for i in celdas.size():
		var p = Sprite2D.new()
		p.set_script(preload("res://pieza.gd"))
		p.texture = imagen
		p.centered = false
		p.region_enabled = true
		p.region_rect = Rect2(Vector2(celdas[i]) * tam_orig, tam_orig)
		p.scale = Vector2(escala, escala)
		p.celda_correcta = celdas[i]
		p.soltada.connect(_on_soltada)
		add_child(p)
		_colocar(p, mezcladas[i])


# --- Mover la ventana agarrando la barra de título ---
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and barra.has_point(get_local_mouse_position()):
			arrastrando = true
			offset_ventana = get_global_mouse_position() - global_position
		elif not event.pressed:
			arrastrando = false
	elif event is InputEventMouseMotion and arrastrando:
		var nueva := get_global_mouse_position() - offset_ventana
		# que la ventana no se salga de la pantalla
		global_position = nueva.clamp(Vector2.ZERO, get_viewport_rect().size - $TextureRect.size)


# _colocar, _on_soltada y revisar_victoria se quedan igual,
# solo cambia el final de revisar_victoria para no truncarse si falta el Label:
#	if mensaje:
#		mensaje.visible = true

func _colocar(p, celda: Vector2i):
	p.celda_actual = celda
	p.position = origen + Vector2(celda) * tam
	piezas[celda] = p

func _on_soltada(pieza):
	var anterior: Vector2i = pieza.celda_actual

	# Celda donde cayó el centro de la pieza
	var local = pieza.position + tam / 2.0 - origen
	var celda = Vector2i(floor(local.x / tam.x), floor(local.y / tam.y))

	var dentro = celda.x >= 0 and celda.x < COLUMNAS and celda.y >= 0 and celda.y < FILAS
	if not dentro or celda == anterior:
		_colocar(pieza, anterior)  # regresa a su lugar
		return

	# Intercambio con la pieza que estaba en esa celda
	var otra = piezas[celda]
	_colocar(otra, anterior)
	_colocar(pieza, celda)
	revisar_victoria()

func revisar_victoria():
	for p in piezas.values():
		if p.celda_actual != p.celda_correcta:
			return
	terminado = true
	for p in piezas.values():
		p.bloqueada = true
