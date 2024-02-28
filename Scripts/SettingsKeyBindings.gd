extends Control

var key_changed = ""
var key_name = ""

func _on_Back_pressed():
	get_tree().change_scene_to_file("res://Scènes/Settings.tscn")
	MusicController.play_select_sound()
	
	VarGlobales.save_options()
	pass # Replace with function body.

func _ready():
	print(InputMap.get_actions())

func _input(event):
	if event is InputEventKey:
		if key_name != "":
			change_key(event,key_changed)

func change_key(new_key,i):
	var action_string = i
	InputMap.action_erase_event(action_string, InputMap.action_get_events(action_string)[0])
	InputMap.action_add_event(action_string, new_key)
	get_node("ScrollContainer/VBoxContainer3/VBoxContainer1/"+str(key_name)+"/"+str(key_name)).text = str(new_key)
	key_name = ""

func easeInCubic(x):
	return lerp(x, 0-8, 0.05)
	
func easeOutCubic(x):
	return lerp(x, 0, 0.05)

func _on_left_pressed():
	button_pressed("Left","ui_left")

func _on_right_pressed():
	button_pressed("Right","ui_right")

func _on_sprint_pressed():
	button_pressed("Sprint","ui_ctrl")

func _on_jump_pressed():
	button_pressed("Jump","ui_jump")

func _on_inventory_pressed():
	button_pressed("Inventory","ui_e")

func _on_armors_pressed():
	button_pressed("Armors","ui_i")

func _on_chat_pressed():
	button_pressed("Chat","ui_chat")

func _on_f_3_pressed():
	button_pressed("F3","ui_f3")

func _on_drop_pressed():
	button_pressed("Drop","ui_drop")

func button_pressed(but_name,key_change):
	key_changed = key_change
	key_name = but_name
	get_node("ScrollContainer/VBoxContainer3/VBoxContainer1/"+str(but_name)+"/"+str(but_name)).text = "Press any key"
