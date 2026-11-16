extends Node

var cohete := ""
var puntos := 0
var resultados := {}
var presupuesto_mision := 0
var vida_minima := 0
var objetivo_cientifico := 0
var dificultad := ""
var peso := 0.0
var precio := 0
var quimica := 0
var vida_util := 0
var cohete_sobrevivio := false
var objetivo_cumplido := false

var vueltas := 0
var minijuegos_jugados := 0
var disponibles: Array = []

const MINIJUEGOS_POR_MISION := 4
const VUELTAS_POR_MINIJUEGO := 2
const PUNTOS_PARA_SOBREVIVIR := 25 

func calcular_resultado():
	# Los puntos de los minijuegos y la vida útil de las cartas deciden la suerte
	cohete_sobrevivio = (puntos + vida_util) >= PUNTOS_PARA_SOBREVIVIR
	objetivo_cumplido = cohete_sobrevivio and quimica > 0

const TODOS_LOS_MINIJUEGOS := [
	"res://videojuegos/puzzle/puzzle.tscn",
	"res://videojuegos/botones puzzle/Botonespuzzle.tscn",
	"res://videojuegos/minijuego ultimo/contraseña.tscn",
]

func nueva_mision(nombre_cohete: String):
	cohete = nombre_cohete
	puntos = 0
	vueltas = 0
	minijuegos_jugados = 0
	resultados.clear()
	disponibles = TODOS_LOS_MINIJUEGOS.duplicate()
	disponibles.shuffle()



func registrar_vuelta():
	vueltas += 1
	print("Vuelta ", vueltas)
	if vueltas % VUELTAS_POR_MINIJUEGO == 0:
		minijuego_random()

func minijuego_random():
	if disponibles.is_empty():
		disponibles = TODOS_LOS_MINIJUEGOS.duplicate()
		disponibles.shuffle()
	var escena = disponibles.pop_front()
	print("Cargando: ", escena)
	get_tree().change_scene_to_file(escena)

func terminar_minijuego(puntaje: int):
	puntos += puntaje
	minijuegos_jugados += 1
	if minijuegos_jugados >= MINIJUEGOS_POR_MISION:
		calcular_resultado()
		get_tree().change_scene_to_file("res://node_2d.tscn")
	else:
		get_tree().change_scene_to_file("res://4orbita/orbita.tscn")
