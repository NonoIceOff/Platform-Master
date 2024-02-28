extends Control

func _ready():
	if OS.get_name() == "Android":
		get_node("Play").position = Vector2(384-128+4,444-64)
		get_node("Play").scale = Vector2(1.5,1.5)
		get_node("Play").hover = 0
		get_node("Multiplayer").position = Vector2(384-128+4,516+32-64)
		get_node("Multiplayer").scale = Vector2(1.5,1.5)
		get_node("Multiplayer").hover = 0
		get_node("Settings").position = Vector2(384-128+4,588+64-64)
		get_node("Settings").scale = Vector2(1.5,1.5)
		get_node("Settings").hover = 0

func _process(_delta):
	if visible == false:
		if OS.get_name() == "Android":
			get_node("Play").position = Vector2(384,444)
			get_node("Play").scale = Vector2(2,2)
			get_node("Play").hover = 0
			get_node("Multiplayer").position = Vector2(384,516)
			get_node("Multiplayer").hover = 0
			get_node("Settings").position = Vector2(384,588)
			get_node("Settings").hover = 0
		else:
			get_node("Play").position = Vector2(384-128+4,444-64)
			get_node("Play").scale = Vector2(1.5,1.5)
			get_node("Play").hover = 0
			get_node("Multiplayer").position = Vector2(384-128+4,516+32-64)
			get_node("Multiplayer").scale = Vector2(1.5,1.5)
			get_node("Multiplayer").hover = 0
			get_node("Settings").position = Vector2(384-128+4,588+64-64)
			get_node("Settings").scale = Vector2(1.5,1.5)
			get_node("Settings").hover = 0
	else:
		get_node("CPUParticles2D").visible = VarGlobales.particules

func _on_Play_pressed():
	get_tree().change_scene_to_file("res://Scènes/WorldsMenu.tscn")
	MusicController.play_select_sound()

func _on_Settings_pressed():
	get_tree().change_scene_to_file("res://Scènes/Settings.tscn")
	MusicController.play_select_sound()

func _on_Multiplayer_pressed():
	get_tree().change_scene_to_file("res://Scènes/Multiplayer.tscn")
	MusicController.play_select_sound()


func _on_Quit_pressed():
	get_tree().quit()
