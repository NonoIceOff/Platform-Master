extends Control

var tpressed = 0

func check_blockitems():
	var compt = 0
	for i in VarGlobales.collection.keys():
		compt += 1
	return compt
	
func _ready():
	if OS.get_name() != "Android":
		pass
	else:
		pass
	get_node("Label_Mode/ChooseMode").add_item("GAMEMODE_SURVIVAL")
	get_node("Label_Mode/ChooseMode").add_item("GAMEMODE_CHEAT")
	get_node("Label_Mode/ChooseMode").add_item("GAMEMODE_VISION")
	
	get_node("Label_Partymode/ChoosePartymode").add_item("OPEN WORLD")
	get_node("Label_Partymode/ChoosePartymode").add_item("SKYBLOCK")

	get_node("Label_Biome/ChooseBiome").add_item("BIOME_ALLBIOMES")
	for i in VarGlobales.chunk_name.size():
		get_node("Label_Biome/ChooseBiome").add_item(VarGlobales.chunk_name[i])
		
	get_node("Label_WaterLevel/MinValue").text = str(get_node("Label_WaterLevel/ChooseWaterLevel").min_value)
	get_node("Label_WaterLevel/MaxValue").text = str(get_node("Label_WaterLevel/ChooseWaterLevel").max_value)
	get_node("Label_SurfaceHeight/MinValue").text = str(get_node("Label_SurfaceHeight/ChooseSurfaceHeight").min_value)
	get_node("Label_SurfaceHeight/MaxValue").text = str(get_node("Label_SurfaceHeight/ChooseSurfaceHeight").max_value)
	
	VarGlobales.WorldThumbnail = VarGlobales.rng.randi_range(0,check_blockitems()-1)
	get_node("Thumbnail/Sprite2D").texture = load(VarGlobales.collection[str(VarGlobales.WorldThumbnail)][0])

func _process(_delta):
	if visible == true: 
		
		#get_node("PopupPanel").visible = get_node("Thumbnail").pressed
		
		get_node("Label_WaterLevel/Value").text = str(get_node("Label_WaterLevel/ChooseWaterLevel").value)
		get_node("Label_SurfaceHeight/Value").text = str(get_node("Label_SurfaceHeight/ChooseSurfaceHeight").value)
		
		if get_node("Label_Mode/ChooseMode").selected == 0:
			get_node("Label_Mode/Description").text = "GAMEMODE_SURVIVAL_DESCRIPTION"
			VarGlobales.WorldMode = 0
		if get_node("Label_Mode/ChooseMode").selected == 1:
			get_node("Label_Mode/Description").text = "GAMEMODE_CHEAT_DESCRIPTION"
			VarGlobales.WorldMode = 1
		if get_node("Label_Mode/ChooseMode").selected == 2:
			get_node("Label_Mode/Description").text = "GAMEMODE_VISION_DESCRIPTION"
			VarGlobales.WorldMode = 2

		VarGlobales.WorldBiome = get_node("Label_Biome/ChooseBiome").selected

		if get_node("Label_Seed/Change_Seed").pressed:
			get_node("Label_Seed/TextEdit_Seed").text = str(VarGlobales.rng.randi_range(0,99999999))+str(VarGlobales.rng.randi_range(0,9999999))

		if get_node("Label_Name/TextEdit_Name").text == "":
			get_node("CreateWorld").disabled = true
		else:
			if get_node("Label_Seed/TextEdit_Seed").text == "":
				get_node("CreateWorld").disabled = true
			else:
				get_node("CreateWorld").disabled = false

	var dir = DirAccess.open("user://Worlds")
#	dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
#	for i in 100:
#		var file = dir.get_next()
#		if get_node("Label_Name/TextEdit_Name").text == str(file):
#			get_node("CreateWorld").disabled = true
#
func _on_CreateWorld_pressed():
	MusicController.get_node("Music").stop()
	MusicController.play_select_sound()
	var dico = {"A":1,"B":2,"C":3,"D":4,"E":5,"F":6,"G":7,"H":8,"I":9,"J":10,"K":11,"L":12,"M":13,"N":14,"O":15,"P":16,"Q":17,"R":18,"S":19,"T":20,"U":21,"V":22,"W":23,"X":24,"Y":25,"Z":26,"0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9}
	var seed_transform = str(get_node("Label_Seed/TextEdit_Seed").text).to_upper()
	var seed_transformed = ""
	for lettre in seed_transform:
		for cle in dico.keys():
			if lettre == cle:
				seed_transformed += str(dico[cle])

	VarGlobales.WorldState = 0
	get_tree().change_scene_to_file("res://Scènes/WorldState.tscn")
	VarGlobales.WorldName = get_node("Label_Name/TextEdit_Name").text
	VarGlobales.WorldFile = get_node("Label_Name/TextEdit_Name").text
	VarGlobales.WorldSeed = int(seed_transformed)
	VarGlobales.WorldDimension = 1
	VarGlobales.WorldWaterLevel = get_node("Label_WaterLevel/ChooseWaterLevel").value
	VarGlobales.WorldSurfaceHeight = get_node("Label_SurfaceHeight/ChooseSurfaceHeight").value
	VarGlobales.initialisation()


func _on_Back_pressed():
	MusicController.play_select_sound()
	get_tree().change_scene_to_file("res://Scènes/Menu.tscn")


func _on_Thumbnail_mouse_entered():
	get_node("Thumbnail/Label").visible = true


func _on_Thumbnail_mouse_exited():
	get_node("Thumbnail/Label").visible = false


func _on_HSlider_value_changed(value):
	get_node("Label_size/Valeur").text = str(value)
	VarGlobales.WorldSize = value
	pass # Replace with function body.


func _on_ChoosePartymode_item_selected(index):
	VarGlobales.WorldParty = index
	if index == 1:
		get_node("Label_Biome").visible = false
		get_node("Label_Mode").visible = false
		get_node("Label_WaterLevel").visible = false
		get_node("Label_SurfaceHeight").visible = false
		get_node("Label_Seed").visible = false
	else:
		get_node("Label_Biome").visible = true
		get_node("Label_Mode").visible = true
		get_node("Label_WaterLevel").visible = true
		get_node("Label_SurfaceHeight").visible = true
		get_node("Label_Seed").visible = true
