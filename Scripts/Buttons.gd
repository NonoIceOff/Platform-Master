extends Button

var hover = 0
var pos = 0
	
	

func _ready():
	if get_node_or_null("Label") != null:
		get_node("Label").set("theme_override_colors/font_shadow_color", Color("646464"))
		get_node("Label").set("theme_override_constants/shadow_offset_y", 1)

func _process(_delta):
	if pos == 0:
		pos = position.y
	if self.is_hovered() == true:
		position.y = easeInCubic(position.y)
		set_self_modulate(lerp(get_self_modulate(), Color(1.4,0,2,1), 0.1))
	else:
		position.y = easeOutCubic(position.y)
		set_self_modulate(lerp(get_self_modulate(), Color(1,1,1,1), 0.1))
	
		
func easeInCubic(x):
	return lerp(x, pos-16, 0.05)
	
func easeOutCubic(x):
	return lerp(x, pos, 0.05)
