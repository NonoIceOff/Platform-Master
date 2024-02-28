extends Control

var popup_i = -1
var rng = RandomNumberGenerator.new()

const script_button = preload("res://Scripts/Buttons.gd")

func load_external_tex(path,scale):
	var tex_file = FileAccess.open(path,FileAccess.READ_WRITE)
	var buffer = tex_file.get_buffer(tex_file.get_length())

	var img = Image.new()
	img.load_png_from_buffer(buffer)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	imgtex.set_size_override(Vector2i(scale,scale))
	
	tex_file.close()
	return imgtex

func _ready():
	rng.randomize()
	spawnworlds()
	if VarGlobales.demo == 1:
		get_node("CreateWorld").disabled = true
		get_node("CreateWorld").icon = load("res://Textures/lock.png")

func testworlds():
	var array = get_node("ScrollContainer/VBoxContainer").get_children()
	return array.size()

func unspawnworlds():
	var array = get_node("ScrollContainer/VBoxContainer").get_children()
	for i in range(0,array.size()):
		print(array[i])
		array[i].queue_free()
		await get_tree().process_frame
	spawnworlds()
	
func spawnworlds():
	var dir = DirAccess.open("user://Worlds")
	print(dir)
	if dir:
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		for i in 100:
			if i % 3 == 0:
				var hbox = HBoxContainer.new()
				hbox.name ="HBox"+str(i/3)
				hbox.set("theme_override_constants/separation", 25)
				get_node("ScrollContainer/VBoxContainer").add_child(hbox)
				
			
			var file = dir.get_next()
			if file != "":

				var config = ConfigFile.new()
				var err = config.load("user://Worlds/"+str(file)+"/Infos.txt")
				if err == OK:
					var panel = Panel.new()
					panel.name = "Panel"+str(i)
					get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)).add_child(panel)
					panel.custom_minimum_size = Vector2(216+128,256+128)
					panel.set_position(Vector2(32,128+80*i))
					panel.self_modulate = Color(1, 0, 0.537255)
					panel.name = "Panel"+str(i)


					var text_world = Label.new()
					text_world.text = config.get_value("World","Name","Unkown")
					text_world.name = "TextWorld"+str(i)
					text_world.set_position(Vector2(8,128+32+8+32))
					text_world.material = load("res://wave_text.tres")
					text_world.scale = Vector2(1.4,1.4)*1.8
					text_world.set("theme_override_colors/font_shadow_color", Color("646464"))
					text_world.set("theme_override_constants/shadow_offset_y", 1)
					panel.add_child(text_world)
					if config.get_value("World","SaveVersion",1) != VarGlobales.WorldSaveVersion:
						text_world.text += "  (Save Version not compatible)"

					var text_version = Label.new()
					text_version.text = "Game Version : "+str(config.get_value("World","Version","Unkown"))
					text_version.name = "TextVersion"+str(i)
					text_version.set_position(Vector2(16,128+64+16+32))
					text_version.self_modulate = Color(1,1,1,0.5)
					text_version.scale = Vector2(1,1)*1.4
					panel.add_child(text_version)

					var text_seed = Label.new()
					text_seed.text = "WORLD SEED"
					text_seed.text += " : " +str(config.get_value("World","Seed","Unkown"))
					text_seed.name = "TextSeed"+str(i)
					text_seed.set_position(Vector2(16,128+64+40+32))
					text_seed.self_modulate = Color(1,1,1,0.5)
					text_seed.scale = Vector2(1,1)*1.4
					panel.add_child(text_seed)

					var button = Button.new()
					button.icon = load("res://Textures/Icons/play_icon.png")
					button.name = "Launch"+str(i)
					button.text = "Launch"
					button.material = load("res://wave_text.tres")
					button.custom_minimum_size = Vector2(20,20)
					button.set_position(Vector2(8,256+64+16))
					button.scale = Vector2(2,2)
					button.set_script(script_button)
					panel.add_child(button)
					if config.get_value("World","SaveVersion",1) != VarGlobales.WorldSaveVersion:
						button.self_modulate = Color(1,0,0)

					var buttonsp2 = Button.new()
					buttonsp2.icon = load("res://Textures/Icons/settings_icon.png")
					buttonsp2.name = "Edit"+str(i)
					buttonsp2.custom_minimum_size = Vector2(20,20)
					buttonsp2.set_position(Vector2(256-8,256+64+16))
					buttonsp2.scale = Vector2(2,2)
					buttonsp2.set_script(script_button)
					panel.add_child(buttonsp2)
					if config.get_value("World","SaveVersion",1) != VarGlobales.WorldSaveVersion:
						buttonsp2.visible = false

					var buttonsp = Button.new()
					buttonsp.icon = load("res://Textures/Icons/delete_icon.png")
					buttonsp.name = "Supr"+str(i)
					buttonsp.custom_minimum_size = Vector2(20,20)
					buttonsp.set_position(Vector2(256+48-8,256+64+16))
					buttonsp.scale = Vector2(2,2)
					buttonsp.set_script(script_button)
					panel.add_child(buttonsp)

					var buttonsp22 = Button.new()
					buttonsp22.text = "?"
					buttonsp22.name = "Supr2"+str(i)
					buttonsp22.custom_minimum_size = Vector2(20,20)
					buttonsp22.set_position(Vector2(256+48-8,256+64+16))
					buttonsp22.scale = Vector2(2,2)
					buttonsp22.self_modulate = Color(1,0,0)
					buttonsp22.set_script(script_button)
					buttonsp22.visible = false
					panel.add_child(buttonsp22)

					var textedit_world = LineEdit.new()
					textedit_world.text = config.get_value("World","Name","Unkown")
					textedit_world.name = "TextEditWorld"+str(i)
					#textedit_world.focus_mode = Control.FOCUS_NONE
					textedit_world.custom_minimum_size = Vector2(256,24)/2
					textedit_world.set_position(Vector2(8,128+32+8+32))
					textedit_world.material = load("res://wave_text.tres")
					textedit_world.scale = Vector2(1.4,1.4)*1.8
					textedit_world.visible = false
					panel.add_child(textedit_world)

					var choosemode = OptionButton.new()
					choosemode.add_item("SURVIVAL MODE")
					choosemode.add_item("CHEAT MODE")
					choosemode.add_item("VISION MODE")
					choosemode.name = "ChooseMode"+str(i)
					choosemode.clip_text = true
					choosemode.focus_mode = Control.FOCUS_NONE
					choosemode.custom_minimum_size = Vector2(232,32/2)
					choosemode.set_position(Vector2(69,33))
					choosemode.select(config.get_value("World","Mode",0))
					choosemode.alignment = HORIZONTAL_ALIGNMENT_CENTER
					choosemode.visible = false
					panel.add_child(choosemode)

					var copyseed = Button.new()
					copyseed.text = "SEED"
					copyseed.name = "Copyseed"
					copyseed.custom_minimum_size = Vector2(100,28)/2
					copyseed.set_position(Vector2(306,34))
					copyseed.focus_mode = Control.FOCUS_NONE
					copyseed.visible = false
					copyseed.set_script(script_button)
					copyseed.icon = load("res://Textures/arrow restart.png")
					panel.add_child(copyseed)

					var validate = Button.new()
					validate.icon = load("res://Textures/Icons/accept_icon.png")
					validate.name = "Validate"+str(i)
					validate.custom_minimum_size = Vector2(20,20)
					validate.set_position(Vector2(256-8,256+64+16))
					validate.scale = Vector2(2,2)
					validate.visible = false
					validate.set_script(script_button)
					panel.add_child(validate)

					var cancel = Button.new()
					cancel.icon = load("res://Textures/Icons/cancel_icon.png")
					cancel.name = "Cancel"+str(i)
					cancel.custom_minimum_size = Vector2(20,20)
					cancel.set_position(Vector2(256+48-8,256+64+16))
					cancel.scale = Vector2(2,2)
					cancel.visible = false
					cancel.set_script(script_button)
					panel.add_child(cancel)

					var image = Sprite2D.new()
					image.name = "Sprite2D"+str(i)
					if FileAccess.file_exists("user://Worlds/"+str(file)+"/screenshot.png"):
						var img = crate_sprite("user://Worlds/"+str(file)+"/screenshot.png")
						image.texture = img.texture
					else:
						image.set_position(Vector2(128+32,64+32))
						image.set_scale(Vector2(11.5,6))
						image.texture = load(VarGlobales.collection[str(config.get_value("World","Thumbnail",0))][0])

					panel.add_child(image)
					print(image.texture)

					if not config.get_value("World","SaveVersion",1) == VarGlobales.WorldSaveVersion:
						panel.self_modulate = Color(1, 0, 0)
						text_world.self_modulate = Color(1, 0, 0)
#
	if testworlds() == 0:
		get_tree().change_scene_to_file("res://Scènes/WorldsCreationMenu.tscn")
		
func crate_sprite(path):
	var img = Image.new()
	var err = img.load(path)
	if(err != 0):
		print("error loading the image: " + path)
		return null
	var img_tex = ImageTexture.new()
	img_tex.create_from_image(img)

	var sprite = Sprite2D.new()
	sprite.texture = img_tex

	return sprite

func _process(_delta):
	if visible == true:
		var dir = DirAccess.open("user://Worlds")
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		for i in 100:
			var file = dir.get_next()
			if file != "":
				var config = ConfigFile.new()
				var err = config.load("user://Worlds/"+str(file)+"/Infos.txt")
				var config_player = ConfigFile.new()
				config_player.load("user://Worlds/"+str(file)+"/Player.txt")
				if err == OK:
					if get_node_or_null("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)) == null:
						break
					else:
						if get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Copyseed").is_pressed():
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Copyseed").disabled = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Copyseed").icon = load("res://Textures/copy_icon_1.png")
							DisplayServer.clipboard_set(str(config.get_value("World","Seed","Unkown")))
							
						if get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Launch"+str(i)).is_pressed():
							VarGlobales.initialisation()
							MusicController.get_node("Music").stop()
							if config.get_value("World","SaveVersion",1) == VarGlobales.WorldSaveVersion:
								VarGlobales.blocks_nbt = {}
								VarGlobales.WorldDimension = 1
								VarGlobales.WorldMode = config.get_value("World","Mode",VarGlobales.WorldMode)
								VarGlobales.WorldSeed = config.get_value("World","Seed",VarGlobales.WorldSeed)
								VarGlobales.WorldThumbnail = config.get_value("World","Thumbnail")
								VarGlobales.WorldName = config.get_value("World","Name","Unkown")
								VarGlobales.WorldWaterLevel = config.get_value("World","Water Level",VarGlobales.WorldWaterLevel)
								VarGlobales.WorldSurfaceHeight = config.get_value("World","Surface Height",VarGlobales.WorldSurfaceHeight)
								VarGlobales.WorldMode = config.get_value("World","Mode",VarGlobales.WorldMode)
								VarGlobales.health = config_player.get_value("Stats","Health",VarGlobales.health)
								VarGlobales.food = config_player.get_value("Stats","Food",VarGlobales.food)
								VarGlobales.saturation = config_player.get_value("Stats","Saturation",VarGlobales.saturation)
								var file_world = ConfigFile.new()
								file_world.load("user://Worlds/"+str(VarGlobales.WorldFile)+"/"+str(VarGlobales.WorldDimensionNames[VarGlobales.WorldDimension-1])+"/Infos.txt")
								VarGlobales.WorldBiome = file_world.get_value("Chunks","WorldBiome",0)
								VarGlobales.slot_selected = 1
								VarGlobales.WorldState = 1
								VarGlobales.LoadedTimes = 1
								get_tree().change_scene_to_file("res://Scènes/WorldState.tscn")
								VarGlobales.WorldFile = str(file)
								MusicController.play_select_sound()
								await get_tree().create_timer(0.1).timeout
								get_tree().change_scene_to_file("res://Scènes/World.tscn")

						if get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Supr"+str(i)).is_pressed():
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Supr"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Supr2"+str(i)).visible = true
							
						if get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Supr2"+str(i)).is_pressed():
							remove_recursive("user://Worlds/"+str(file))
							MusicController.play_select_sound()
							unspawnworlds()

						if get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Edit"+str(i)).is_pressed():
							MusicController.play_select_sound()
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextWorld"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextVersion"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextSeed"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Launch"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Edit"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Supr"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Validate"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Cancel"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextEditWorld"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/ChooseMode"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Copyseed").visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Copyseed").disabled = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Copyseed").icon = load("res://Textures/copy_icon_0.png")
						
						
							

						if get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Validate"+str(i)).is_pressed():
							MusicController.play_select_sound()
							var configedit = ConfigFile.new()
							configedit.set_value("World","Name",get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextEditWorld"+str(i)).text)
							configedit.set_value("World","Seed",config.get_value("World","Seed","Unkown"))
							configedit.set_value("World","Size",config.get_value("World","Size",16000))
							configedit.set_value("World","Version",config.get_value("World","Version","Unkown"))
							configedit.set_value("World","SaveVersion",config.get_value("World","SaveVersion",1))
							configedit.set_value("World","Mode",get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/ChooseMode"+str(i)).selected)
							configedit.set_value("World","Thumbnail",VarGlobales.WorldThumbnail)
							configedit.set_value("World","Achievement Locked",config.get_value("World","Achievement Locked",0))
							configedit.set_value("World","Water Level",config.get_value("World","Water Level",VarGlobales.WorldWaterLevel))
							configedit.set_value("World","Surface Height",config.get_value("World","Surface Height",VarGlobales.WorldSurfaceHeight))
							configedit.save("user://Worlds/"+str(file)+"/Infos.txt")
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextWorld"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextVersion"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextSeed"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Launch"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Edit"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Supr"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Copyseed").visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Validate"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Cancel"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextEditWorld"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/ChooseMode"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextWorld"+str(i)).text = get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextEditWorld"+str(i)).text

						if get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Cancel"+str(i)).is_pressed():
							MusicController.play_select_sound()
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/ImageBut"+str(i))
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextWorld"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextVersion"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextSeed"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Launch"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Edit"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Supr"+str(i)).visible = true
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Validate"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Cancel"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/TextEditWorld"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/ChooseMode"+str(i)).visible = false
							get_node("ScrollContainer/VBoxContainer/HBox"+str(i/3)+"/Panel"+str(i)+"/Copyseed").visible = false

func _on_CreateWorld_pressed():
	get_tree().change_scene_to_file("res://Scènes/WorldsCreationMenu.tscn")
	MusicController.play_select_sound()
	pass # Replace with function body.


func _on_Back_pressed():
	get_tree().change_scene_to_file("res://Scènes/Menu.tscn")
	MusicController.play_select_sound()
	
func remove_recursive(path):
	var directory = DirAccess.open(path)
	
	directory.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var file_name = directory.get_next()
	while file_name != "":
		if directory.current_is_dir():
			remove_recursive(path + "/" + file_name)
		else:
			directory.remove(file_name)
		file_name = directory.get_next()
	
	# Remove current path
	directory.remove(path)


func _on_Achievements_pressed():
	get_tree().change_scene_to_file("res://Scènes/Achievements.tscn")
	MusicController.play_select_sound()
