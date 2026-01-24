extends Control

const MINOTAURE_SCENE = "res://CourseMinotaure.tscn"
const SANDBOX_SCENE = "res://sandbox.tscn"


# Cette fonction est appelée quand la scène est chargée (comme un constructor/init)
func _ready():
	# Optionnel : On donne le focus au bouton jouer pour pouvoir jouer au clavier direct
	$UI_Container/PlayButton.grab_focus()

# Cette fonction sera connectée au bouton JOUER
func _on_play_button_pressed():
	# Change la scène actuelle vers la scène de jeu
	# Assure-toi d'avoir sauvegardé ta scène de jeu avant (ex: "CourseMinotaure.tscn")
	get_tree().change_scene_to_file(MINOTAURE_SCENE)

# Cette fonction sera connectée au bouton QUITTER
func _on_quit_button_pressed():
	get_tree().change_scene_to_file(SANDBOX_SCENE)
