extends Node2D

# 1. On charge ta scène de balle
var scene_balle = preload("res://Balle.tscn")
@onready var interface = $Interface
@onready var timer_spawner = $TimerSpawner
@onready var titre = $Titre
@onready var soustitre = $SousTitre
@onready var quitbutton = $QuitButton
@onready var playbutton = $PlayButton

var vies = 3
var temps_ecoule = 0
var temps_precis = 0.0 # Variable pour compter les micro-secondes
var jeu_en_cours = true # Pour arrêter le chrono quand on perd

# Position de départ
var spawn_pos = Vector2(250, -200) 

func _ready():
	# On cache le menu de fin au début
	titre.visible = false
	soustitre.visible = false
	quitbutton.visible = false
	playbutton.visible = false
	
	update_ui()
	spawner_balle()

# --- NOUVEAU : Fonction qui tourne 60 fois par seconde ---
func _process(delta):
	if jeu_en_cours:
		# On ajoute le petit temps passé depuis la dernière image
		temps_precis += delta 
		
		# On convertit en nombre entier (1.002 -> 1)
		var nouveau_temps = int(temps_precis)
		
		# Si on a changé de seconde, on met à jour l'affichage
		if nouveau_temps > temps_ecoule:
			temps_ecoule = nouveau_temps
			update_ui()
# ---------------------------------------------------------

func _on_timer_spawner_timeout():
	# J'ai ENLEVÉ la ligne "temps_ecoule += 5" ici car c'est _process qui gère maintenant
	spawner_balle()
	
	# Accélération du spawn
	if timer_spawner.wait_time > 1.0:
		timer_spawner.wait_time -= 0.1
		# print("Ça s'accélère !")

func _on_zone_mort_body_entered(body):
	if body is RigidBody2D:
		body.queue_free() 
		perdre_vie()
		call_deferred("verifier_balles_restantes")
		
func verifier_balles_restantes():
	if vies <= 0:
		return

	var nb_balles = 0
	for enfant in get_children():
		if enfant is RigidBody2D and not enfant.is_queued_for_deletion():
			nb_balles += 1
	
	if nb_balles == 0:
		spawner_balle()
		timer_spawner.start()		
		
func perdre_vie():
	vies -= 1
	update_ui()
	
	if vies <= 0:
		game_over()
		
func update_ui():
	interface.text = "VIES : " + str(vies) + "\nTEMPS : " + str(temps_ecoule) + "s"

func game_over():
	jeu_en_cours = false # On arrête le chrono !
	interface.text = "" # On vide l'interface du jeu pour laisser place au menu
	timer_spawner.stop() 
	
	for enfant in get_children():
		if enfant is RigidBody2D:
			enfant.queue_free()
			
	titre.visible = true
	soustitre.visible = true
	if(temps_ecoule >= 30):
		soustitre.text = "Temps tenu : " + str(temps_ecoule) + " secondes\n Le batiment est réparé !"
		# Marquer le jonglage comme réparé et émettre le signal
		signal_manager.batiments_repares["jonglage"] = true
		signal_manager.interact_junggle_victoire.emit()
		# Retourner à la map après 2 secondes
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://map.tscn")
		return

	else:
		soustitre.text = "Temps tenu : " + str(temps_ecoule) + " secondes"
	quitbutton.visible = true
	playbutton.visible = true

func spawner_balle():
	var nouvelle_balle = scene_balle.instantiate()
	nouvelle_balle.position = spawn_pos
	nouvelle_balle.position.x += randf_range(-200, 200)
	# La difficulté augmente doucement avec le temps
	nouvelle_balle.gravity_scale = 0.5 + (temps_ecoule / 60.0)
	add_child(nouvelle_balle)

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://map.tscn")

func _on_play_button_pressed() -> void:
	# CORRECTION IMPORTANTE : reload() n'existe pas, il faut reload_current_scene()
	get_tree().reload_current_scene()
