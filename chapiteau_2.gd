extends Sprite2D

func _ready():
	# Connexion au signal global
	signal_manager.interact_ballon_victoire.connect(on_ballon_victoire)
	
	# On change la frame de l'objet lui-même (self)
	frame = 0 

func on_ballon_victoire():
	# Quand on gagne, on change l'image
	frame = 1

	
