extends Control

func _ready():
	get_node("Name/ColorPickerButton").text = VarGlobales.nickname
	get_node("Player/Nick").text = VarGlobales.nickname
	get_node("NameColor/ColorPickerButton").color = VarGlobales.color_nickmane
	get_node("Player/Nick").self_modulate = VarGlobales.color_nickmane
	
	get_node("HairColor/HairButton").color = VarGlobales.color_hair
	get_node("Player/Hair").self_modulate = VarGlobales.color_hair
	
	get_node("TShirtColor/TShirtButton").color = VarGlobales.color_tshirt
	get_node("Player/TShirt").self_modulate = VarGlobales.color_tshirt
	
	get_node("LegsColor/LegsButton").color = VarGlobales.color_legs
	get_node("Player/Legs").self_modulate = VarGlobales.color_legs
	
	get_node("Player/Hair").animation = "Hair"+str(VarGlobales.skin_hair_style)
	
	get_node("Player/Head").texture = load("res://Textures/Personnage/Heads/"+str(VarGlobales.skin_head_shape)+".png")

func _on_Back_pressed():
	get_tree().change_scene_to_file("res://Scènes/Settings.tscn")
	MusicController.play_select_sound()
	VarGlobales.save_options()

func _on_ColorPickerButton_text_changed(new_text):
	VarGlobales.nickname = new_text
	get_node("Player/Nick").text = new_text

func _on_ColorPickerButton_color_changed(color):
	VarGlobales.color_nickmane = color
	get_node("Player/Nick").self_modulate = color


func _on_HairButton_color_changed(color):
	VarGlobales.color_hair = color
	get_node("Player/Hair").self_modulate = color


func _on_TShirtButton_color_changed(color):
	VarGlobales.color_tshirt = color
	get_node("Player/TShirt").self_modulate = color


func _on_LegsButton_color_changed(color):
	VarGlobales.color_legs = color
	get_node("Player/Legs").self_modulate = color
