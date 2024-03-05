extends Node

var LOADING_TIME := 0.9

var queued_scenes := []

func next_scene():
	if queued_scenes.size() == 0:
		get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
	else:
		var path = queued_scenes.pop_at(0)
		get_tree().change_scene_to_file(path)
