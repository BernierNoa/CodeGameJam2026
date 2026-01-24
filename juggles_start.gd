extends Node2D

const SANDBOX_SCENE = "res://sandbox.tscn"
const JUGGLES_SCENE = "res://juggles.tscn"

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file(SANDBOX_SCENE)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(JUGGLES_SCENE)
