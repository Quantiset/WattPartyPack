extends Control

@onready var rocket_button = $CenterContainer/HBoxContainer/VBoxContainer/Button

@onready var buttons := [rocket_button]

var file_name := "null"

func refresh_buttons():
	for button in buttons:
		button.modulate.a = 1

func _on_2d_rocket_league_button_pressed():
	refresh_buttons()
	rocket_button.modulate.a = 1.2
	file_name = "res://Scenes/Pong.tscn"

func _on_play_button_pressed():
	if file_name != "null":
		get_tree().change_scene_to_file(file_name)
