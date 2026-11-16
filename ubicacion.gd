extends Node2D

@onready var tilemap: TileMapLayer = $TileMapLayer

const ORIGEN := Vector2(0, 0)       # esquina superior izquierda de la mesa
const PASO := 95.0                  # distancia de un cuadro al siguiente
const TAMANO_CUADRO := 81.0         # tamaño de cada cuadro

var recetas := {
	"peregrine+sepraton1": "trineo",
	"hammer+peregrine": "dardo",
	"clydesdale+peregrine": "bala",
	"osprey+sepraton1": "capsula_MK2",
	"hammer+osprey": "planeador",
	"clydesdale+osprey": "lanzadera",
	"condor+sepraton1": "bengala",
	"condor+hammer": "balista",
	"clydesdale+condor": "transbordador",
}

var slots := {}  # Vector2i (celda 0-2) -> item

func _ready():
	$trineo.visible = false
	$dardo.visible = false
	$bala.visible = false
	$capsula.visible = false
	$planeador.visible = false
	$lanzadera.visible = false
	$bengala.visible = false
	$balista.visible = false
	$transbordador.visible = false
	for item in get_tree().get_nodes_in_group("items"):
		item.soltado.connect(_on_item_soltado)

func _centro_de_celda(celda: Vector2i) -> Vector2:
	return to_global(ORIGEN + Vector2(celda) * PASO + Vector2(TAMANO_CUADRO, TAMANO_CUADRO) / 2.0)

func _on_item_soltado(item):
	var local = to_local(item.global_position) - ORIGEN
	var celda = Vector2i(floor(local.x / PASO), floor(local.y / PASO))
	print("Celda: ", celda)  # depuración

	var dentro = celda.x >= 0 and celda.x < 3 and celda.y >= 0 and celda.y < 3
	# Libera la celda anterior del item (si tenía una)
	for c in slots.keys():
		if slots[c] == item:
			slots.erase(c)

	if dentro and not slots.has(celda):
		slots[celda] = item
		item.global_position = _centro_de_celda(celda)
		revisar_receta()
	else:
		item.global_position = item.posicion_original

func revisar_receta():
	var ids := []
	for item in slots.values():
		ids.append(item.item_id)
	ids.sort()
	var clave = "+".join(ids)
	print("Clave: ", clave)  # <- para depurar

	if recetas.has(clave):
		crear_resultado(recetas[clave])

func crear_resultado(nombre: String):
	print("¡Creaste: ", nombre, "!")
	# Posición final: la celda central (1,1) de la mesa
	var pos_final = _centro_de_celda(Vector2i(1, 1))

	for item in slots.values():
		item.queue_free()
	slots.clear()

	var nuevo = get_node(nombre)  # busca el nodo hijo llamado "IDK2"
	nuevo.global_position = pos_final
	nuevo.visible = true
