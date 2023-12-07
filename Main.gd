extends Node

var speed = 500

onready var hud = get_node("CanvasLayer/HUD")

var timer_min_time = 1
var timer_max_time = 3

var game_started = false
var game_over = false
var score = 0
var high_score = 0

onready var cactus_array = [preload("res://SmallCactus1.tscn"),
							preload("res://SmallCactus2.tscn"),
							preload("res://SmallCactus3.tscn"),
							preload("res://LargeCactus1.tscn"),
							preload("res://LargeCactus2.tscn"),
							preload("res://LargeCactus3.tscn")]

func _process(delta):
	if game_started:
		speed += delta * 10
		score += delta * 5
		hud.get_node("HBoxContainer/ScoreLabel").set_text(str(round(score)))
	else: return
	
func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		if event.is_pressed() and not game_started and not event.is_echo():
			new_game()

func new_game():
	delete_entities_of_group("Obstacle")
	$Player.set_position(Vector2(115, 328))
	game_started = true
	game_over = false
	score = 0
	speed = 500
	$ParallaxBackground.speed = 500
	$Timer.start()
	
func end_game():
	$Timer.stop()
	stop_entities_of_group("Obstacle")
	game_started = false
	game_over = true
	update_score()
	
func delete_entities_of_group(name):
	var entities = get_tree().get_nodes_in_group(name)
	for entity in entities:
		entity.queue_free() 

func stop_entities_of_group(name):
	var entities = get_tree().get_nodes_in_group(name)
	for entity in entities:
		entity.game_over = true

func update_score():
	if score > high_score:
		high_score = score
		hud.get_node("HBoxContainer/HighScoreLabel").set_text("HI " + str(round(score)))

func _on_Timer_timeout():
	randomize()
	
	var random = rand_range(0, cactus_array.size())
	var cactus = cactus_array[random].instance()
	
	add_child(cactus)
	cactus.position = Vector2(950, 375)
	cactus.speed = speed
	
	var random_time = rand_range(timer_min_time, timer_max_time)
	
	$Timer.wait_time = random_time
