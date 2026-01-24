extends Control

func _ready():
	$musiqueMenu.play()
	
	if not $boutonRetour.pressed.is_connected(_on_bouton_retour_pressed):
		$boutonRetour.pressed.connect(_on_bouton_retour_pressed)

func _on_bouton_retour_pressed():
	get_tree().change_scene_to_file("res://accueil.tscn")
