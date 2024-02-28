extends ColorRect

func _process(delta):
	
#	if get_node("Name").rect_size.x >= get_node("Tag/Name").rect_size.x:
		get_node("Description").size.x = size.x
		get_node("Tag").size.x = size.x
#	else:
#		get_node("Description").rect_size.x = get_node("Tag/Name").rect_size.x+12
#		rect_size.x = get_node("Tag/Name").rect_size.x+12
#		get_node("Tag").rect_size.x = get_node("Tag/Name").rect_size.x+12

		
