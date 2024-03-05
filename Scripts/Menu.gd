extends Control

@onready var rocket_button = $CenterContainer/HBoxContainer/VBoxContainer/Button
@onready var tron_button = $CenterContainer/HBoxContainer/VBoxContainer/Button2

@onready var buttons := [rocket_button, tron_button]

var file_name := ""

func _ready():
	pass

func refresh_buttons():
	for button in buttons:
		button.modulate.a = 1


func _on_play_button_pressed():
	for i in range(int($CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Line2D.text)):
		Globals.queued_scenes.append("res://Scenes/Asteroids.tscn")
	for i in range(int($CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/Line2D.text)):
		Globals.queued_scenes.append("res://Scenes/Pong.tscn")
	for i in range(int($CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Line2D.text)):
		Globals.queued_scenes.append("res://Scenes/Tron.tscn")
	Globals.next_scene()

