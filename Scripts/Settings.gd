extends Control

func _ready():
	if VarGlobales.demo == 1:
		get_node("Apparences").disabled = true
		get_node("Apparences").icon = load("res://Textures/lock.png")

func _on_Back_pressed():
	get_tree().change_scene_to_file("res://Scènes/Menu.tscn")
	MusicController.play_select_sound()

func _on_Music_pressed():
	get_tree().change_scene_to_file("res://Scènes/SettingsSounds.tscn")
	MusicController.play_select_sound()

func _on_Video_pressed():
	get_tree().change_scene_to_file("res://Scènes/SettingsVideo.tscn")
	MusicController.play_select_sound()

func _on_KeyBindings_pressed():
	get_tree().change_scene_to_file("res://Scènes/SettingsKeyBindings.tscn")
	MusicController.play_select_sound()

func _on_Languages_pressed():
	get_tree().change_scene_to_file("res://Scènes/SettingsLanguages.tscn")
	MusicController.play_select_sound()


func _on_Apparences_pressed():
	get_tree().change_scene_to_file("res://Scènes/SettingsApparences.tscn")
	MusicController.play_select_sound()
