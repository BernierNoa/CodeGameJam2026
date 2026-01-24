extends Control

# On utilise les noms EXACTS de tes fichiers (image_cbf711.png)
#const SCENE_JEU = "res://scenes/jeu.tscn"
const SCENE_SANDBOX = "res://sandbox.tscn" 
const SCENE_CREDITS = "res://credit.tscn" 
const SCENE_INTRODUCTION = "res://introduction.tscn" 
const SCENE_PARAMETRE = "res://parametre.tscn"
const POPTHEBALLON_SCENE = "res://PopTheBallon.tscn"

@onready var container = $container
@onready var boutonJouer = container.get_node("boutonJouer")
@onready var boutonSandbox = container.get_node("boutonSandbox")
@onready var boutonCredit = container.get_node("boutonCredit")
@onready var boutonParametre = get_node("Parametre")


func _on_bouton_jouer_pressed():
	$sonmenu.play()
	get_tree().change_scene_to_file(SCENE_INTRODUCTION)
	
func _on_bouton_sandbox_pressed():
	$sonmenu.play()
	get_tree().change_scene_to_file(SCENE_SANDBOX)

func _on_bouton_credit_pressed():
	$sonmenu.play()
	get_tree().change_scene_to_file(SCENE_CREDITS)
	
func _on_bouton_parametre_pressed():
	$sonmenu.play()
	get_tree().change_scene_to_file(SCENE_PARAMETRE)

func _ready():
	if has_node("musiqueMenu"):
		$musiqueMenu.play()
	boutonJouer.pressed.connect(_on_bouton_jouer_pressed)
	boutonSandbox.pressed.connect(_on_bouton_sandbox_pressed)
	boutonCredit.pressed.connect(_on_bouton_credit_pressed)
