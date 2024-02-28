extends Control

var hover = 0

func _ready():
	VarGlobales.achivements_value[-1] = 0
	var nbr_achi_completed = 0
	for i in VarGlobales.achievements_completed.size():
		if VarGlobales.achievements_completed[i] == 1:
			nbr_achi_completed += 1
	if nbr_achi_completed >= VarGlobales.achievements_completed.size()-1:
		VarGlobales.achievements_completed[-1] = 1
		
	for i in VarGlobales.achievements_title.size():
		var achievement = Panel.new()
		achievement.name = "Panel"+str(i)
		achievement.custom_minimum_size = Vector2(600,64)
		if i % 2:
			get_node("ScrollAchivement1/HBoxContainer/VBoxContainer2").add_child(achievement)
		else:
			get_node("ScrollAchivement1/HBoxContainer/VBoxContainer").add_child(achievement)
		
		if VarGlobales.achievements_completed[i] == 0:
			if VarGlobales.achivements_max_value[i] > 0:
				var achivement_progress = ProgressBar.new()
				achivement_progress.name = "Progress"+str(i)
				achivement_progress.custom_minimum_size = Vector2(600,64)
				achivement_progress.min_value = 0
				achivement_progress.max_value = VarGlobales.achivements_max_value[i]
				achivement_progress.value = VarGlobales.achivements_value[i]
				achivement_progress.percent_visible = false
				achivement_progress.self_modulate = Color(1,0,1)
				achievement.add_child(achivement_progress)
		
		var achievement_sprite = Sprite2D.new()
		achievement_sprite.name = "Sprite2D"+str(i)
		achievement_sprite.position = Vector2(32,32)
		achievement_sprite.texture = load(VarGlobales.achievements_sprite[i])
		achievement_sprite.scale = Vector2(1.5,1.5)
		achievement.add_child(achievement_sprite)
		
		var achievement_title = Label.new()
		achievement_title.name = "Title"+str(i)
		achievement_title.position = Vector2(60,8)
		achievement_title.scale = Vector2(1.4,1.4)*1.8
		achievement_title.text = VarGlobales.achievements_title[i]
		achievement_title.set("theme_override_colors/font_shadow_color", Color("646464"))
		achievement_title.set("theme_override_constants/shadow_offset_y", 1)
		achievement.add_child(achievement_title)
		
		var achievement_desc = Label.new()
		achievement_desc.name = "Description"+str(i)
		achievement_desc.position = Vector2(68,36)
		achievement_desc.size = Vector2(635,38)
		achievement_desc.scale = Vector2(0.8,0.8)*1.8
		achievement_desc.text = VarGlobales.achievements_description[i]
		achievement_desc.autowrap = true
		achievement_desc.self_modulate = Color("999999")
		achievement.add_child(achievement_desc)
		
		if VarGlobales.achivements_max_value[i] > 0:
			var achievement_desc2 = Label.new()
			achievement_desc2.name = "Description2"+str(i)
			achievement_desc2.position = Vector2(90,4)
			achievement_desc2.size = Vector2(635,38)/2
			achievement_desc2.scale = Vector2(0.8,0.8)*2
			achievement_desc2.autowrap = true
			achievement_desc2.self_modulate = Color("999999")
			achievement_desc2.align = Label.ALIGN_RIGHT
			achievement_desc2.text = str(" (",VarGlobales.achivements_value[i],"/",VarGlobales.achivements_max_value[i],")")
			achievement.add_child(achievement_desc2)
		
		if VarGlobales.achievements_completed[i] == 0:
			achievement.self_modulate = Color("757575")
			achievement_title.self_modulate = Color("444444")
			achievement_sprite.self_modulate = Color(0.25,0.25,0.25)
		else:
			achievement.self_modulate = Color("ff02a8")
			achievement_title.self_modulate = Color("ec07ff")
			VarGlobales.achivements_value[-1] += 1

func _on_Settings_mouse_entered():
	while hover <= 5:
		hover += 1
		var x = get_position().x
		var y = get_position().y
		set_position(Vector2(x+0,y-2))
		var t = Timer.new()
		t.set_wait_time(0.01)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		await t.timeout
		t.queue_free()

func _on_Settings_mouse_exited():
	while hover >= 0:
		hover -= 1
		var x = get_position().x
		var y = get_position().y
		set_position(Vector2(x+0,y+2))
		var t = Timer.new()
		t.set_wait_time(0.01)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		await t.timeout
		t.queue_free()

func _on_Back_pressed():
	get_tree().change_scene_to_file("res://Scènes/WorldsMenu.tscn")
	VarGlobales.save_options()
	MusicController.play_select_sound()
