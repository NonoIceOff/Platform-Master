extends Control

func _ready():
	get_node("Music").stream = load("res://Sounds/TitleMusic.mp3")
	get_node("Music").play()
	pass # Replace with function body.
