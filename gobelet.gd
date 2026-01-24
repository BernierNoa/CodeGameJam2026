extends Area2D

signal a_ete_clique(gobelet)

var a_la_balle = false
var est_interactif = true # <-- RENOMME ICI (et mets true par défaut)

func _ready():
	input_event.connect(_on_input_event)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Utilise le nouveau nom ici aussi
		if est_interactif: 
			a_ete_clique.emit(self)

# Fonction pour déplacer le gobelet proprement (Animation)
func deplacer_vers(nouvelle_position, duree):
	var tween = create_tween()
	# Trans/Ease controlent la fluidité (Sine = doux au début et à la fin)
	tween.set_trans(Tween.TRANS_SINE) 
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", nouvelle_position, duree)
	await tween.finished

# Animation pour soulever le gobelet
func soulever():
	var tween = create_tween()
	tween.tween_property($Sprite2D, "position:y", -100.0, 0.3) # Monte
	await tween.finished
	
func baisser():
	var tween = create_tween()
	tween.tween_property($Sprite2D, "position:y", 0.0, 0.3) # Descend
