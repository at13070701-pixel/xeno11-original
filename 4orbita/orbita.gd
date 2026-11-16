extends Node2D

@export var vel_tierra := 0.5
@export var vel_nave := 1.5

@onready var tierra: AnimatedSprite2D = $Tierra
@onready var pivote: Node2D = $Pivote
@onready var contador: Label = $Contador
@onready var sprite: Sprite2D = $Pivote/Nave/Sprite

var texturas = {
	"trineo": preload("res://2crafteo/cartas/1trineo.png"),
	"dardo": preload("res://2crafteo/cartas/2dardo.png"),
	"bala": preload("res://2crafteo/cartas/3bala.png"),
	"planeador": preload("res://2crafteo/cartas/5planeador.png"),
	"capsula MK2": preload("res://2crafteo/cartas/4capsula MK2.png"),
	"lanzadera": preload("res://2crafteo/cartas/6lanzadera.png"),
	"bengala": preload("res://2crafteo/cartas/7bengala.png"),
	"balista": preload("res://2crafteo/cartas/8balista.png"),
	"transbordador": preload("res://2crafteo/cartas/9transbordador.png"),
}

var angulo_acumulado := 0.0

func _ready():
	var resultado = GameData.cohete_resultado
	if texturas.has(resultado):
		sprite.texture = texturas[resultado]
	else:
		push_warning("Cohete sin sprite: " + resultado)
	contador.text = "Vueltas: " + str(GameState.vueltas)

func _process(delta):
	tierra.rotation += vel_tierra * delta
	var paso = vel_nave * delta
	pivote.rotation += paso
	angulo_acumulado += paso
	if angulo_acumulado >= TAU:
		angulo_acumulado -= TAU
		contador.text = "Vueltas: " + str(GameState.vueltas + 1)
		GameState.registrar_vuelta()
