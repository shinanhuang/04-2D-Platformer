extends KinematicBody2D

onready var SM = $StateMachine

var velocity = Vector2.ZERO
var jump_power = Vector2.ZERO
var direction = 1

export var gravity = Vector2(0,30)

export var move_speed = 320
export var max_move = 300

export var jump_speed = 500
export var max_jump = 4800

export var leap_speed = 400
export var max_leap = 2400

var moving = false
var is_jumping = false
var double_jumped = false
var should_direction_flip = true # wether or not player controls (left/right) can flip the player sprite

func _ready():
	scale.x = 3
	scale.y = 3

func _physics_process(_delta):
	velocity.x = clamp(velocity.x,-max_move,max_move)

	if should_direction_flip:
		if direction < 0 and not $AnimatedSprite.flip_h: $AnimatedSprite.flip_h = true
		if direction > 0 and $AnimatedSprite.flip_h: $AnimatedSprite.flip_h = false

	if is_on_floor():
		double_jumped = false
		set_wall_raycasts(true)

func is_moving():
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		return true
	return false

func move_vector():
	return Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),1.0)

func _unhandled_input(event):
	if event.is_action_pressed("left"):
		direction = -1
	if event.is_action_pressed("right"):
		direction = 1

func set_animation(anim):
	if $AnimatedSprite.animation == anim: return
	if $AnimatedSprite.frames.has_animation(anim): $AnimatedSprite.play(anim)
	else: $AnimatedSprite.play()

func is_on_floor():
	var fl = $Floor.get_children()
	for f in fl:
		if f.is_colliding():
			return true
	return false

func is_on_right_wall():
	if $Wall/Right.is_colliding():
		return true
	return false

func is_on_left_wall():
	if $Wall/Right.is_colliding():
		return true
	return false

func get_right_collider():
	return $Wall/Right.get_collider()

func get_left_collider():
	return $Wall/Left.get_collider()

func set_wall_raycasts(is_enabled):
	$Wall/Left.enabled = is_enabled
	$Wall/Right.enabled = is_enabled

func do_damage(d):
	Global.decrease_health(d)
	if Global.health <= 0:
		die()

func die():
	var bat = get_node_or_null("/root/Game/Enemy_Container/Enemy_Flying")
	if bat != null:
		bat.global_position = Vector2(5163,125)
	Global.decrease_lives(1)
	queue_free()

