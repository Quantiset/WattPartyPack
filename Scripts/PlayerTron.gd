extends Area2D

@onready var line = $Line2D
@export var line_length = 11

@export var SPEED = 200

var velocity := Vector2()
var point_to := Vector2()

var raycasts := []

var frames := 0

var is_enabled := false
var has_started := false
var is_raycasting := true
var raycast: RayCast2D

var dir := Vector2(1,0)
var cached_dir := Vector2()
var trail_mod : Color

var id: String

func _ready():
	
	trail_mod = Color.from_hsv(randf(),1,1)
	raycast = RayCast2D.new()
	raycasts.append(raycast)
	raycast.top_level = true
	$Line2D.modulate.h += (randi() % 50) / 100.0
	point_to = $Node/LinePos.global_position
	raycast.exclude_parent = true
	get_parent().call_deferred("add_child",raycast)
	line.call_deferred("add_point", global_position)
	line.call_deferred("add_point", global_position)
	

func _physics_process(delta):
	
	if not is_enabled:
		return
	
	var tmp_dir = to_directional(Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")))
	if tmp_dir.length_squared() > 0.1 and tmp_dir != -dir:
		dir = tmp_dir
	
	if not dir.is_zero_approx() and dir != cached_dir:
		cached_dir = dir
		velocity = dir * SPEED
		change_dir()
	if raycast.is_colliding() and is_raycasting:
		if raycast.get_collider().is_in_group("Player"):
			get_parent().reset()
	
	position += velocity * delta
	$Sprite2D.rotation = lerp($Sprite2D.rotation, velocity.angle()+PI/2, 0.9)
	$Node.rotation = lerp($Node.rotation, velocity.angle()+PI/2, 0.9)
	
	frames += 1
	
	if is_raycasting:
		raycast.position = position
		raycast.target_position = point_to - $Node/LinePos.global_position
		line.remove_point(line.get_point_count()-1)
		line.add_point(global_position)

func t_enable():
	is_enabled = true

func t_disable():
	is_enabled = false

func update_data(data: Dictionary):
	var x = 0.0
	var y = 0.0
	if str(data["joy"]["x"]).is_valid_float():
		x = float(data["joy"]["x"])
	if str(data["joy"]["y"]).is_valid_float():
		y = float(data["joy"]["y"])
	var tmp_dir = to_directional(Vector2(x,y))
	if tmp_dir != -dir:
		dir = tmp_dir
	id = data["id"]
	$Label.text = str(data["num"])

func to_directional(inp: Vector2) -> Vector2:
	if inp.is_zero_approx():
		return Vector2()
	var dir = inp.normalized()
	if dir.dot(Vector2.RIGHT) > 0.717:
		return Vector2(1,0)
	elif dir.dot(Vector2.UP) > 0.717:
		return Vector2(0,-1)
	elif dir.dot(Vector2.LEFT) > 0.717:
		return Vector2(-1,0)
	else:
		return Vector2(0,1)

func change_dir():
	if not has_started:
		await get_tree().create_timer(0.2)
	if not is_raycasting: return
	get_parent().add_raycast(raycast)
	raycast = RayCast2D.new()
	raycasts.append(raycast)
	raycast.collide_with_areas = true
	raycast.top_level = true
	raycast.target_position = Vector2()
	point_to = global_position
	get_parent().call_deferred("add_child",raycast)
	raycast.global_position = $Node/LinePos.global_position
	line.add_point(global_position)

func reset():
	$Line2D.clear_points()

func disable():
	is_raycasting = false
	position.x = 9000000
