extends Node

# État de progression des bâtiments réparés
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

# ========================================
# MÉTHODES DE SAUVEGARDE/CHARGEMENT
# ========================================

## Sauvegarde la position actuelle du joueur
func sauvegarder_position_joueur(position: Vector2) -> void:
	position_joueur_sauvegardee = position
	print("[SignalManager] Position joueur sauvegardée: ", position)

## Récupère la position sauvegardée du joueur
func charger_position_joueur() -> Vector2:
	print("[SignalManager] Position joueur chargée: ", position_joueur_sauvegardee)
	return position_joueur_sauvegardee

## Marque un bâtiment comme réparé
func marquer_batiment_repare(nom_batiment: String) -> void:
	if batiments_repares.has(nom_batiment):
		batiments_repares[nom_batiment] = true
		print("[SignalManager] Bâtiment réparé: ", nom_batiment, " = true")
	else:
		print("[SignalManager] ERREUR: Bâtiment inconnu: ", nom_batiment)

## Vérifie si un bâtiment est réparé
func est_batiment_repare(nom_batiment: String) -> bool:
	if batiments_repares.has(nom_batiment):
		return batiments_repares[nom_batiment]
	return false

## Récupère l'état complet des bâtiments
func charger_etat_batiments() -> Dictionary:
	print("[SignalManager] État des bâtiments chargé: ", batiments_repares)
	return batiments_repares.duplicate()

## Réinitialise tous les états (pour un nouveau jeu)
func reinitialiser_etat() -> void:
	batiments_repares = {
		"ballon": false,
		"gobelet": false,
		"jonglage": false,
		"course": false
	}
	position_joueur_sauvegardee = Vector2.ZERO
	print("[SignalManager] État réinitialisé")
