extends Area2D

var vitesse = 0.0 

func _process(delta):
	position.x += vitesse * delta
