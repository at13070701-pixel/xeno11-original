extends Node2D

@onready var info_estado: Label = $Estadisticas/InfoEstado
@onready var info_objetivo: Label = $Estadisticas/info_objetivo
@onready var info_peso: Label = $Estadisticas/info_peso
@onready var info_precio: Label = $Estadisticas/info_precio
@onready var boton: Button = $boton

func _ready():
	info_estado.text = "Éxito" if GameState.cohete_sobrevivio else "Cohete destruido"
	info_objetivo.text = "Sí" if GameState.objetivo_cumplido else "No"
	info_peso.text = str(GameState.peso) + " T"
	info_precio.text = "$" + str(GameState.precio) + " millones"
	boton.pressed.connect(_on_volver)

func _on_volver():
	get_tree().change_scene_to_file("res://main.tscn")
