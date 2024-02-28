extends Button

var hover = 0

func _on_Video_mouse_entered():
	hover = 1
	pass # Replace with function body.


func _on_Video_mouse_exited():
	hover = 0
	pass # Replace with function body.
	
func _process(_delta):
	if hover == 1:
		position.y = easeInCubic(position.y)
		set_self_modulate(lerp(get_self_modulate(), Color(1.4,0,2,1), 0.1))
	else:
		position.y = easeOutCubic(position.y)
		set_self_modulate(lerp(get_self_modulate(), Color(1,1,1,1), 0.1))
		
	
func easeInCubic(x):
	return lerp(x, 333-16, 0.05)
	
func easeOutCubic(x):
	return lerp(x, 333, 0.05)
