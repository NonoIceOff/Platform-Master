extends CanvasLayer

var click_inv = 0
var selected_count = 0
var selected_inv = -1
var selected_tag = -1
var f3_menu = 0

var slot = preload("res://Slot.tscn")

func _ready():
	
	for i in range(1,9):
		var newslot = slot.instantiate()
		newslot.name = "inv_slot"+str(i)
		newslot.id = 0
		newslot.number = i-1
		add_child(newslot)
		
	for i in range(1,9):
		get_node("inv_slot"+str(i)).position.x = 1244-(36*(i-1))
		get_node("inv_slot"+str(i)).position.y = 12-8
		get_node("inv_slot"+str(i)).scale = Vector2(2,2)
	get_node("NameItem").scale = Vector2(2,2)
	get_node("NameItem").position.y = 40
	get_node("NameItem").position.x = 580
		
	if not VarGlobales.WorldMode == 2:
		for i in range(1,9):
			get_node("inv_slot"+str(i)).texture = load("res://Textures/inv_slot.png")
			if VarGlobales.inv_slot[i-1] != -1:
				get_node("inv_slot"+str(i)+"/item").texture = load(VarGlobales.inv_texture[VarGlobales.inv_slot[i-1]])
				if VarGlobales.inv_slot_count[i-1] == 1:
					get_node("inv_slot"+str(i)+"/Label").text = ""
				if VarGlobales.inv_slot_count[i-1] < 1000 and VarGlobales.inv_slot_count[i-1] >= 2:
					get_node("inv_slot"+str(i)+"/Label").text = str(VarGlobales.inv_slot_count[i-1])
				if VarGlobales.inv_slot_count[i-1] >= 1000 and VarGlobales.inv_slot_count[i-1] < 1000000:
					get_node("inv_slot"+str(i)+"/Label").text = str(VarGlobales.inv_slot_count[i-1]/1000)+"k"
				if VarGlobales.inv_slot_count[i-1] >= 1000000:
					get_node("inv_slot"+str(i)+"/Label").text = str(float(VarGlobales.inv_slot_count[i-1]/1000000))+"m"
		
		get_node("inv_slot1").texture = load("res://Textures/inv_slot_selected.png")
		
		if VarGlobales.WorldMode == 0:
			get_node("InfoLabel").position = Vector2(4,64)
	pass
	
func _process(_delta):
	
	for i in range(1,9):
		if get_node("inv_slot"+str(i)+"/Button").is_hovered() and VarGlobales.inv_slot[i-1] != -1:
			get_node("Slot_Info").visible = true
			get_node("Slot_Info/Name").text = VarGlobales.collection[str(VarGlobales.inv_slot[i-1])][1]
			if typeof(VarGlobales.inv_slot_tag[i-1]) == TYPE_STRING:
				get_node("Slot_Info/Tag/Name").text = "Tags: "+str(VarGlobales.inv_slot_tag[i-1])
				get_node("Slot_Info/Tag").visible = true
			
		if VarGlobales.inv_slot_count[i-1] == 0:
			VarGlobales.inv_slot[i-1] = -1
			VarGlobales.inv_slot_tag[i-1] = -1
			get_node("inv_slot"+str(i)+"/item").texture = null
			get_node("inv_slot"+str(i)+"/Label").text = ""
	
	var view_x = 935
	var view_y = 36
		
	if VarGlobales.inGUI < 1:
		if get_viewport().get_mouse_position().x < view_x or get_viewport().get_mouse_position().y > view_y:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				if click_inv == 1:
					VarGlobales.spawn_item(get_node("../../World").get_global_mouse_position(),selected_inv,selected_count)
					get_node("cursor_slot/item").texture = null
					get_node("cursor_slot/Label").text = ""
					selected_count = 0
					selected_inv = 0
					selected_tag = -1
					click_inv = 0
			
	if Input.is_action_just_pressed("ui_f3"):
		f3_menu += 1
		if f3_menu == 2:
			f3_menu = 0
		if f3_menu == 0:
			get_node("InfoLabel").visible = false
			get_node("SpinBox").visible = false
			get_node("../StatsPlayer/TimeLabel").visible = true
		if f3_menu == 1:
			get_node("InfoLabel").visible = true
			get_node("SpinBox").visible = true
			get_node("../StatsPlayer/TimeLabel").visible = false
	
	if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 73:		
		if get_node("InfoLabel").visible == false:
			get_node("../StatsPlayer/TimeProgress").visible = true
		else:
			get_node("../StatsPlayer/TimeProgress").visible = false
	else:
		get_node("../StatsPlayer/TimeProgress").visible = false
	
	
	if VarGlobales.inv_slot[VarGlobales.slot_selected-1] > -1:
		get_node("../CharacterBody2D/Item").texture = load(VarGlobales.collection[str(VarGlobales.inv_slot[VarGlobales.slot_selected-1])][0])
	else:
		get_node("../CharacterBody2D/Item").texture = null
	

	if VarGlobales.WorldState == 2:
		if f3_menu == 1:
			if VarGlobales.WorldMode == 2:
				get_node("SpinBox").visible = true
			get_node("InfoLabel").text = "Version : "+str(VarGlobales.VersionName)
			if not VarGlobales.WorldMode == 2:
				get_node("InfoLabel").text = get_node("InfoLabel").text+"\n\nX : "+str(floor(VarGlobales.player_positions.x/32))+" | Y : "+str(floor(VarGlobales.player_positions.y/32))
				if VarGlobales.WorldDimension == 1:
					get_node("InfoLabel").text += "\n\nChunk number "+str(floor(VarGlobales.player_positions.x/32/32))
					if floor(VarGlobales.player_positions.x/32/32) in VarGlobales.chunk_biome:
						get_node("InfoLabel").text += "\nChunk name : "+str(VarGlobales.chunk_name[VarGlobales.chunk_biome[floor(VarGlobales.player_positions.x/32/32)]])
					get_node("InfoLabel").text += "\n\nDimension : Earth"
				if VarGlobales.WorldDimension == 2:
					get_node("InfoLabel").text += "\nChunk number "+str(floor(VarGlobales.player_positions.x/32/32))
					if floor(VarGlobales.player_positions.x/32/32) in VarGlobales.chunk_biome_shadow:
						get_node("InfoLabel").text += "\nChunk name : "+str(VarGlobales.chunk_shadow_name[VarGlobales.chunk_biome_shadow[floor(VarGlobales.player_positions.x/32/32)]])
					get_node("InfoLabel").text += "\n\nDimension : Shadow"
				if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 73:
					get_node("InfoLabel").text += "\n\nTime : "
					if VarGlobales.time_hour >= 10:
						get_node("InfoLabel").text += str(VarGlobales.time_hour)
					if VarGlobales.time_hour < 10:
						get_node("InfoLabel").text += "0"+str(VarGlobales.time_hour)
					if VarGlobales.time_min >= 10:
						get_node("InfoLabel").text += ":"+str(VarGlobales.time_min)
					if VarGlobales.time_min < 10:
						get_node("InfoLabel").text += ":0"+str(VarGlobales.time_min)
					get_node("InfoLabel").text += " (Day "+str(VarGlobales.time_day)+")"
				get_node("InfoLabel").text += "\n\nMobs : "+str(int(VarGlobales.mob_caps["Sheep"])+int(VarGlobales.mob_caps["Zombie"])+int(VarGlobales.mob_caps["Bee"]))
				get_node("InfoLabel").text += "\nItems : "+str(VarGlobales.items_number)

				if not VarGlobales.item_tool[VarGlobales.inv_slot[VarGlobales.slot_selected-1]] == 0:
					if not VarGlobales.inv_slot[VarGlobales.slot_selected-1] == -1:
						get_node("InfoLabel").text = get_node("InfoLabel").text+"\n\nTool in hand : "+str(VarGlobales.tools_name[VarGlobales.item_tool[VarGlobales.inv_slot[VarGlobales.slot_selected-1]]])
						get_node("InfoLabel").text += " (level "+str(VarGlobales.tools_level[VarGlobales.item_tool_level[VarGlobales.inv_slot[VarGlobales.slot_selected-1]]])+")"
				if not get_node("../TileMap").get_cell(VarGlobales.pose_x,VarGlobales.pose_y) == -1:
					get_node("InfoLabel").text = get_node("InfoLabel").text+"\n\nBlock selected : "+str(VarGlobales.inv_name[get_node("../TileMap").get_cell(VarGlobales.pose_x,VarGlobales.pose_y)])
					get_node("InfoLabel").text += "\nTool required : "+str(VarGlobales.tools_name[VarGlobales.block_tool[get_node("../TileMap").get_cell(VarGlobales.pose_x,VarGlobales.pose_y)]])
					get_node("InfoLabel").text +=" (level "+str(VarGlobales.tools_level[VarGlobales.block_tool_level[get_node("../TileMap").get_cell(VarGlobales.pose_x,VarGlobales.pose_y)]])+")\nBlock durability : "+str(get_node("..").block_dur)
			else:
				get_node("InfoLabel").text += "\n\nCamera controls : \n"
				get_node("InfoLabel").text += "Upwards : "+str(OS.get_keycode_string(InputMap.action_get_events("ui_up")[0].keycode))+"\n"
				get_node("InfoLabel").text += "Downward : "+str(OS.get_keycode_string(InputMap.action_get_events("ui_down")[0].keycode))+"\n"
				get_node("InfoLabel").text += "To the left : "+str(OS.get_keycode_string(InputMap.action_get_events("ui_left")[0].keycode))+"\n"
				get_node("InfoLabel").text += "To the right : "+str(OS.get_keycode_string(InputMap.action_get_events("ui_right")[0].keycode))+"\n"
				get_node("InfoLabel").text += "Zoom : Mouse Scroll"
				get_node("InfoLabel").text += "\n\nCam speed : "+"\nCurrent Cam Speed : "+str(get_node("../Camera2D").cam_speed)
		else:
			if VarGlobales.WorldMode == 2:
				get_node("SpinBox").visible = false

	if VarGlobales.WorldMode == 2:
		for i in range(1,9):
			get_node("inv_slot"+str(i)).visible = false
	else:
		for i in range(1,9):
			get_node("inv_slot"+str(i)).visible = true
			
	if not VarGlobales.WorldMode == 2:
		get_node("SpinBox").visible = false
		for i in range(1,9):
			if not VarGlobales.inv_slot[i-1] == -1:
				get_node("inv_slot"+str(i)+"/item").texture = load(VarGlobales.collection[str(VarGlobales.inv_slot[i-1])][0])
				if VarGlobales.inv_slot_count[i-1] == 1:
					get_node("inv_slot"+str(i)+"/Label").text = ""
				if VarGlobales.inv_slot_count[i-1] < 1000 and VarGlobales.inv_slot_count[i-1] >= 2:
					get_node("inv_slot"+str(i)+"/Label").text = str(VarGlobales.inv_slot_count[i-1])
				if VarGlobales.inv_slot_count[i-1] >= 1000 and VarGlobales.inv_slot_count[i-1] < 100000:
					get_node("inv_slot"+str(i)+"/Label").text = str(VarGlobales.inv_slot_count[i-1]/1000)+"k"
				if VarGlobales.inv_slot_count[i-1] >= 1000000:
					get_node("inv_slot"+str(i)+"/Label").text = str(VarGlobales.inv_slot_count[i-1]/1000000)+"m"
			if VarGlobales.inv_slot[i-1] == -1:
				get_node("inv_slot"+str(i)+"/item").texture = null
				get_node("inv_slot"+str(i)+"/Label").text = ""
			
			if VarGlobales.inv_slot[VarGlobales.slot_selected-1] != -1:
				get_node("NameItem").text = str(VarGlobales.collection[str(VarGlobales.inv_slot[VarGlobales.slot_selected-1])][1])
			else:
				get_node("NameItem").text = ""
				
	##INVENTORY
		if VarGlobales.inv_slot[VarGlobales.slot_selected-1] != -1:
			get_node("inv_slot"+str(VarGlobales.slot_selected)+"/item").texture = load(VarGlobales.collection[str(VarGlobales.inv_slot[VarGlobales.slot_selected-1])][0])
			if VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] == 1:
				get_node("inv_slot"+str(VarGlobales.slot_selected)+"/Label").text = ""
			if VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] < 1000 and VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] >= 2:
				get_node("inv_slot"+str(VarGlobales.slot_selected)+"/Label").text = str(VarGlobales.inv_slot_count[VarGlobales.slot_selected-1])
			if VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] >= 1000 and VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] < 1000000:
				get_node("inv_slot"+str(VarGlobales.slot_selected)+"/Label").text = str(VarGlobales.inv_slot_count[VarGlobales.slot_selected-1]/1000)+"k"
			if VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] >= 1000000:
				get_node("inv_slot"+str(VarGlobales.slot_selected)+"/Label").text = str(VarGlobales.inv_slot_count[VarGlobales.slot_selected-1]/1000000)+"m"	
			#get_node("inv_slot"+str(VarGlobales.slot_selected)+"/Label").text = str(VarGlobales.inv_slot_count[VarGlobales.slot_selected-1])
		else:
			get_node("inv_slot"+str(VarGlobales.slot_selected)+"/item").texture = null
			get_node("inv_slot"+str(VarGlobales.slot_selected)+"/Label").text = ""
	##INVENTORY RESET SLOT
		if VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] <= 0:
			VarGlobales.inv_slot[VarGlobales.slot_selected-1] = -1
			
	if click_inv == 2:
		click_inv = 0
		
func _input(event):
	if VarGlobales.WorldMode != 2:
		if VarGlobales.inGUI < 1:
			if event is InputEventMouseButton and event.pressed:
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					for i in range(1,9):
						get_node("inv_slot"+str(i)).texture = load("res://Textures/inv_slot.png")
					if VarGlobales.slot_selected < 8:
						VarGlobales.slot_selected += 1
						get_node("inv_slot"+str(VarGlobales.slot_selected)).texture = load("res://Textures/inv_slot_selected.png")
						get_node("inv_slot"+str((VarGlobales.slot_selected-1))).texture = load("res://Textures/inv_slot.png")
				if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					for i in range(1,9):
						get_node("inv_slot"+str(i)).texture = load("res://Textures/inv_slot.png")
					if VarGlobales.slot_selected > 1:
						VarGlobales.slot_selected -= 1
						get_node("inv_slot"+str(VarGlobales.slot_selected)).texture = load("res://Textures/inv_slot_selected.png")
						get_node("inv_slot"+str((VarGlobales.slot_selected+1))).texture = load("res://Textures/inv_slot.png")


func button_inv(i):
	if VarGlobales.inv_slot[i] == -1 and selected_inv == -1:
		click_inv = 2
	if VarGlobales.inv_slot_cooldown_max[i] == -1:
		VarGlobales.click_slot = 0
		if click_inv == 1:
			if VarGlobales.inv_slot[i] == selected_inv:
				VarGlobales.inv_slot_count[i] = VarGlobales.inv_slot_count[i] + selected_count
				click_inv = 2
				get_node("cursor_slot/item").texture = null
				get_node("cursor_slot/Label").text = ""
				selected_count = 0
				selected_inv = 0
				selected_tag = -1
			elif VarGlobales.inv_slot[i] == -1:
				VarGlobales.inv_slot[i] = selected_inv
				VarGlobales.inv_slot_count[i] = selected_count
				VarGlobales.inv_slot_tag[i] = selected_tag
				click_inv = 2
				get_node("cursor_slot/item").texture = null
				get_node("cursor_slot/Label").text = ""
				selected_count = 0
				selected_inv = 0
				selected_tag = -1
			elif VarGlobales.inv_slot[i] != -1:
				var temp_slot = VarGlobales.inv_slot[i]
				var temp_count = VarGlobales.inv_slot_count[i]
				var temp_tag = VarGlobales.inv_slot_tag[i]
				VarGlobales.inv_slot[i] = selected_inv
				VarGlobales.inv_slot_count[i] = selected_count
				VarGlobales.inv_slot_tag[i] = selected_tag
				selected_count = temp_count
				selected_inv = temp_slot
				selected_tag = temp_tag
				get_node("cursor_slot/item").texture = load(VarGlobales.collection[str(selected_inv)][0])
				get_node("cursor_slot/item").modulate.a = 0.75
				if VarGlobales.inv_slot_count[i] > 1:
					get_node("cursor_slot/Label").text = str(selected_count)
				else:
					get_node("cursor_slot/Label").text = ""
				get_node("cursor_slot/Label").modulate.a = 0.75
				click_inv = 1
			
		if click_inv == 0:
			if get_node("../CanvasLayer_GUI/BackPackGUI").visible == true or get_node("../CanvasLayer_GUI/ChestGUI").visible == true :
				if VarGlobales.inv_slot[i] != 77:
					if get_node("cursor_slot/Label").text != null and VarGlobales.inv_slot[i] != -1:
						get_node("cursor_slot/item").texture = load(VarGlobales.collection[str(VarGlobales.inv_slot[i])][0])
						get_node("cursor_slot/item").modulate.a = 0.75
						if VarGlobales.inv_slot_count[i] > 1:
							get_node("cursor_slot/Label").text = str(VarGlobales.inv_slot_count[i])
						else:
							get_node("cursor_slot/Label").text = ""
						get_node("cursor_slot/Label").modulate.a = 0.75
						selected_inv = VarGlobales.inv_slot[i]
						selected_count = VarGlobales.inv_slot_count[i]
						selected_tag = VarGlobales.inv_slot_tag[i]
						VarGlobales.inv_slot[i] = -1
						VarGlobales.inv_slot_count[i] = 0
						VarGlobales.inv_slot_tag[i] = -1
						click_inv = 1
			else:
				if get_node("cursor_slot/Label").text != null and VarGlobales.inv_slot[i] != -1:
					get_node("cursor_slot/item").texture = load(VarGlobales.collection[str(VarGlobales.inv_slot[i])][0])
					get_node("cursor_slot/item").modulate.a = 0.75
					if VarGlobales.inv_slot_count[i] > 1:
						get_node("cursor_slot/Label").text = str(VarGlobales.inv_slot_count[i])
					else:
						get_node("cursor_slot/Label").text = ""
					get_node("cursor_slot/Label").modulate.a = 0.75
					selected_inv = VarGlobales.inv_slot[i]
					selected_count = VarGlobales.inv_slot_count[i]
					selected_tag = VarGlobales.inv_slot_tag[i]
					VarGlobales.inv_slot[i] = -1
					VarGlobales.inv_slot_count[i] = 0
					VarGlobales.inv_slot_tag[i] = -1
					click_inv = 1
					
		if click_inv == -1:
			click_inv = 0
