extends Node2D

const SANDBOX_SCENE = "res://sandbox.tscn"
const GAME_SCENE = "res://gobelet_game.tscn"

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file(SANDBOX_SCENE)


func _on_rejouer_button_pressed() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)
