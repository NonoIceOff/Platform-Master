extends Control

func _ready():
	#get_node("MainMenu/Camera2D/Player/Nick").text = VarGlobales.nickname
	#get_node("MainMenu/Camera2D/Player/Nick").self_modulate = VarGlobales.color_nickmane
	get_node("MainMenu/Camera2D/Player/Hair").self_modulate = VarGlobales.color_hair
	get_node("MainMenu/Camera2D/Player/TShirt").self_modulate = VarGlobales.color_tshirt
	get_node("MainMenu/Camera2D/Player/Legs").self_modulate = VarGlobales.color_legs
	get_node("MainMenu/Camera2D/Player/Hair").animation = "Hair"+str(VarGlobales.skin_hair_style)
	get_node("MainMenu/Camera2D/Player/Head").texture = load("res://Textures/Personnage/Heads/"+str(VarGlobales.skin_head_shape)+".png")
	
	
	get_window().set_title("Platform Master "+str(VarGlobales.VersionName))
	get_node("MainMenu/VersionName").text = "Platform Master "+VarGlobales.VersionName
	if VarGlobales.demo == 1:
		get_node("MainMenu/Multiplayer").disabled = true
		get_node("MainMenu/Multiplayer").icon = load("res://Textures/lock.png")
		get_node("MainMenu/pm/Background").visible = true

