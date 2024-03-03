extends Area2D

@onready var line = $Line2D
@export var line_length = 11

@export var SPEED = 200

var velocity := Vector2()
var point_to := Vector2()

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
	raycast.top_level = true
	point_to = $Node/LinePos.global_position
	raycast.exclude_parent = true
	get_parent().call_deferred("add_child",raycast)
	

func _physics_process(delta):
	if not is_enabled:
		return
	
	if dir != cached_dir:
		cached_dir = dir
		velocity = dir * SPEED
		change_dir()
	if raycast.is_colliding() and is_raycasting:
		if raycast.get_collider().is_in_group("Player"):
			get_parent().reset()
	
	position += velocity * delta
	raycast.position = position
	raycast.target_position = point_to - $Node/LinePos.global_position
	$Sprite2D.rotation = lerp($Sprite2D.rotation, velocity.angle()+PI/2, 0.9)
	$Node.rotation = lerp($Node.rotation, velocity.angle()+PI/2, 0.9)
	
	frames += 1
	
	if frames % 3 == 1 and is_raycasting:
		line.add_point($Node/LinePos.global_position)

func t_enable():
	is_enabled = true

func t_disable():
	is_enabled = false

func update_data(data: Dictionary):
	dir = Vector2(data["joy"]["x"], data["joy"]["y"]).normalized()
	if dir.dot(Vector2.RIGHT) > 0.7:
		dir = Vector2(1,0)
	elif dir.dot(Vector2.UP) > 0.7:
		dir = Vector2(0,-1)
	elif dir.dot(Vector2.LEFT) > 0.7:
		dir = Vector2(-1,0)
	elif dir.dot(Vector2.DOWN) > 0.7:
		dir = Vector2(0,1)
	id = data["id"]

func change_dir():
	if not has_started:
		await get_tree().create_timer(0.2)
	if not is_raycasting: return
	get_parent().add_raycast(raycast)
	raycast = RayCast2D.new()
	raycast.collide_with_areas = true
	raycast.top_level = true
	raycast.target_position = Vector2()
	point_to = $Node/LinePos.global_position
	get_parent().call_deferred("add_child",raycast)
	raycast.global_position = $Node/LinePos.global_position

func reset():
	$Line2D.clear_points()

func disable():
	is_raycasting = false
	position.x = 9000000
