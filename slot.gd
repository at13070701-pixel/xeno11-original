extends Panel

@export var slot_type : int

@onready var slot_label  = get_child(0)

var current_card = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
