extends Sprite2D

var d = 350
var radius = 400
var speed = -1


func _process(delta):
	d += delta
	
	position = Vector2(
		sin(d * speed) * radius,
		cos(d * speed) * radius
	) + get_node("../Camera2D").position+Vector2(0,200)
