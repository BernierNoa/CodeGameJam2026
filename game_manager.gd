extends Node2D

# On récupère les références vers les objets
@onready var joueur = $Joueur
@onready var minotaure = $Minotaure
@onready var camera = $Joueur/Camera2D
@onready var label_affichage = $HUD/UI_Container/Label
@onready var label_distance = $HUD/UI_Container/Affichage
@onready var barre_progression = $HUD/UI_Container/ProgressBar
@onready var filtre_rouge = $HUD/FiltreRouge
@onready var playbutton = $HUD/UI_Container/PlayButton
@onready var quitbutton = $HUD/UI_Container/QuitButton
@onready var spriteminotaure = $Minotaure/AnimatedSprite2D
@onready var music_player = $AudioStreamPlayer
@onready var minotaureMort = $Minotaure/MinotaureMort
var musique_normal = preload("res://sounds/cours minautor.mp3")
var musique_hard = preload("res://sounds/cours minautor saturé.mp3")
var musique_mort = preload("res://sounds/LooseGame.mp3")
# Assure-toi d'avoir un Label dans ton HUD pour afficher ça
# Configuration des phases (vitesses du Minotaure)
var vitesse_phase_1 = 300.0 # Lent
var vitesse_phase_2 = 400.0 # Rapide
var vitesse_phase_3 = 550.0 # Très rapide
var vitesse_phase_4 = 500.0 # Sprint final

# Pour savoir dans quelle phase on est
var phase_actuelle = 0
# Si tu n'as pas de Label, supprime la ligne ui_distance ci-dessous pour tester

func _ready():
	# 1. Masquer les boutons de fin de partie au lancement
	playbutton.visible = false
	quitbutton.visible = false
	label_affichage.visible = true
	
	# 2. FIGER LE JEU (Pause technique)
	# On désactive les _process du joueur, du minotaure et du game_manager
	joueur.set_process(false)
	minotaure.set_process(false)
	set_process(false) 
	
	# 3. Lancer la musique et le chrono
	lancer_compte_a_rebours()

func lancer_compte_a_rebours():
	# Étape 3
	label_affichage.text = "3"
	await get_tree().create_timer(1.0).timeout
	
	# Étape 2
	label_affichage.text = "2"
	await get_tree().create_timer(1.0).timeout
	
	# Étape 1
	label_affichage.text = "1"
	await get_tree().create_timer(1.0).timeout
	
	# GO !
	label_affichage.text = "PARTEZ !!!"
	
	# 4. LIBÉRER TOUT LE MONDE
	joueur.set_process(true)
	minotaure.set_process(true)
	set_process(true) # On réactive la boucle principale du jeu
	
	# On laisse le texte affiché 1 seconde de plus puis on le cache
	await get_tree().create_timer(1.0).timeout
	label_affichage.visible = false

func _process(delta):
	
	var distance = joueur.position.x / 10.0
	
	# --- GESTION DES PHASES ---
	
	# Phase 1 : Départ (0 - 100m)
	if distance < 100:
		changer_phase(1, vitesse_phase_1)
		
	# Phase 2 : Ligne Droite (100 - 300m)
	elif distance < 300:
		changer_phase(2, vitesse_phase_2)
		# Ici on pourrait faire spawner des cibles aléatoirement
		
	# Phase 3 : Virage Serré (300 - 450m)
	elif distance < 450:
		changer_musique(musique_normal)
		music_player.pitch_scale = 1.5 # Très rapide (effet Nightcore)
		music_player.volume_db = 2.0
		spriteminotaure.speed_scale = 8.0
		changer_phase(3, vitesse_phase_3)
		filtre_rouge.visible = true
		faire_trembler_camera() # Effet visuel
		
	# Phase 4 : Sprint Final (450 - 500m)
	elif distance < 500:
		changer_musique(musique_hard)
		filtre_rouge.visible = false
		changer_phase(4, vitesse_phase_4)
	
	# Calculer la distance (10 pixels = 1 mètre)
	var distance_metres = int(joueur.position.x / 10)
	var distance_minotaure = int(minotaure.position.x / 10.0) + 35
	var dist_player = joueur.position.x / 10.0 # Conversion en mètres
	
	# 2. Mettre à jour le texte (Fixe à l'écran)
	label_distance.text = "Distance : %d m" % dist_player
	var style_remplissage = barre_progression.get_theme_stylebox("fill")
	if distance_metres < 150:
		style_remplissage.bg_color = Color(0.969, 0.0, 0.0, 1.0)
	elif distance_metres > 150 && distance_metres < 300:
		style_remplissage.bg_color = Color("d85f00")
	else:
		style_remplissage.bg_color = Color("00ff00b3")
	barre_progression.value = dist_player * 100 / 500
	
	print(distance_minotaure)
	
	if distance_minotaure >= 500 and distance_metres < 500:
		label_affichage.text = "Le Minotaure a gagné... La fête est fichue !"
		label_affichage.visible = true
		# Affiche aussi les boutons pour recommencer
		playbutton.visible = true
		quitbutton.visible = true
		changer_musique(musique_mort)
		set_process(false)
		await get_tree().create_timer(0.7).timeout
		music_player.stop()
	
	# Vérifier la fin de course
	if distance_metres >= 500:
		joueur.position.x = 5000 
		joueur.vitesse_actuelle = 0 
		joueur.set_process(false)
		set_process(false)
		changer_phase(1,0)
		spriteminotaure.visible = false
		minotaureMort.visible = true
		minotaureMort.play()
		await get_tree().create_timer(3.0).timeout
		label_affichage.text = "Victoire ! La fête est sauvé !"
		label_affichage.visible = true
		playbutton.visible = true
		quitbutton.visible = true # Arrête le jeu
		emit_signal("boss_victoire")

func changer_phase(nouvelle_phase, vitesse_minotaure):
	if phase_actuelle == nouvelle_phase:
		return # On ne fait rien si on est déjà dans cette phase
		
	phase_actuelle = nouvelle_phase
	minotaure.vitesse = vitesse_minotaure
	print("Début de la Phase : ", phase_actuelle)

func faire_trembler_camera():
	# Petit tremblement aléatoire sur la caméra
	
	camera.offset = Vector2(randf_range(-2, 2), randf_range(-2, 2))


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://CourseMinotaure.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func changer_musique(nouvelle_musique):
	# Si c'est déjà la bonne musique, on ne fait rien
	if music_player.stream == nouvelle_musique:
		return

	# Sinon, on change
	music_player.stream = nouvelle_musique
	music_player.play()
