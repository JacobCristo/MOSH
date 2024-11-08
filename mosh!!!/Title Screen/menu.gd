extends Control

var level = "res://Scenes/world.tscn"

func _on_play_click_end() -> void:
	var _level = get_tree().change_scene_to_file(level)

func _on_quit_click_end() -> void:
	get_tree().quit()
