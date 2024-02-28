extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("CheckBox_particules").button_pressed = VarGlobales.particules
	get_node("CheckBox_shadows").button_pressed = VarGlobales.shadows
	get_node("Label_FOV/HSlider").value = VarGlobales.fov
	
	for i in VarGlobales.resolutions.size():
		get_node("Label_Resolution/ChangeResolutions").add_item(str(VarGlobales.resolutions[i][0]," x ",VarGlobales.resolutions[i][1]))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if visible == true:
		get_node("Label_FOV/Val").text = str(get_node("Label_FOV/HSlider").value)
		VarGlobales.fov = get_node("Label_FOV/HSlider").value
		VarGlobales.particules = get_node("CheckBox_particules").button_pressed
		VarGlobales.shadows = get_node("CheckBox_shadows").button_pressed
		
		
	pass


func _on_Back_pressed():
	get_tree().change_scene_to_file("res://Scènes/Settings.tscn")
	MusicController.play_select_sound()
	VarGlobales.save_options()
	pass # Replace with function body.


func _on_CheckBox_fullscreen_pressed():
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (get_node("CheckBox_fullscreen").pressed) else Window.MODE_WINDOWED
	VarGlobales.fullscreen = get_node("CheckBox_fullscreen").pressed
	pass # Replace with function body.


func _on_ChangeResolutions_item_selected(index):
	VarGlobales.resolution = VarGlobales.resolutions[index]
	get_window().size = Vector2(VarGlobales.resolution[0],VarGlobales.resolution[1])
	pass # Replace with function body.
