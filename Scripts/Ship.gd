extends CharacterBody2D
class_name Ship

@onready var inner_line = $Line2D
@export var inner_line_length = 11

var is_enabled := false
var id: String

func update_data(data):
	id = data["id"]
	$Label.text = str(data["num"])

func _process(delta):
	inner_line.add_point($Pivot/LineEmitter.global_position)
	if inner_line.get_point_count() > inner_line_length:
		inner_line.remove_point(0)

func disable():
	is_enabled = false

func enable():
	is_enabled = true
