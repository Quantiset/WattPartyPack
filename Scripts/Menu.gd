extends Control

@onready var rocket_button = $CenterContainer/HBoxContainer/VBoxContainer/Button
@onready var tron_button = $CenterContainer/HBoxContainer/VBoxContainer/Button2

@onready var buttons := [rocket_button, tron_button]

var file_name := ""

func _ready():
	for child in $CenterContainer/VBoxContainer/GridContainer.get_children():
		if child.is_in_group("Level"):
			child.clicked.connect(_level_selected.bind(child))

func refresh_buttons():
	for button in buttons:
		button.modulate.a = 1

func _level_selected(level):
	var cont = $CenterContainer/VBoxContainer/HBoxContainer/ScrollContainer/HBoxContainer/Container.duplicate()
	var level2 = level.duplicate()
	level2.selectable = false
	$CenterContainer/VBoxContainer/HBoxContainer/ScrollContainer/HBoxContainer.add_child(cont)
	$CenterContainer/VBoxContainer/HBoxContainer/ScrollContainer/HBoxContainer.add_child(level2)

func _on_play_button_pressed():
	for child in $CenterContainer/VBoxContainer/HBoxContainer/ScrollContainer/HBoxContainer.get_children():
		if child.is_in_group("Level"):
			for i in range(max(int(child.get_node("LineEdit").text), 1)):
				Globals.queued_scenes.append(child.path)
	Globals.next_scene()

