extends Control

@onready var rocket_button = $CenterContainer/HBoxContainer/VBoxContainer/Button
@onready var tron_button = $CenterContainer/HBoxContainer/VBoxContainer/Button2

@onready var buttons := [rocket_button, tron_button]

var file_name := ""

func _ready():
	for child in $Container/VBoxContainer.get_children():
		if child is TextureButton:
			child.mouse_entered.connect(_menu_button_mouse_entered.bind(child))
			child.mouse_entered.connect(_menu_button_mouse_exited.bind(child))
			child.pressed.connect(_menu_button_mouse_clicked.bind(child))
	for child in $CenterContainer/VBoxContainer/GridContainer.get_children():
		if child.is_in_group("Level"):
			child.clicked.connect(_level_selected.bind(child))

func _process(delta):
	$Background.scroll_offset += Vector2(4, 1) * delta

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
	$CanvasLayer/AnimationPlayer.play("Dither")
	await $CanvasLayer/AnimationPlayer.animation_finished
	Globals.next_scene()

func _menu_button_mouse_entered(menu_button):
	pass

func _menu_button_mouse_exited(menu_button):
	pass

func _menu_button_mouse_clicked(menu_button):
	match menu_button.get_node("Label").text:
		"Quickplay":
			Globals.queued_scenes.append_array(Globals.default_queue)
			_on_play_button_pressed()
		"Customize":
			$AnimationPlayer.play("ToLevelSelect")
