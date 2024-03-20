extends Node

enum PICKUPS {
	SpeedUp,
	BouncingBullets,
	DoubleShot
}
var PICKUP_INFORMATION = {
	PICKUPS.SpeedUp: {
		"texture": preload("res://Assets/HealthIcon.png"),
	},
	PICKUPS.BouncingBullets: {
		"texture": preload("res://Assets/RubberTippedBullets.png"),
	},
	PICKUPS.DoubleShot: {
		"texture": preload("res://Assets/DoubledMuzzle.png")
	}
}

var LOADING_TIME := 0.9

const default_queue := [
	"res://Scenes/Asteroids.tscn", "res://Scenes/Pong.tscn", "res://Scenes/Tron.tscn", "res://Scenes/PaperMap.tscn"
]
var queued_scenes := []

func next_scene():
	if queued_scenes.size() == 0:
		get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
	else:
		var path = queued_scenes.pop_at(0)
		get_tree().change_scene_to_file(path)
