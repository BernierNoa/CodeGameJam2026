extends Control

const SCENE_SANDBOX = "res://sandbox.tscn"
const MAIN_SCENE = "res://map.tscn"
const redHearth = preload("res://popTheBallon/images/coeur.png")
const grayHearth = preload("res://popTheBallon/images/coeur_gris.png")

var score = 0
var lifes = 2
var offset = 0.9
var max_Time = 2
var min_Time = 0.6
var stepPerClick = 0.015
var countDown = 3
var pressed = false
var game = true
var signalEmitted = false
var mode = "basic"

@onready var target = $Target
@onready var UI = get_parent()
@onready var label = UI.get_node("ScoreLabel")
@onready var infoLabel = UI.get_node("InfoLabel")
@onready var gameArea = UI.get_node("GameArea")
@onready var LifeContainer = UI.get_node("LifeContainer")
@onready var Life1 = LifeContainer.get_node("Life1")
@onready var Life2 = LifeContainer.get_node("Life2")

@onready var BallonPopSound = UI.get_node("BallonPop")
@onready var BallonFailSound = UI.get_node("BallonFail")
@onready var StartSound = UI.get_node("StartSound")
@onready var LooseSound = UI.get_node("LooseSound")

func loseLife() -> void:
	lifes -= 1
	
	BallonFailSound.play()
	
	if lifes == 1:
		Life2.texture = grayHearth
	elif lifes == 0:
		Life1.texture = grayHearth
	elif lifes <= -1:
		print("End Of Game")
		loose()
		

func generatePosition() -> Vector2:
	#Permet de generer la position du ballon
	var Parentsize = $Target.get_parent_area_size()
	var Size = $Target.size
	
	var posMax = (Parentsize[0] * offset - Size[0] / 2)
	var posMin = (Parentsize[0] - Parentsize[0] * 0.9 + Size[0] / 2)
	
	var rng = RandomNumberGenerator.new()
	var posX = rng.randf_range(posMin, posMax)
	var posY = rng.randf_range(posMin, posMax)
	print(round(posX), round(posY))
	
	return Vector2(posX, posY)
	
func generateSize() -> Vector2:
	var rng = RandomNumberGenerator.new()
	var posX = rng.randf_range(40, 80)
	
	return Vector2(posX, posX)

func getCooldown() -> float:
	var time = max_Time - stepPerClick * score
	if time < min_Time:
		time = min_Time
	
	return time
	
func showUI() -> void:
	Life1.texture = redHearth
	Life2.texture = redHearth
	LifeContainer.visible = true
	gameArea.visible = true
	
func hideUI() -> void :
	LifeContainer.visible = false
	gameArea.visible = false
		
func loose() -> void:
	hideUI()

	game = false
	infoLabel.text = "You loose !"
	infoLabel.visible = true	
	LooseSound.play()
	await get_tree().create_timer(3).timeout
	infoLabel.visible = false
	UI.visible = false

	get_tree().change_scene_to_file(SCENE_SANDBOX)

func gameLoop():
	showUI()

	while game:
		
		if score >= 10 and mode == "basic":
			signal_manager.batiments_repares["ballon"] = true
			signal_manager.interact_ballon_victoire.emit()
			print("Ended")
			get_tree().change_scene_to_file(MAIN_SCENE)
			return
			
		
		var goalPosition = generatePosition()
		var goalSize = generateSize()
		
		pressed = false
	
		target.position = goalPosition
		target.size = goalSize
		
		target.disabled = false
		target.visible = true
		
		await get_tree().create_timer(getCooldown()).timeout
		
		if not pressed:
			loseLife()

func startCooldown() -> void:
	infoLabel.text = str(countDown)
	for i in range(1, countDown + 1):
		await get_tree().create_timer(1).timeout
		infoLabel.text = str(countDown - i)
		
	infoLabel.text = "Start !"
	await get_tree().create_timer(2).timeout
	infoLabel.visible = false
	
	gameLoop()
	
func init():
	mode = "basic"
	hideUI()
	
	StartSound.play()
	startCooldown()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init()
	signal_manager.interact_ballon.connect(on_ballon_victoire)
	
func on_ballon_victoire():
	print("Emitted")
	mode = "basic"
	init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game:
		label.text = str(score)

func _on_target_pressed() -> void:
	score += 1
	
	BallonPopSound.play()
	
	target.disabled = true
	target.visible = false
	pressed = true
