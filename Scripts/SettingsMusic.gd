extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Label_Master/HSlider").value = VarGlobales.effects_volume
	get_node("Label_Player/HSlider").value = VarGlobales.player_volume
	get_node("Label_Blocks/HSlider").value = VarGlobales.blocks_volume
	get_node("Label_Music/HSlider").value = VarGlobales.music_volume
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if visible == true:
		get_node("Label_Master").text = "EFFECTS VOLUME"
		get_node("Label_Master/Val").text = str((get_node("Label_Master/HSlider").value+80)*1.25)
		VarGlobales.effects_volume = get_node("Label_Master/HSlider").value
		
		
		get_node("Label_Player").text = "PLAYER VOLUME"
		get_node("Label_Player/Val").text = str((get_node("Label_Player/HSlider").value+80)*1.25)
		VarGlobales.player_volume = get_node("Label_Player/HSlider").value
		
		get_node("Label_Blocks").text = "BLOCKS VOLUME"
		get_node("Label_Blocks/Val").text = str((get_node("Label_Blocks/HSlider").value+80)*1.25)
		VarGlobales.blocks_volume = get_node("Label_Blocks/HSlider").value
		
		get_node("Label_Music").text = "MUSIC VOLUME"
		get_node("Label_Music/Val").text = str((get_node("Label_Music/HSlider").value+80)*1.25)
		VarGlobales.music_volume = get_node("Label_Music/HSlider").value
	pass

func _on_Back_pressed():
	get_tree().change_scene_to_file("res://Scènes/Settings.tscn")
	MusicController.play_select_sound()
	VarGlobales.save_options()

func _on_PlayerDown_pressed():
	if VarGlobales.player_volume > -80:
		VarGlobales.player_volume -= 10
		MusicController.play_select_down_sound()

func _on_PlayerUp_pressed():
	if VarGlobales.player_volume < 0:
		VarGlobales.player_volume += 10
		MusicController.play_select_up_sound()

func _on_BlocksDown_pressed():
	if VarGlobales.blocks_volume > -80:
		VarGlobales.blocks_volume -= 10
		MusicController.play_select_down_sound()

func _on_BlocksUp_pressed():
	if VarGlobales.blocks_volume < 0:
		VarGlobales.blocks_volume += 10
		MusicController.play_select_up_sound()

func _on_MusicDown_pressed():
	if VarGlobales.music_volume > -80:
		VarGlobales.music_volume -= 10
		MusicController.play_select_down_sound()

func _on_MusicUp_pressed():
	if VarGlobales.music_volume < 0:
		VarGlobales.music_volume += 10
		MusicController.play_select_up_sound()
