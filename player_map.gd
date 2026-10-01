extends CharacterBody2D

enum Etat {
	idle,
	run,
	attack,
	dead	
}

const POPBALLON_SCENE = "res://PopTheBallon.tscn"
const GOBELET_SCENE = "res://gobelet_debut.tscn"
const JUGGLES_SCENE = "res://juggles_start.tscn"
const BOSS_SCENE = "res://main_menu.tscn"

@export_category("Statistique")
@export var vitesse: int = 400
@export var gravite: int = 1500

@export var X_MIN: int = -2350
@export var X_MAX: int = 4060

var etat: Etat = Etat.idle
var move_direction: Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

@onready var all_interaction = []
@onready var interactLabel = $"Interaction Components".get_node("InteractLabel")

func _ready() -> void:
	animation_tree.active = true
	
	# Connecter les signaux pour lancer les mini-jeux
	signal_manager.interact_clicker.connect(_on_interact_clicker)
	signal_manager.interact_goblet.connect(_on_interact_goblet)
	signal_manager.interact_junggle.connect(_on_interact_junggle)
	signal_manager.interact_boss.connect(_on_interact_boss)

func _physics_process(delta: float) -> void:
	#apply_gravity(delta)
	handle_movement()
	update_state()
	update_animation()
	move_and_slide()
	
	if Input.is_action_just_pressed("Interact"):
		execute_interaction()

# -----------------------------
# GRAVITÉ (non appliquée)
# -----------------------------
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravite * delta
	else:
		velocity.y = 0

# -----------------------------
# MOUVEMENT
# -----------------------------
func handle_movement() -> void:
	move_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))

	# Vérifie si le joueur peut bouger horizontalement
	if (global_position.x > X_MIN or move_direction.x > 0) and (global_position.x < X_MAX or move_direction.x < 0):
		velocity.x = move_direction.x * vitesse
	else:
		velocity.x = 0

	# Flip du sprite
	if move_direction.x < 0:
		sprite.flip_h = true
	elif move_direction.x > 0:
		sprite.flip_h = false

# -----------------------------
# ÉTATS
# -----------------------------
func update_state() -> void:
	if etat == Etat.dead:
		return

	if move_direction.x != 0:
		etat = Etat.run
	else:
		etat = Etat.idle

# -----------------------------
# ANIMATIONS
# -----------------------------
func update_animation() -> void:
	match etat:
		Etat.idle:
			if animation_playback.get_current_node() != "idle":
				animation_playback.travel("idle")
		Etat.run:
			if animation_playback.get_current_node() != "run":
				animation_playback.travel("run")

# -----------------------------
# INTERACTIONS
# -----------------------------
func _on_interation_area_area_entered(area: Area2D) -> void:
	all_interaction.insert(0, area)
	update_interactions()

func _on_interation_area_area_exited(area: Area2D) -> void:
	all_interaction.erase(area)
	update_interactions()

func update_interactions():
	if all_interaction:
		interactLabel.text = all_interaction[0].interact_label
	else:
		interactLabel.text = ""

# Sauvegarde la position avant de changer de scène
func sauvegarder_et_changer_scene(scene_path: String) -> void:
	signal_manager.sauvegarder_position_joueur(global_position)
	get_tree().change_scene_to_file(scene_path)

func StartBallon():
	print("[Player] Lancement du mini-jeu Ballon")
	sauvegarder_et_changer_scene(POPBALLON_SCENE)

func _on_interact_clicker():
	print("[Player] Signal interact_clicker reçu (non implémenté)")

func _on_interact_goblet():
	print("[Player] Lancement du mini-jeu Gobelet")
	sauvegarder_et_changer_scene(GOBELET_SCENE)

func _on_interact_junggle():
	print("[Player] Lancement du mini-jeu Jonglage")
	sauvegarder_et_changer_scene(JUGGLES_SCENE)

func _on_interact_boss():
	print("[Player] Lancement du mini-jeu Boss")
	sauvegarder_et_changer_scene(BOSS_SCENE)

func execute_interaction():
	if all_interaction:
		var cur_interaction = all_interaction[0]
		match cur_interaction.interact_type:
			"interact_ballon": StartBallon()
			"interact_clicker": signal_manager.interact_clicker.emit()
			"interact_junggle": signal_manager.interact_junggle.emit()
			"interact_goblet": signal_manager.interact_goblet.emit()
			"interact_cookies": signal_manager.interact_cookies.emit()
			"interact_boss": signal_manager.interact_boss.emit()
