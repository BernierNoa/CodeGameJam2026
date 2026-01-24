extends Sprite2D

# Script pour gérer l'interaction avec la grotte du minotaure (mini-jeu de course)

func _ready():
	# Connexion au signal de victoire pour mettre à jour l'état visuel
	signal_manager.interact_boss_victoire.connect(on_boss_victoire)
	
	# Charger l'état initial depuis le singleton
	update_visual_state()

func update_visual_state():
	# Frame 0 = détruit/non réparé, Frame 1 = réparé
	# Si le sprite n'a qu'une frame, cette ligne ne causera pas d'erreur
	if signal_manager.batiments_repares["course"]:
		if hframes > 1:
			frame = 1  # Bâtiment réparé
	else:
		frame = 0  # Bâtiment non réparé

func on_boss_victoire():
	# Quand le joueur gagne le mini-jeu, mettre à jour l'affichage
	update_visual_state()
