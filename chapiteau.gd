extends Sprite2D

# Script pour gérer l'interaction avec le chapiteau (mini-jeu de jonglage)

func _ready():
	# Connexion au signal de victoire pour mettre à jour l'état visuel
	signal_manager.interact_junggle_victoire.connect(on_jonglage_victoire)
	
	# Charger l'état initial depuis le singleton
	update_visual_state()

func update_visual_state():
	# Frame 0 = détruit, Frame 1 = en cours de réparation, Frame 2 = réparé
	if signal_manager.batiments_repares["jonglage"]:
		frame = 2  # Bâtiment réparé
	else:
		frame = 0  # Bâtiment détruit

func on_jonglage_victoire():
	# Quand le joueur gagne le mini-jeu, mettre à jour l'affichage
	update_visual_state()
