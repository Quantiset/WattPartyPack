extends Control

@onready var rocket_button = $CenterContainer/HBoxContainer/VBoxContainer/Button
@onready var tron_button = $CenterContainer/HBoxContainer/VBoxContainer/Button2

@onready var buttons := [rocket_button, tron_button]

var file_name := "null"

func _ready():
	pass

func refresh_buttons():
	return
	for button in buttons:
		button.modulate.a = 1

func _on_2d_rocket_league_button_pressed():
	refresh_buttons()
	file_name = "res://Scenes/Pong.tscn"

func _on_tron_pressed():
	refresh_buttons()
	file_name = "res://Scenes/Tron.tscn"

func _on_play_button_pressed():
	for i in range(int($CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/Line2D.text)):
		Websocket.queued_scenes.append("res://Scenes/Pong.tscn")
	for i in range(int($CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Line2D.text)):
		Websocket.queued_scenes.append("res://Scenes/Tron.tscn")
	for i in range(int($CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Line2D.text)):
		Websocket.queued_scenes.append("res://Scenes/Asteroids.tscn")
	Websocket.next_scene()

