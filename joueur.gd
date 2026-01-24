extends CharacterBody2D

# Paramètres de course
var vitesse_actuelle = 0.0
var vitesse_max = 500.0
var acceleration = 80.0 # La force d'un clic
var friction = 80.0      # Le ralentissement naturel
var est_etourdi = false 

func _process(delta):
	
	if est_etourdi:
		return
	
	# 1. Détecter le clic (Bourrinage)
	if Input.is_action_just_pressed("ui_right"):
		vitesse_actuelle += acceleration
	
	# 2. Appliquer la friction (Fatigue)
	# On réduit la vitesse petit à petit, sans passer sous 0
	if vitesse_actuelle > 0:
		vitesse_actuelle -= friction * delta * 5
	else:
		vitesse_actuelle = 0
	
	# 3. Limiter la vitesse max
	vitesse_actuelle = min(vitesse_actuelle, vitesse_max)
	
	# 4. Faire avancer le joueur (X = horizontal)
	position.x += vitesse_actuelle * delta


func etourdir():
	est_etourdi = true
	vitesse_actuelle = 0 # On s'arrête net
	modulate = Color(1, 0, 0) # On devient rouge (feedback visuel)
	
	# On attend 0.5 seconde
	await get_tree().create_timer(0.5).timeout
	
	est_etourdi = false
	modulate = Color(1, 1, 1) # On redevient normal
