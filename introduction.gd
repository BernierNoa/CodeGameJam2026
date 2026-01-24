extends Control

# --- PARAMÈTRES ---
const TEXT_SPEED = 0.05 
const READ_TIME = 2.5 
const TAILLE_TEXTE = 40 

const MAP_SCENE = "res://map.tscn"

# --- IMPORTATION DES SONS ---
# C'est ici que la magie opère ! Cela va créer une liste dans l'Inspecteur.
@export var liste_voix: Array[AudioStream]

# --- LIENS ---
@onready var dialog_text = $DialogBox/DialogTest
@onready var mayor_sprite = $MoyerSprit
@onready var audio_player = $AudioStreamPlayer # On a besoin du lecteur !

var dialogues: Array = [
	"Dans le village Pointeur-Les-Bains, une grande fête appelée « Click & Party » se tient depuis des siècles.",
	"Chaque enfant attend avec impatience le moment où le soleil disparaît pour laisser place à la lune...",
	"...car c’est à cet instant que les lanternes s'illuminent pour lancer les réjouissances.",
	"Mais ce soir, alors que les festivités de Click & Parti battent leur plein, un grondement sourd descend des cimes.",
	"Le Minotaure, caché dans les montagnes depuis des années, surgit brusquement !",
	"Dans un excès de rage, il piétine les décors et réduit les stands en miettes...",
	"...avant de disparaître dans l'obscurité de la nuit.",
	"Alors que tout le monde est sous le choc devant les ruines, une jeune fille nommée Clem s'avance.",
	"Elle a grandi dans ce village et n'a jamais manqué une seule édition de la fête.",
	"Grâce à ses années d'observation et d’expérience, elle sait comment tout reconstruire.",
	"Ton but : Incarne Clem et puise dans tes souvenirs pour reconstruire ce que le Minotaure a détruit.",
	"Sans ton aide, l’esprit de la fête du village s'éteindra à jamais.",
	"Bon Courage !"
]

var current_line_index: int = 0
var is_typing: bool = false
var is_waiting: bool = false 
var current_tween: Tween 

func _ready():
	# Vérification de sécurité
	if liste_voix.size() < dialogues.size():
		print("ATTENTION : Il manque des fichiers sons ! Tu as " + str(dialogues.size()) + " phrases mais seulement " + str(liste_voix.size()) + " sons.")
		
	# Réglage taille texte
	if dialog_text is Label:
		if dialog_text.label_settings == null:
			dialog_text.label_settings = LabelSettings.new()
		dialog_text.label_settings.font_size = TAILLE_TEXTE
	elif dialog_text is RichTextLabel:
		dialog_text.add_theme_font_size_override("normal_font_size", TAILLE_TEXTE)
	
	dialog_text.text = ""
	display_next_line()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		action_joueur()
	elif event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			action_joueur()

func action_joueur():
	if is_typing:
		# SKIP : On affiche tout et on COUPE le son
		if current_tween: current_tween.kill()
		dialog_text.visible_ratio = 1.0
		if audio_player.playing: audio_player.stop() # <-- Stop la voix si on passe
		on_tween_finished()
		
	elif is_waiting:
		# NEXT
		is_waiting = false 
		current_line_index += 1
		display_next_line()

func display_next_line():
	if current_line_index >= dialogues.size():
		dialog_text.text = "Bon courage" 
		get_tree().change_scene_to_file(MAP_SCENE)
		return
		
	if dialogues[current_line_index]:
		dialog_text.text = dialogues[current_line_index]
		dialog_text.visible_ratio = 0.0
		is_typing = true
		is_waiting = false

	
	# --- GESTION DE LA VOIX ---
	# 1. On vérifie s'il y a un son prévu pour cette phrase
	if current_line_index < liste_voix.size():
		var son_a_jouer = liste_voix[current_line_index]
		# 2. Si le son existe, on le charge dans le lecteur et on joue
		if son_a_jouer != null:
			audio_player.stream = son_a_jouer
			audio_player.play()
	
	current_tween = create_tween()
	# Calcul de durée : On prend soit la durée du son, soit la vitesse de lecture
	var duration = dialogues[current_line_index].length() * TEXT_SPEED
	current_tween.tween_property(dialog_text, "visible_ratio", 1.0, duration)
	current_tween.finished.connect(on_tween_finished)

func on_tween_finished():
	is_typing = false
	is_waiting = true
	
	var index_start = current_line_index
	await get_tree().create_timer(READ_TIME).timeout
	
	if is_waiting and current_line_index == index_start:
		current_line_index += 1
		display_next_line()
