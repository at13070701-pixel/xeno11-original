extends Node2D

@onready var cohete: Sprite2D = $Cohete
@onready var anim: AnimationPlayer = $Despegue

var texturas = {
	"trineo": preload("res://anime/1trineo_v2.png"),
	"dardo": preload("res://anime/2dardo_v2.png"),
	"bala": preload("res://anime/3bala_v2.png"),
	"capsula MK2": preload("res://anime/4capsula_MK2_v2.png"),
	"planeador": preload("res://anime/5planeador_v2.png"),
	"lanzadera": preload("res://anime/6lanzadera_v2.png"),
	"bengala": preload("res://anime/7bengala_v2.png"),
	"balista": preload("res://anime/8balista_v2.png"),
	"transbordador": preload("res://anime/9transbordador_v2.png"),
}
@onready var fuego: AnimatedSprite2D = $Cohete/Fuego
@onready var animacion: AnimationPlayer = $Despegue

func _ready():
	fuego.visible = false
	fuego.play()  # la animación del fuego corre aunque esté oculto

	GameData.cohete_resultado # SOLO PARA PRUEBAS
	var resultado = GameData.cohete_resultado
	if texturas.has(resultado):
		cohete.texture = texturas[resultado]
	else:
		push_warning("Cohete sin sprite: " + resultado)

	anim.play("Despegue")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://orbita.tscn")
	anim.play("Despegue")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://orbita.tscn") # cambia la ruta a tu escena real
