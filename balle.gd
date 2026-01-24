extends RigidBody2D

func _ready():
	# Connexion automatique du signal de clic interne au RigidBody
	input_event.connect(_on_input_event)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		jongler()

func jongler():
	# 1. On annule la vitesse actuelle (pour qu'elle ne "lutte" pas contre la chute)
	linear_velocity = Vector2.ZERO
	angular_velocity = randf_range(-5, 5) # Petit effet de rotation stylé
	
	# 2. On applique une impulsion (Un coup de pied !)
	# X : Un peu aléatoire vers la gauche ou droite (-100 à 100)
	# Y : Fort vers le haut (-600)
	var force = Vector2(randf_range(-150, 150), -500)
	apply_impulse(force)
