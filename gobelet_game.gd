extends Node2D

# --- CONFIGURATION ---
var scene_gobelet = preload("res://gobelet_clicker.tscn") # Vérifie ton chemin !
@onready var balle = $Balle
@onready var label_info = $Label # Ton label de score
@onready var label_fin = $Fin
@onready var quitbutton = $QuitButton
@onready var rejouerbutton = $RejouerButton

# --- VARIABLES DE JEU ---
var score = 0
var vies = 2
var liste_gobelets = [] # Le tableau qui contient nos gobelets
var largeur_ecran = 1280 # À ajuster selon ton projet

# --- DIFFICULTÉ ---
var nb_gobelets = 3
var vitesse_melange = 0.5
var nb_echanges = 3

func _ready():
	# DEBUG : Si tu as oublié de mettre une image dans l'éditeur, le code va la mettre
	if balle.texture == null:
		print("⚠️ Attention : La balle n'avait pas d'image ! J'utilise l'icône par défaut.")
		balle.texture = preload("res://icon.svg") # Ou mets le chemin de ton image de balle
		balle.scale = Vector2(0.5, 0.5) # On la réduit un peu si c'est l'icone
	
	# CODE : On force la balle à être sur le calque 1
	balle.z_index = 1
	
	demarrer_manche()


func demarrer_manche():
	# 1. Mise à jour de la difficulté selon le score
	calculer_difficulte()
	update_ui()
	
	# 2. On installe les gobelets
	setup_gobelets()
	
	# 3. On cache la balle et on choisit un gagnant
	balle.visible = false
	var index_gagnant = randi() % liste_gobelets.size()
	var gobelet_gagnant = liste_gobelets[index_gagnant]
	gobelet_gagnant.a_la_balle = true
	
	# 4. ANIMATION DE DÉBUT
	balle.position = gobelet_gagnant.position + Vector2(0, 50)
	balle.visible = true
	
	await get_tree().create_timer(0.5).timeout
	
	# SÉCURITÉ 1 : Si le jeu a redémarré pendant la pause de 0.5s
	if not is_instance_valid(gobelet_gagnant):
		return

	await gobelet_gagnant.soulever()
	
	await get_tree().create_timer(0.8).timeout
	
	# SÉCURITÉ 2 : C'est ICI que ça plantait !
	# Si le gobelet a été supprimé pendant qu'il était en l'air
	if not is_instance_valid(gobelet_gagnant):
		return

	await gobelet_gagnant.baisser()
	
	balle.visible = false 
	
	# 5. C'est parti pour le mélange
	melanger()

func calculer_difficulte():
	if score >= 70:
		nb_gobelets = 5
		vitesse_melange = 0.25 # Très rapide
		nb_echanges = 12       # Long mélange
	elif score >= 50:
		nb_gobelets = 4
		vitesse_melange = 0.35
		nb_echanges = 8
	elif score >= 30:
		nb_gobelets = 3
		vitesse_melange = 0.30
		nb_echanges = 6
	elif score >= 10:
		nb_gobelets = 3
		vitesse_melange = 0.50
		nb_echanges = 4
	else:
		nb_gobelets = 3
		vitesse_melange = 0.6 # Lent
		nb_echanges = 3

func setup_gobelets():
	# On supprime les anciens gobelets
	for g in liste_gobelets:
		g.queue_free()
	liste_gobelets.clear()
	
	# On calcule les positions pour que ce soit centré
	var espace = 300 # Espace entre les gobelets
	var start_x = (largeur_ecran / 2) - ((nb_gobelets - 1) * espace) / 2
	
	for i in range(nb_gobelets):
		var nouveau = scene_gobelet.instantiate()
		add_child(nouveau)
		nouveau.z_index = 10
		nouveau.position = Vector2(start_x + (i * espace), 500) # 400 = Hauteur Y
		# On connecte le signal du clic
		nouveau.a_ete_clique.connect(_on_gobelet_selectionne)
		liste_gobelets.append(nouveau)

func melanger():
	# Désactiver les clics
	for g in liste_gobelets: g.est_interactif = false
	
	await get_tree().create_timer(0.5).timeout
	
	# BOUCLE DE MÉLANGE
	for i in range(nb_echanges):
		# Choisir 2 gobelets au hasard
		var idx1 = randi() % liste_gobelets.size()
		var idx2 = randi() % liste_gobelets.size()
		
		# S'assurer qu'on ne choisit pas le même
		while idx1 == idx2:
			idx2 = randi() % liste_gobelets.size()
			
		var gob1 = liste_gobelets[idx1]
		var gob2 = liste_gobelets[idx2]
		
		# On échange leurs positions physiques
		var pos1 = gob1.position
		var pos2 = gob2.position
		
		# On lance les mouvements en même temps
		gob1.deplacer_vers(pos2, vitesse_melange)
		await gob2.deplacer_vers(pos1, vitesse_melange)
		
		# IMPORTANT : On met à jour le tableau !
		liste_gobelets[idx1] = gob2
		liste_gobelets[idx2] = gob1
	
	# Fin du mélange
	for g in liste_gobelets: g.est_interactif = true
	label_info.text = "Où est la balle ?"

func _on_gobelet_selectionne(gobelet):
	# --- SÉCURITÉ ANTI-CRASH ---
	# Si le gobelet a été supprimé (par un Game Over juste avant), on arrête tout.
	if not is_instance_valid(gobelet):
		return
	# ---------------------------

	# On désactive tout pour pas recliquer
	for g in liste_gobelets: 
		# On vérifie aussi que les autres gobelets existent avant de toucher à leurs variables
		if is_instance_valid(g):
			g.est_interactif = false
	
	# On révèle
	await gobelet.soulever()
	
	# Sécurité supplémentaire : Si le gobelet a été supprimé PENDANT l'animation (ex: reset du jeu)
	if not is_instance_valid(gobelet):
		return
	
	if gobelet.a_la_balle:
		# GAGNÉ !
		balle.position = gobelet.position + Vector2(0, 50)
		balle.visible = true
		score += 10
		label_info.text = "BRAVO ! (+10)"
		
		if score >= 70: # J'ai remis >= par sécurité au lieu de ==
			label_fin.text = "BÂTIMENT RÉPARÉ !!!"
			label_fin.visible = true
			quitbutton.visible = true
			rejouerbutton.visible = true
			
			# Nettoyage sécurisé
			for g in liste_gobelets:
				if is_instance_valid(g): g.queue_free()
			liste_gobelets.clear()
			
			# Émission du signal de victoire
			signal_manager.interact_goblet_victoire.emit()
		else:
			await get_tree().create_timer(1.5).timeout
			demarrer_manche()
	else:
		# PERDU !
		vies -= 1
		label_info.text = "RATÉ... Vies : " + str(vies)
		
		if vies <= 0:
			label_fin.text = "PERDU... GAME OVER"
			label_fin.visible = true
			quitbutton.visible = true
			rejouerbutton.visible = true
			
			# Nettoyage sécurisé
			for g in liste_gobelets:
				if is_instance_valid(g): g.queue_free()
			liste_gobelets.clear()
		else:
			await get_tree().create_timer(1.5).timeout
			demarrer_manche()

func update_ui():
	label_info.text = "Score : %d | Vies : %d" % [score, vies]


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://gobelet_debut.tscn")


func _on_rejouer_button_pressed() -> void:
	get_tree().reload_current_scene()
