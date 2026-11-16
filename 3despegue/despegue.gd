extends Node2D

func _ready():
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://4orbita/orbita.tscn")
"""var texturas = {
	"trineo": preload("res://2crafteo/cartas/1trineo.png"),
	"dardo": preload("res://2crafteo/cartas/2dardo.png"),
	"bala": preload("res://2crafteo/cartas/3bala.png"),
	"planeador": preload("res://2crafteo/cartas/5planeador.png"),
	"capsula MK2": preload("res://2crafteo/cartas/4capsula MK2.png"),
	"lanzadera": preload("res://2crafteo/cartas/6lanzadera.png"),
	"bengala": preload("res://2crafteo/cartas/7bengala.png"),
	"balista": preload("res://2crafteo/cartas/8balista.png"),
	"transbordador": preload("res://2crafteo/cartas/9transbordador.png")
	}
	
func _ready():
	var resultado = GameData.cohete_resultado
	if texturas.has(resultado):
		sprite.texture = texturas[resultado]
	else:
		push_warning("Cohete sin sprite: " + resultado)
	
func _ready():
	$AnimationPlayer.animation_finished.connect(_on_animacion_terminada)
	$AnimationPlayer.play("despegue")

func _on_animacion_terminada(_nombre):
	get_tree().change_scene_to_file("res://4orbita/orbita.tscn")"""
