extends Node2D

## Script de la carte principale (map.tscn)
## Gère la restauration de l'état du jeu (position joueur, bâtiments réparés)

@onready var music: AudioStreamPlayer2D = $map_music
@onready var joueur = $Entité/Joueur
@onready var chapiteau = $Stand/chapiteau  # Bâtiment du ballon
@onready var saloon = $Stand/saloon        # Bâtiment du gobelet
@onready var chinabuilding = $Stand/chinabuilding  # Bâtiment du jonglage

func _ready() -> void:
	print("[Map] Initialisation de la carte")
	
	# Démarrer la musique si elle n'est pas en cours
	if music != null and not music.playing:
		music.play()
	
	# Restaurer la position du joueur
	restaurer_position_joueur()
	
	# Restaurer l'état des bâtiments
	restaurer_etat_batiments()

## Restaure la position du joueur depuis le Singleton
func restaurer_position_joueur() -> void:
	if joueur == null:
		print("[Map] ERREUR: Joueur non trouvé!")
		return
	
	var position_sauvegardee = signal_manager.charger_position_joueur()
	
	# Si la position sauvegardée n'est pas (0, 0), on la restaure
	if position_sauvegardee != Vector2.ZERO:
		joueur.global_position = position_sauvegardee
		print("[Map] Position du joueur restaurée à: ", position_sauvegardee)
	else:
		print("[Map] Aucune position sauvegardée, utilisation de la position par défaut")

## Restaure l'état visuel des bâtiments depuis le Singleton
func restaurer_etat_batiments() -> void:
	var etat_batiments = signal_manager.charger_etat_batiments()
	
	# Restaurer le chapiteau (ballon)
	if chapiteau != null and etat_batiments.get("ballon", false):
		if chapiteau.has_method("on_ballon_victoire"):
			chapiteau.on_ballon_victoire()
		else:
			# Fallback: changer la frame directement
			chapiteau.frame = 1
		print("[Map] Chapiteau restauré à l'état réparé")
	
	# Restaurer le saloon (gobelet)
	if saloon != null and etat_batiments.get("gobelet", false):
		if saloon.has_method("on_goblet_victoire"):
			saloon.on_goblet_victoire()
		else:
			# Fallback: changer la frame directement
			saloon.frame = 1
		print("[Map] Saloon restauré à l'état réparé")
	
	# Restaurer le chinabuilding (jonglage)
	if chinabuilding != null and etat_batiments.get("jonglage", false):
		# Le chinabuilding n'a pas de script actuellement, on change juste la frame
		chinabuilding.frame = 1
		print("[Map] Chinabuilding restauré à l'état réparé")
	
	# Note: Le bâtiment "course" (minotaure) n'a pas de représentation visuelle sur la map
	if etat_batiments.get("course", false):
		print("[Map] Course du Minotaure déjà complétée")
