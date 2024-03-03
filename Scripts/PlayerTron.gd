extends Area2D

@onready var line = $Line2D
@export var line_length = 11

@export var SPEED = 360

var velocity := Vector2()

var frames := 0

var raycast: RayCast2D

func _ready():
	raycast = RayCast2D.new()
	add_child(raycast)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_up"):
		velocity.x = 0
		velocity.y = -SPEED
		change_dir()
	elif Input.is_action_just_pressed("ui_down"):
		velocity.x = 0
		velocity.y = SPEED
		change_dir()
	elif Input.is_action_just_pressed("ui_right"):
		velocity.y = 0
		velocity.x = SPEED
		change_dir()
	elif Input.is_action_just_pressed("ui_left"):
		velocity.y = 0
		velocity.x = -SPEED
		change_dir()
	position += velocity * delta
	raycast.target_position -= velocity * delta
	$Sprite2D.rotation = lerp($Sprite2D.rotation, velocity.angle()+PI/2, 0.9)
	$Node.rotation = lerp($Node.rotation, velocity.angle()+PI/2, 0.9)
	
	frames += 1
	
	if frames % 3 == 1:
		line.add_point($Node/LinePos.global_position)

func change_dir():
	get_parent().raycasts.append(raycast)
	raycast = RayCast2D.new()
	add_child(raycast)

func reset():
	$Line2D.clear_points()
