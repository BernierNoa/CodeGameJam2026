extends Node

# État de progression
var batiments_repares = {
	"ballon": false,
	"gobelet": false,
	"jonglage": false,
	"course": false
}

# Position pour le retour sur la map
var position_joueur_sauvegardee : Vector2 = Vector2.ZERO

# Signaux globaux
signal interact_ballon
signal interact_clicker
signal interact_goblet
signal interact_junggle
signal interact_boss

signal interact_cookies

signal interact_ballon_victoire
signal interact_clicker_victoire
signal interact_goblet_victoire
signal interact_junggle_victoire
signal interact_boss_victoire
