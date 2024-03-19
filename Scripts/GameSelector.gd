extends VBoxContainer

signal clicked

@export var path: String = "res://Scenes/PaperMap.tscn"

var is_mouse_hovering := false
var selectable := true

func _on_mouse_entered():
	is_mouse_hovering = true
	if selectable:
		$AnimationPlayer.play("Dilate")

func _on_mouse_exited():
	is_mouse_hovering = false
	if selectable:
		$AnimationPlayer.play_backwards("Dilate")
		$AnimationPlayer.seek(0.2)

func _on_gui_input(event):
	if selectable and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and is_mouse_hovering and event.is_pressed():
		clicked.emit()
