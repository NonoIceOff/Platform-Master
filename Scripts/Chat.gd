extends LineEdit

var id_message = -1
var id_message_supr = 0
var timer_duration = 500
var timer_supr = timer_duration

func _process(delta):
	if get_node_or_null("../../CanvasLayer/ChatBox/Message"+str(id_message_supr)) != null:
		timer_supr -= 1
		if timer_supr < timer_duration:
			pass
			#get_node("../../CanvasLayer/ChatBox/Message"+str(id_message_supr)).self_modulate = Color(0,0,0,timer_supr/2)/timer_duration
			#get_node("../../CanvasLayer/ChatBox/Message"+str(id_message_supr)+"/Content").self_modulate = Color(timer_duration,timer_duration,timer_duration,timer_supr)/timer_duration
		if timer_supr <= 0:
			get_node("../../CanvasLayer/ChatBox/Message"+str(id_message_supr)).queue_free()
	if timer_supr <= 0:
		if id_message > id_message_supr:
			id_message_supr += 1
			timer_supr = timer_duration

func _on_Chat_text_entered(new_text):
	new_message(new_text,VarGlobales.nickname,VarGlobales.color_nickmane.to_html())
	detect_command(new_text)
	
	text = ""
	VarGlobales.inGUI += 1

func detect_command(new_text):
	var valid = 0
	if str(new_text).begins_with("/"):
		if VarGlobales.demo == 1:
			new_message("The commands are only activated in the full version of the game.","Platform Master","9900ff")
		else:
			var command_text = command_arguments(new_text)
			
			if str(command_text[0]).begins_with("/help"):
				new_message("- [color=#ff0000]/help[/color] | Show all commands and explainations\n- [color=#ff0000]/give[/color] | Give items or blocks to player\n- [color=#ff0000]/mode[/color] | Change game mode\n- [color=#ff0000]/clear[/color] | Clear your inventory\n- [color=#ff0000]/seed[/color] | Show the world's seed\n- [color=#ff0000]/summon[/color] | Summon a mob\n- [color=#ff0000]/coordinates[/color] | teleport to coordinates\n- [color=#ff0000]/players[/color] | Get numbers of players in the world","/help","9900ff")
				
			elif str(command_text[0]).begins_with("/give"):
				if command_text.size() < 3 or command_text.size() > 3:
					new_message("Invalid arguments : /give (id) (number)","/give","9900ff")
					
				if command_text.size() == 3:
					## Check if id struct is valud
					if command_text[1].is_valid_int() == true and command_text[2].is_valid_int() == true:
						valid = 1
					else:
						valid = 0
					## If id exists
					if valid == 1:
						if int(command_text[1]) > VarGlobales.inv_name.size()-1 or int(command_text[1]) < 0:
							valid = 0
					if valid == 1:
						new_message("Gived "+command_text[2]+" "+str(VarGlobales.inv_name[int(command_text[1])]),str(command_text[0]),"9900ff")
						VarGlobales.spawn_item(VarGlobales.player_positions ,int(command_text[1]), int(command_text[2]))
					else:
						new_message("Invalid id "+str(command_text[1]),str(command_text[0]),"9900ff")
						
			elif str(command_text[0]).begins_with("/summon"):
				if command_text.size() < 5 or command_text.size() > 5:
					new_message("Invalid arguments : /summon (id) (x) (y) (health)","/summon","9900ff")
					
				if command_text.size() == 5:
					## Check if id struct is valud
					if command_text[1].is_valid_int() == true and command_text[2].is_valid_int() == true and command_text[3].is_valid_int() == true and command_text[4].is_valid_int() == true:
						valid = 1
					else:
						valid = 0
					## If id exists
					if valid == 1:
						if int(command_text[1]) > VarGlobales.mob_names.size()-1 or int(command_text[1]) < 0:
							valid = 0
					if valid == 1:
						new_message("Summoned " + str(VarGlobales.mob_names[int(command_text[1])]), command_text[0],"9900ff")
						VarGlobales.spawn_mob(Vector2(int(command_text[2]),int(command_text[3]))*32 ,int(command_text[1]), int(command_text[4]))
					else:
						new_message("Invalid mob "+str(command_text[1]),str(command_text[0]),"9900ff")
						
			elif str(command_text[0]).begins_with("/coordinates"):
				if command_text.size() < 3 or command_text.size() > 3:
					new_message("Invalid arguments : /coordinates (x) (y)","/coordinates","9900ff")
					
				if command_text.size() == 3:
					## Check if id struct is valud
					if command_text[1].is_valid_int() == true and command_text[2].is_valid_int() == true:
						valid = 1
					else:
						valid = 0
					if valid == 1:
						new_message("Teleported you to "+str(command_text[1])+", "+str(command_text[2]), command_text[0],"9900ff")
						if VarGlobales.Multiplayer == -1:
							get_node("../../CharacterBody2D").position = Vector2(int(command_text[1]),int(command_text[2]))*32
						else:
							get_node("/root/PersistentNodes/"+str(get_tree().get_unique_id())).position = Vector2(int(command_text[1]),int(command_text[2]))*32
					else:
						new_message("Invalid coordinates","/coordinates","9900ff")
						
			elif str(command_text[0]).begins_with("/mode"):
				if command_text.size() < 2 or command_text.size() > 2:
					new_message("Invalid arguments : /mode (survival|cheat|vision)","/mode","9900ff")
				elif not command_text[1] == "survival" or command_text[1] == "cheat" or command_text[1] == "vision":
					new_message("Invalid arguments : /mode (survival|cheat|vision)","/mode","9900ff")
					
				if command_text.size() == 2:
					## Check if id struct is valud
					if command_text[1] == "survival" or command_text[1] == "cheat" or command_text[1] == "vision":
						valid = 1
					else:
						valid = 0
					if valid == 1:
						new_message("Changed mode to "+command_text[1],str(command_text[0]),"9900ff")
						VarGlobales.WorldMode = VarGlobales.Mode[command_text[1]]
						get_node("../../CharacterBody2D/Camera2D").zoom.x = VarGlobales.fov
						get_node("../../CharacterBody2D/Camera2D").zoom.y = VarGlobales.fov
						get_node("../../CharacterBody2D/Camera2D").position = Vector2(-125,88)
						get_node("../../CharacterBody2D/Camera2D").offset = Vector2(0,0)
					else:
						new_message("Invalid mode "+str(command_text[1]),str(command_text[0]),"9900ff")
						
			elif str(command_text[0]).begins_with("/clear"):
				if command_text.size() < 1 or command_text.size() > 1:
					new_message("Invalid arguments : /clear","/clear","9900ff")
				if command_text.size() == 1:
					new_message("Cleared your inventory",str(command_text[0]),"9900ff")
					VarGlobales.inv_slot = [-1,-1,-1,-1,-1,-1,-1,-1]
					VarGlobales.inv_slot_count = [0,0,0,0,0,0,0,0]
					VarGlobales.inv_slot_tag = [-1,-1,-1,-1,-1,-1,-1,-1]
					
			elif str(command_text[0]).begins_with("/seed"):
				if command_text.size() < 1 or command_text.size() > 1:
					new_message("Invalid arguments : /seed","/seed","9900ff")
				if command_text.size() == 1:
					new_message("World's seed : "+str(VarGlobales.WorldSeed),str(command_text[0]),"9900ff")
					
			elif str(command_text[0]).begins_with("/players"):
				if command_text.size() < 1 or command_text.size() > 1:
					new_message("Invalid arguments : /players","/players","9900ff")
				if command_text.size() == 1:
					var array_players = get_node("/root/PersistentNodes").get_children()
					var array_players_valid = []
					for i in array_players.size():
						if str(array_players[i]).begins_with("Mob") == false and str(array_players[i]).begins_with("Item") == false:
							array_players_valid.append(array_players[i])
					if VarGlobales.Multiplayer == -1:
						array_players_valid.append("Solo")
					
					new_message("Players online : "+str(array_players_valid.size()),"/players","9900ff")
				
			else:
				new_text[0] = ""
				new_message("Command "+str(command_text[0])+" doesn't exists","Platform Master","9900ff")
			VarGlobales.inGUI += 1

@rpc("any_peer", "call_local") func multiplayer_new_message(settings):
	new_message(settings[0], settings[1],settings[2])

func command_arguments(text_command):
	var args = str(text_command).to_lower()
	args = args.split(" ")
	print(args)
	return args
	
func new_message(text, author, color):
	if not str(text).begins_with("/"):
		id_message += 1
		
		var message = ColorRect.new()
		message.custom_minimum_size = Vector2(520, 40)
		message.name = "Message"+str(id_message)
		message.material = load("res://shaderflou.tres")
		message.material.set("shader_param/ScalarUniform", 2)
		
		var content = RichTextLabel.new()
		content.custom_minimum_size = Vector2(520, 40)
		content.scroll_following = true
		content.name = "Content"
		content.bbcode_enabled = true
		content.text = "[color=#"+color+"][u][b]"+str(author)+"[/b][/u][/color]\n"+str(text)
#		content.bbcode_text = "[color=#9900ff][u][b]"+str(author)+"[/b][/u][/color]\n"+str(text)
		content.text = str(author)+"\n	"+str(text)
		content.selection_enabled = true
		content.set("theme_override_constants/shadow_offset_y", 1)
		content.set("theme_override_colors/font_shadow_color", Color(0,0,0,0.5))
		message.add_child(content)
		
		var contentsize = RichTextLabel.new()
		contentsize.custom_minimum_size = Vector2(520, 40)
		contentsize.scroll_following = true
		contentsize.fit_content_height = true
		contentsize.name = "ContentSize"
		contentsize.text = str(author)+"\n	"+str(text)
		contentsize.visible = false
		message.add_child(contentsize)
		
		var test = 40+20*(floor(contentsize.get_minimum_size().y/900))
		message.custom_minimum_size.y = test
		
		get_tree().current_scene.get_node("CanvasLayer/ChatBox").add_child(message)
