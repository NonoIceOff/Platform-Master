extends Control

var hover = []



# Called when the node enters the scene tree for the first time.
func _ready():
	for i in TranslationServer.get_loaded_locales().size():
		hover.append(0)
		key_binding(i)


func _on_Back_pressed():
	get_tree().change_scene_to_file("res://Scènes/Settings.tscn")
	MusicController.play_select_sound()
	VarGlobales.save_options()
	pass # Replace with function body.

func key_binding(i):
	var base = get_node("ScrollContainer/VBoxContainer1")
	
	var button = Button.new()
	button.name = "Button"+str(i)
	button.custom_minimum_size = Vector2(512,64)
	button.position = Vector2(300,0)
	button.theme = load("res://Themes/black_and_white_theme.tres")
	base.add_child(button)
	
	var label = Label.new()
	label.name = "Label"
	label.self_modulate = Color("9d00ff")
	label.text = str(TranslationServer.get_locale_name(TranslationServer.get_loaded_locales()[i]).capitalize())
	label.custom_minimum_size = Vector2(512/2.5,64)/1.5
	label.scale = Vector2(2.5,2.5)*1.5
	label.position = Vector2(0,8)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.add_child(label)
	
func _process(_delta):
	for i in TranslationServer.get_loaded_locales().size():
		if get_node("ScrollContainer/VBoxContainer1/Button"+str(i)).button_pressed == true:
			MusicController.play_select_sound()
			TranslationServer.set_locale(TranslationServer.get_loaded_locales()[i])

		if get_node_or_null("ScrollContainer/VBoxContainer1/Button"+str(i)) != null:
			if hover[i] == 1:
				get_node("ScrollContainer/VBoxContainer1/Button"+str(i)).position.y = easeInCubic(get_node("ScrollContainer/VBoxContainer1/Button"+str(i)).position.y,i)
				get_node("ScrollContainer/VBoxContainer1/Button"+str(i)).set_self_modulate(lerp(get_node("ScrollContainer/VBoxContainer1/Button"+str(i)).get_self_modulate(), Color(1.4,0,2,1), 0.1))
			else:
				get_node("ScrollContainer/VBoxContainer1/Button"+str(i)).position.y = easeOutCubic(get_node("ScrollContainer/VBoxContainer1/Button"+str(i)).position.y,i)
				get_node("ScrollContainer/VBoxContainer1/Button"+str(i)).set_self_modulate(lerp(get_node("ScrollContainer/VBoxContainer1/Button"+str(i)).get_self_modulate(), Color(1,1,1,1), 0.1))
			
			if get_node("ScrollContainer/VBoxContainer1/Button"+str(i)).is_hovered() == true:
				hover[i] = 1
			else:
				hover[i] = 0

func easeInCubic(x,i):
	return lerp(x, i*74-16, 0.05)
	
func easeOutCubic(x,i):
	return lerp(x, i*74, 0.05)
