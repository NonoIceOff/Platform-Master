extends Sprite2D

func _process(_delta):
	set_position(Vector2(get_global_mouse_position().x,get_global_mouse_position().y))
