extends KinematicBody2D

onready var collision_shape = get_node("CollisionShape2D")
onready var sprite = get_node("AnimatedSprite")

const GRAVITY = 25
const UP = Vector2(0, -1)
var motion = Vector2()
var is_crouching = false

export var jump_speed = -800
export var duck_speed = 200

func _ready():
	sprite.play("idle")

func _physics_process(_delta):
	if get_parent().game_started:
		apply_gravity()
		play_animation()
		get_input()
	else: return
	
func get_input():
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		motion.y += jump_speed
	if Input.is_action_pressed("ui_down"):
		if is_on_floor():
			crouch()
		else:
			motion.y += duck_speed
	if not Input.is_action_pressed("ui_down"):
		sprite.offset.y = 0
		is_crouching = false
		
	move_and_slide(motion, UP)
		
func apply_gravity():
	if is_on_floor():
		motion.y = 0
	if Input.is_action_pressed("ui_up"):
		motion.y += GRAVITY
	else: motion.y += GRAVITY * 2
	
func play_animation():
	if is_on_floor():
		if is_crouching:
			sprite.play("crouch")
		else:
			sprite.play("run")
	else: 
		sprite.play("jump")
		
func crouch():
	if is_crouching or !is_on_floor():
		return
	sprite.offset.y = 17
	collision_shape.shape.set_extents(Vector2(59, 30))
	collision_shape.position.y = 17
	is_crouching = true

func dead():
	if is_crouching:
		sprite.offset.y = 0
	sprite.play("death")
	get_parent().end_game()
