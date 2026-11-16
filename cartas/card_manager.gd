extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_SLOT = 2

var screen_size
var card_being_dragged = null
var is_hovering_on_card = false
var all_cards = []

var peso_total = 0
var precio_total = 0
var quimica_total = 0
var vida_util_total = 0



var categories = {
	"CABINA": [],
	"MOTOR": [],
	"ALAS": [],
	"PATAS": [],
	"ESCUDO": [],
	"PANELES": [],
	"ANTENAS": [],
	"CARGA": []
}

var cohete_actual := ""

var presupuesto_max = 100

var rutas_cohetes := {
	"trineo": "res://2crafteo/cartas/1trineo.png",
	"dardo": "res://2crafteo/cartas/2dardo.png",
	"bala": "res://2crafteo/cartas/3bala.png",
	"capsula MK2": "res://2crafteo/cartas/4capsula MK2.png",
	"planeador": "res://2crafteo/cartas/5planeador.png",
	"lanzadera": "res://2crafteo/cartas/6lanzadera.png",
	"bengala": "res://2crafteo/cartas/7bengala.png",
	"balista": "res://2crafteo/cartas/8balista.png",
	"transbordador": "res://2crafteo/cartas/9transbordador.png",
}
# clave: "cabina+motor"
var recetas := {
	"peregrin+sepraton1": "trineo",
	"peregrin+hammer": "dardo",
	"peregrin+clydesdale": "bala",
	"osprey+sepraton1": "capsula MK2",
	"osprey+hammer": "planeador",
	"osprey+clydesdale": "lanzadera",
	"condor+sepraton1": "bengala",
	"condor+hammer": "balista",
	"condor+clydesdale": "transbordador",
}

var texturas_cohetes := {
	"trineo": preload("res://2crafteo/cartas/1trineo.png"),
	"dardo": preload("res://2crafteo/cartas/2dardo.png"),
	"bala": preload("res://2crafteo/cartas/3bala.png"),
	"capsula MK2": preload("res://2crafteo/cartas/4capsula MK2.png"),
	"planeador": preload("res://2crafteo/cartas/5planeador.png"),
	"lanzadera": preload("res://2crafteo/cartas/6lanzadera.png"),
	"bengala": preload("res://2crafteo/cartas/7bengala.png"),
	"balista": preload("res://2crafteo/cartas/8balista.png"),
	"transbordador": preload("res://2crafteo/cartas/9transbordador.png"),
}

func _ready() -> void:
	screen_size = get_viewport_rect().size
	
	categories["CABINA"] = [
		preload("res://peregrin.tscn"),
		preload("res://cartas/osprey.tscn"),
		preload("res://cartas/condor.tscn")
	]

	categories["MOTOR"] = [
		preload("res://cartas/sepraton1.tscn"),
		preload("res://cartas/hammer.tscn"),
		preload("res://cartas/clydesdale.tscn")
	]
	
	categories["ALAS"] = [
		preload("res://cartas/alas1.tscn"),
		preload("res://cartas/alas2.tscn"),
		preload("res://cartas/alas3.tscn"),
		preload("res://cartas/alas4.tscn")
	]
	categories["PATAS"] = [
		preload("res://cartas/patas1.tscn")
	]
	categories["ESCUDO"] = [
		preload("res://cartas/escudos1.tscn"),
		preload("res://cartas/escudos2.tscn")
	]
	categories["PANELES"] = [
		preload("res://cartas/paneles1.tscn"),
		preload("res://cartas/paneles2.tscn")
	]
	categories["ANTENAS"] = [
		preload("res://cartas/antena1.tscn")
	]
	categories["CARGA"]=[
		preload("res://cartas/carga1.tscn"),
		preload("res://cartas/carga2.tscn")
		
	]
	
	for category in categories:

		for scene in categories[category]:

			var card = scene.instantiate()

			card.visible = false

			$"../CardContainer".add_child(card)

			connect_card_signals(card)

			all_cards.append(card)
	presupuesto_max = GameState.presupuesto_mision

	print("Presupuesto recibido: ", presupuesto_max)

	actualizar_presupuesto()

	screen_size = get_viewport_rect().size
func actualizar_presupuesto():

	precio_total = 0

	for slot in $"../CraftGrid".get_children():

		if not ("current_card" in slot):
			continue

		if slot.current_card == null:
			continue

		precio_total += slot.current_card.precio

	var disponible = presupuesto_max - precio_total

	$"../BudgetPanel/BudgetLabel".text = \
		"💰 Presupuesto: $" + str(disponible)

	return disponible

	

func get_slot_under_mouse():
	var slots = get_parent().get_node("CraftGrid").get_children()

	var mouse_pos = get_global_mouse_position()

	for slot in slots:

		if !("current_card" in slot):
			continue

		var rect = Rect2(
			slot.global_position,
			slot.size
		)

		if rect.has_point(mouse_pos):
			return slot

	return null


func _process(_delta):
	# Si hay una carta siendo arrastrada, sigue la posición del ratón
	if card_being_dragged:
		card_being_dragged.global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton:

		# === CLIC IZQUIERDO ===
		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:
				# Al presionar: toma la carta solo si no estamos arrastrando otra
				if card_being_dragged == null:
					var card = raycast_check_for_card()

					if card:
						start_drag(card)

			else:
				# Al SOLTAR el clic (pressed == false): suelta la carta inmediatamente
				if card_being_dragged != null:
					finish_drag()

		# === CLIC DERECHO ===
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:

			if card_being_dragged == null:
				var card = raycast_check_for_card()

				if card:
					show_card_info(card)

func start_drag(card):

	if card.current_slot != null:

		card.current_slot.current_card = null
		card.current_slot.slot_label.visible = true

		card.reparent($"../CardContainer")

		card.current_slot = null


		card.set_equipped_state(false)
		actualizar_totales()
		revisar_receta() 
		actualizar_presupuesto()
	card_being_dragged = card
	card.scale = Vector2(1.05, 1.05)

func finish_drag():

	if card_being_dragged == null:
		return

	var slot = get_slot_under_mouse()

	if slot:

		if slot.current_card == null and card_being_dragged.card_type == slot.slot_type:

			# Validar presupuesto antes de equipar
			if precio_total + card_being_dragged.precio > presupuesto_max:

				print("No hay presupuesto suficiente")

				card_being_dragged.scale = Vector2.ONE
				card_being_dragged = null

				return

			card_being_dragged.reparent(slot)

			# Centrar dentro del slot
			card_being_dragged.position = slot.size / 2

			slot.current_card = card_being_dragged
			slot.slot_label.visible = false

			card_being_dragged.current_slot = slot
			card_being_dragged.set_equipped_state(true)

			revisar_receta()
			actualizar_presupuesto()

	card_being_dragged.scale = Vector2.ONE
	card_being_dragged = null
			
func connect_card_signals(card):

	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
	card.connect("right_clicked", show_card_info)
	
func show_card_info(card):

	$"../StatsPanel/VBoxContainer/Nombre".text = " "+card.card_name

	$"../StatsPanel/VBoxContainer/Precio".text =" Precio: $" + str(card.precio)+" millones."

	$"../StatsPanel/VBoxContainer/Peso".text =" Peso: " + str(card.peso)+" T."

	$"../StatsPanel/VBoxContainer/Quimica".text =" Quimica: " + str(card.quimica)

	$"../StatsPanel/VBoxContainer/VidaUtil".text =" Vida util: " + str(card.vida_util)+" Años."
	
func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card,true)

func on_hovered_off_card(card):
	if card_being_dragged != null:
		highlight_card(card,false)
		
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered,true)
		else:
			is_hovering_on_card = false
	
	
func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1
		
	

			

func raycast_check_for_card():

	var space_state = get_world_2d().direct_space_state

	var parameters = PhysicsPointQueryParameters2D.new()

	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD

	var result = space_state.intersect_point(parameters)

	for hit in result:

		var card = hit.collider.get_parent()

		if card.visible:
			return card

	return null
	
	

func show_category(category_name):

	for card in all_cards:
		if card.current_slot == null:
			card.set_card_visible(false)

	var spacing = 140
	var index = 0

	for card in all_cards:

		if card.current_slot != null:
			continue

		if card.card_type == card.CardType[category_name]:

			card.set_card_visible(true)

			card.position = Vector2(
				index * spacing,
				0
			)

			index += 1




func _on_btn_cabina_pressed() -> void:
	show_category("CABINA")



	

func _on_btn_alas_pressed() -> void:
	show_category("ALAS")

func _on_btn_patas_pressed() -> void:
	show_category("PATAS")
	
func _on_btn_escudo_pressed() -> void:
	show_category("ESCUDO")

func _on_btn_paneles_pressed() -> void:
	show_category("PANELES")

func _on_btn_antenas_pressed() -> void:
	show_category("ANTENAS")

func _on_btn_carga_pressed() -> void:
	show_category("CARGA")
	
func _on_btn_motor_pressed() -> void:
	show_category("MOTOR")

func carta_equipada(categoria: String):
	for slot in $"../CraftGrid".get_children():
		if not ("current_card" in slot):
			continue
		var c = slot.current_card
		if c != null and c.card_type == c.CardType[categoria]:
			return c
	return null

func id_de_carta(carta) -> String:
	return carta.scene_file_path.get_file().get_basename().to_lower()

func revisar_receta():
	cohete_actual = ""
	var cabina = carta_equipada("CABINA")
	var motor = carta_equipada("MOTOR")
	if cabina != null and motor != null:
		var clave = id_de_carta(cabina) + "+" + id_de_carta(motor)
		print("Clave: ", clave)
		if recetas.has(clave):
			cohete_actual = recetas[clave]
	GameData.cohete_resultado = cohete_actual
	GameState.cohete = cohete_actual
	$"../BtnLanzar".visible = cohete_actual != ""
	var vista = $"../CoheteVista"
	if cohete_actual != "" and rutas_cohetes.has(cohete_actual):
		var tex = load(rutas_cohetes[cohete_actual])
		if tex:
			vista.texture = tex
			vista.visible = true
		else:
			push_warning("No existe la imagen: " + rutas_cohetes[cohete_actual])
			vista.visible = false
	else:
		vista.visible = false
	print("Cohete: ", cohete_actual, " | Botón visible: ", $"../BtnLanzar".visible)

func _on_btn_lanzar_pressed():
	if cohete_actual == "":
		return
	actualizar_totales()
	GameState.nueva_mision(cohete_actual)   # primero, porque reinicia valores
	GameState.peso = peso_total
	GameState.precio = precio_total
	GameState.quimica = quimica_total
	GameState.vida_util = vida_util_total
	get_tree().change_scene_to_file("res://anime/DespegueAnimacion.tscn")

func actualizar_totales():

	peso_total = 0
	precio_total = 0
	quimica_total = 0
	vida_util_total = 0

	for slot in $"../CraftGrid".get_children():

		if slot.current_card == null:
			continue

		var c = slot.current_card

		peso_total += c.peso
		precio_total += c.precio
		quimica_total += c.quimica
		vida_util_total += c.vida_util
