extends Node2D

signal hovered
signal hovered_off
signal right_clicked
var equipped = false

var current_slot = null

enum CardType {
	CABINA,
	MOTOR,
	ALAS,
	PATAS,
	ESCUDO,
	PANELES,
	ANTENAS,
	CARGA
}

@export var card_type : CardType

@export var card_name : String

@export var precio : int

@export var peso : float

@export var quimica : int

@export var vida_util : float

func _ready() -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
	
func set_equipped_state(value):

	equipped = value

	$Panel.visible = !value
	$Card_image.visible = true
	
	if value:
		scale = Vector2(0.7, 0.7)
	else:
		scale = Vector2.ONE
		
func set_card_visible(value):

	visible = value

	$Area2D.monitoring = value
	$Area2D.monitorable = value


	


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed: 
		if event.button_index == MOUSE_BUTTON_RIGHT: 
			emit_signal("right_clicked", self)
