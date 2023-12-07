extends ParallaxBackground

var parallax_offset = 0
export var speed = 500

func _ready():
	$ParallaxLayer/Ground.set_position(Vector2(0, 360))

func _process(delta):
	if get_parent().game_started:
		parallax_offset -= speed * delta
		set_scroll_offset(Vector2(parallax_offset, 0))
		speed += delta * 10
	else: return
