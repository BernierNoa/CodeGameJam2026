extends Control

# Définition du chemin vers la scène du jeu ballon
const POPTHEBALLON_SCENE = "res://PopTheBallon.tscn"
const ACCEUIL_SCENE = "res://accueil.tscn"
const MINOTAURE_SCENE = "res://main_menu.tscn"
const GOBELET_SCENE = "res://gobelet_debut.tscn"
const JUGGLES_SCENE = "res://juggles_start.tscn"


@onready var container = $GridContainer

func _ready():
	if has_node("sonmenu"):
		$sonmenu.play()
		
func _on_bouton_retour_pressed():
	if has_node("sonmenu"):
		$sonmenu.play()
		await $sonmenu.finished
	get_tree().change_scene_to_file(ACCEUIL_SCENE)

func _on_jeu_minotaure_pressed():
	if has_node("sonmenu"):
		$sonmenu.play()

	get_tree().change_scene_to_file(MINOTAURE_SCENE)
	
func _on_jeu_ballon_pressed():
	if has_node("sonmenu"):
		$sonmenu.play()

	get_tree().change_scene_to_file(POPTHEBALLON_SCENE)
	
