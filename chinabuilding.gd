extends Sprite2D

func _ready():
	# Connexion au signal global
	signal_manager.interact_junggle_victoire.connect(on_junggle_victoire)
	
	# On change la frame de l'objet lui-même (self)
	frame = 0 

func on_junggle_victoire():
	# Quand on gagne, on change l'image
	frame = 1
	print("[Chinabuilding] Bâtiment réparé, frame changée à 1")
