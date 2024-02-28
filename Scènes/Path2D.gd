extends Path2D

var t = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	get_node("PathFollow2D").progress = t
