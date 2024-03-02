extends CharacterBody2D

@export var axis_up := "l_u"
@export var axis_down := "l_d"
@export var paddle_speed := 20

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	#velocity.y = lerp(velocity.y, Input.get_axis(axis_up, axis_down) * paddle_speed, 0.1)
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Ball"):
		body.linear_velocity = body.linear_velocity.bounce(Vector2.RIGHT)
