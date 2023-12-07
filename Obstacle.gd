extends Area2D

var game_over = false
var speed = 0

func _process(delta):
	if game_over:
		return
	else:
		position.x -= speed * delta
		speed += delta * 5

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Obstacle_body_entered(body):
	if body.has_method("dead"):
		body.dead()
