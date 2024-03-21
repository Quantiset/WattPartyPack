extends CharacterBody2D
class_name Ship

@onready var inner_line = $Line2D
var inner_line_length_ = 11

var time_until_last_dash_sprite_created := 0
var is_dashing := false
var is_enabled := false
var id: String

func update_data(data):
	id = data["id"]
	$Label.text = str(data["num"])

func _process(delta):
	
	time_until_last_dash_sprite_created += delta
	if time_until_last_dash_sprite_created > 0.3 and is_dashing:
		print("made a new sprite")
		var s = $Sprite2D.duplicate()
		get_parent().add_child(s)
		s.position = $Sprite2D.global_position
		var t := get_tree().create_tween()
		t.tween_property(s, "modulate:a", 0, 1)
		t.tween_callback(s.queue_free)
		time_until_last_dash_sprite_created = 0
	
	inner_line.add_point($Pivot/LineEmitter.global_position)
	if inner_line.get_point_count() > inner_line_length_:
		inner_line.remove_point(0)

func dash():
	is_dashing = true
	var t := get_tree().create_tween()
	$Sprite2D.modulate = Color(7,7,7)
	t.tween_property($Sprite2D, "modulate", Color(1,1,1), 2)
	t.tween_callback(set.bindv(["is_dashing", false]))

func disable():
	is_enabled = false

func enable():
	is_enabled = true
