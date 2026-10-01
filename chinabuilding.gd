extends Sprite2D

# Constantes pour les frames
const FRAME_DESTROYED = 0
const FRAME_REPAIRED = 1

func _ready():
	# Connexion au signal global
	signal_manager.interact_junggle_victoire.connect(on_junggle_victoire)
	
	# On change la frame de l'objet lui-même (self)
	frame = FRAME_DESTROYED

func on_junggle_victoire():
	# Quand on gagne, on change l'image
	frame = FRAME_REPAIRED
	print("[Chinabuilding] Bâtiment réparé, frame changée à ", FRAME_REPAIRED)
