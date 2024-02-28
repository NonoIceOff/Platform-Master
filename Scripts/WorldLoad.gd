extends Control

var world = preload("res://Scènes/World.tscn")

func _process(_delta):
	if visible == true:
		get_node("HBoxContainer/WorldInfos").text =  "\nWorld Name : "+str(VarGlobales.WorldName)+"\nWorld Seed : "+str(VarGlobales.WorldSeed)+"\nGame Mode : "+str(VarGlobales.WorldMode)
	pass
