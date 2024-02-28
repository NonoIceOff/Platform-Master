extends Area2D

func _input(event):
	if (event is InputEventMouseButton && event.pressed):
		if get_tree().is_server():
			get_parent().rpc("hit_by_damager", 1)
