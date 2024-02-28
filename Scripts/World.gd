extends Node2D

var rng = RandomNumberGenerator.new()
var item = preload("res://Scènes/Item.tscn")

var grass_test = FastNoiseLite.new()
var caves = FastNoiseLite.new()
var ore = FastNoiseLite.new()
var tree = FastNoiseLite.new()
var biomenoise = FastNoiseLite.new()

var index = 0

var ranbiome = 0

var world_depth = 128
var surface_height = VarGlobales.WorldSurfaceHeight
var biome_surface_height = 16
var chunk_width = 16
var block_dur = 5
var pose_block = 0
var pose_timing = 0
#var 0 = 0
var block_chunk = 0
var gentree = 1
var genpics = 1

#colors background
var red = 0.25
var green = 0.53
var blue = 0.76
var red_now = 0.25
var green_now = 0.53
var blue_now = 0.76

var set_file = 0
var filesave2 = ConfigFile.new()

var timer_water = 0
var pos_avant = 0

var pose_x = floor(get_local_mouse_position().x/16)
var pose_y = floor(get_local_mouse_position().y/16)
var posevar_x = VarGlobales.player_positions.x/16
var posevar_y = VarGlobales.player_positions.y/16

var player = load("res://Scènes/Player.tscn")
var chunk = load("res://Chunk.tscn")

var clickmode = -1
var clicktest = -1

var tilemap = "TileMap"

@export var num_of_blocks_near := 3
@export var max_num_of_blocks_nearby := 8

var light_position = Vector2(0, 0)

var show_results = load("res://show_results.tscn")

func _ready():
		
	Generation.tilemap = "/root/World/TileMap"
	Generation.tilemap_torch = "/root/World/TileMapLigths_Torchs"
	Generation.tilemap_lights = "/root/World/TileMapLights"

	if VarGlobales.WorldState == 0:
		if VarGlobales.WorldParty == 0:
			VarGlobales.LoadedRegions["Chunk"+str(0)] = 1
			for i in range(-2,3):
				VarGlobales.LoadedRegions["Chunk"+str(i)] = 1
				await Generation.gen_world(i,1)
		else:
			for x in range(-2,3):
				for y in range(0,5):
					set_cell(x,y,y,get_node(tilemap))
					if y >= 3:
						set_cell(x,y,2,get_node(tilemap))
			await Generation.spawn_oak_tree(-1,0)
			set_cell(2,-1,126,get_node(tilemap))
		get_node("CharacterBody2D").position = VarGlobales.spawnpoint
		await get_tree().create_timer(0.1).timeout
		VarGlobales.WorldState = 2
		MusicController.play_init_sound()
			
	VarGlobales.inGUI = 0
	clickmode = -1
	get_node("Camera2D").zoom = Vector2(VarGlobales.fov,VarGlobales.fov)
	
	if VarGlobales.WorldState == 1:
		load_world()
		
	if VarGlobales.WorldMode >= 1:
		get_node("CanvasLayer/HBoxContainer").position.x = 8

func get_cell(a, b, node):
	var coords = node.get_cell_atlas_coords(0, Vector2(a, b), false)
	var id = coords.y * 11 + coords.x
	if id < -1:
		return -1
	return id
	
func set_cell(a, b, id, node):
	if id in [116,120,124,128,132]:
		place_door(id,pose_x,pose_y,node)
	elif id != -1:
		var coordinates = id_to_coords(id)
		node.set_cell(0, Vector2(a, b), 0, Vector2i(coordinates.x, coordinates.y))
	else:
		if id in [10,11,147,148,149,150]:
			place_liquid(a,b,id)
	
		node.set_cell(0, Vector2(a, b), 0, Vector2i(-1, -1))

func id_to_coords(j):
	var tilesPerRow = 11  # Nombre de tuiles par ligne
	var x = j % tilesPerRow
	var y = j / tilesPerRow
	return Vector2(x, y)

func top_y(x):
	var top = -1
	var y = world_depth
	while top == -1:
		if get_cell(x,y,get_node(tilemap)) == -1:
			return y
		else:
			y -= 1
	return top

func wait(sec):
	var t = Timer.new()
	t.set_wait_time(sec)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await t.timeout
	t.queue_free()

func place_liquid(x, y, id):
	var existing_id = get_cell(x, y, get_node("TileMap"))
	if existing_id != -1:
		return  # Ne place pas de liquide s'il y a déjà quelque chose à cet endroit

	set_cell(x, y, id, get_node("TileMap"))
	propagate_liquid(Vector2(x, y), id)

func propagate_liquid(pos, id):
	var x = int(pos.x)
	var y = int(pos.y)

	var neighbors = [
		Vector2(x - 1, y),
		Vector2(x + 1, y),
		Vector2(x, y - 1),
		Vector2(x, y + 1)
	]

	for neighbor in neighbors:
		var nx = int(neighbor.x)
		var ny = int(neighbor.y)

		var existing_id = get_cell(nx, ny, get_node("TileMap"))
		if existing_id == -1:
			set_cell(nx, ny, id, get_node("TileMap"))
			propagate_liquid(Vector2(nx, ny), id)

func refresh_blocks():
	pass

func check_teleportation():
	if VarGlobales.Teleportation == 2: ##Teleportation Earth
		VarGlobales.Teleportation = -1
		VarGlobales.WorldDimension = 1
		if VarGlobales.achievements_completed[15] == 0:
			VarGlobales.new_achievement(15)
			
		get_node("CanvasLayer/TextureRect").visible = true
		get_node("CanvasLayer/TextureRect").texture = load("res://Textures/Blocks/shaded_portal.png")
		get_node("CanvasLayer/TextureRect").material = load("res://Shaders/tp/tp_dirt.tres")
		get_node("CanvasLayer/TextureRect/loadworld").text = "Teleportation in progress"
		get_node("CanvasLayer/TextureRect/loadinfos").text = "Earth"
		await get_tree().create_timer(0.1).timeout
		get_node(tilemap).clear()
		get_node("TileMapLights").clear()
		get_node("TileMapLights_Torchs").clear()
		if FileAccess.file_exists(str("user://Worlds/"+str(VarGlobales.WorldFile)+"/Earth/Infos.txt")) == false and VarGlobales.WorldParty == 0:
			var chunk_now = get_node("CharacterBody2D").position.x/16/16
			for i in range(-2+chunk_now,3+chunk_now):
				VarGlobales.LoadedRegions["Chunk"+str(i)] = 1
				await Generation.gen_world(i,1)
			VarGlobales.LoadedTimes = 1
			VarGlobales.WorldState = 2
			VarGlobales.Teleportation = 0
			get_node("CanvasLayer/TextureRect").visible = false
		else:
			load_world()
		VarGlobales.inGUI = 0
	
	if VarGlobales.Teleportation == 4: ##Teleportation Shadow
		VarGlobales.Teleportation = -1
		VarGlobales.WorldDimension = 2
#		if VarGlobales.achievements_completed[15] == 0:
#			VarGlobales.new_achievement(15)
#		get_node("CanvasLayer/TextureRect").visible = true
#		get_node("CanvasLayer/TextureRect").texture = load("res://Textures/Blocks/shaded_portal.png")
#		get_node("CanvasLayer/TextureRect").material = load("res://Shaders/tp/tp_dirt.tres")
#		get_node("CanvasLayer/TextureRect/loadworld").text = "Teleportation in progress"
#		get_node("CanvasLayer/TextureRect/loadinfos").text = "Shadow"
#		await get_tree().create_timer(0.1).timeout
#		get_node(tilemap).clear()
#		get_node("TileMapLights").clear()
#		get_node("TileMapLights_Torchs").clear()
#		if FileAccess.file_exists("user://Worlds/"+str(VarGlobales.WorldFile)+"/Shadow/Infos.txt") == false:
#			var chunk_now = get_node("CharacterBody2D").position.x/16/16
#			for i in range(-2+chunk_now,3+chunk_now):
#				VarGlobales.LoadedRegions["Chunk"+str(i)] = 1
#				gen_shadow(i)
#			gen_shadow(-2)
#			VarGlobales.LoadedRegions["Chunk"+str(-2)] = 1
#			gen_shadow(-1)
#			VarGlobales.LoadedRegions["Chunk"+str(-1)] = 1
#			gen_shadow(0)
#			VarGlobales.LoadedRegions["Chunk"+str(0)] = 1
#			gen_shadow(1)
#			VarGlobales.LoadedRegions["Chunk"+str(1)] = 1
#			gen_shadow(2)
#			VarGlobales.LoadedRegions["Chunk"+str(2)] = 1
#			VarGlobales.LoadedTimes = 1
#			VarGlobales.WorldState = 2
#			VarGlobales.Teleportation = 0
#			get_node("CanvasLayer/TextureRect").visible = false
#		else:
#			load_world()
		VarGlobales.inGUI = 0

func blocks_preview():
	pose_x = floor(get_local_mouse_position().x/16)
	pose_y = floor(get_local_mouse_position().y/16)
	posevar_x = VarGlobales.player_positions.x/16
	posevar_y = VarGlobales.player_positions.y/16

	get_node("TileMapPlacement").clear()
	if VarGlobales.inv_slot[VarGlobales.slot_selected-1] != -1:
		if VarGlobales.collection[str(VarGlobales.inv_slot[VarGlobales.slot_selected-1])][9] != -1:
			if posevar_x+7*(VarGlobales.potions_active[8]+1) > pose_x and posevar_x-7*(VarGlobales.potions_active[8]+1) < pose_x and posevar_y+7*(VarGlobales.potions_active[8]+1) > pose_y and posevar_y-7*(VarGlobales.potions_active[8]+1) < pose_y:
				if Vector2(posevar_x,posevar_y) != Vector2(pose_x,pose_y):
					if Vector2(posevar_x,posevar_y-1) != Vector2(pose_x,pose_y):
						if pose_y < 128:
							set_cell(pose_x,pose_y,VarGlobales.inv_slot[VarGlobales.slot_selected-1],get_node("TileMapPlacement"))

func check_achievement():
	## Détecter si un achievement à été effectué
	for i in VarGlobales.achievements_title.size():
		if VarGlobales.achivements_max_value[i] != 0:
			if VarGlobales.achivements_value[i] >= VarGlobales.achivements_max_value[i]:
				VarGlobales.new_achievement(i)

func refresh_time():
	##Times
	var multiplier = 1
	VarGlobales.time_sec += 1.2*multiplier
	VarGlobales.time_tick += 1.2*multiplier
	if VarGlobales.time_sec >= 60:
		VarGlobales.time_min += 1
		VarGlobales.time_sec = 0
	if VarGlobales.time_min >= 60:
		VarGlobales.stats_value[13] += 0.01334
		VarGlobales.time_hour += 1
		VarGlobales.time_min = 0
	if VarGlobales.time_hour >= 24:
		VarGlobales.stats_value[12] += 1
		if VarGlobales.stats_value[12] > VarGlobales.achivements_value[19]:
			VarGlobales.achivements_value[19] = VarGlobales.stats_value[12]
		VarGlobales.time_day += 1
		VarGlobales.time_tick = 0
		VarGlobales.time_hour = 0
	
	if VarGlobales.time_hour == 6 or VarGlobales.time_hour == 7 or VarGlobales.time_hour == 8:
		if red_now <= red:
			red_now += 0.000025*1.1115*multiplier
		if green_now <= green:
			green_now += 0.000053*1.1115*multiplier
		if blue_now <= blue:
			blue_now += 0.000076*1.1115*multiplier
	if VarGlobales.time_hour == 19 or VarGlobales.time_hour == 20 or VarGlobales.time_hour == 21:
		if red_now >= 0:
			red_now -= 0.000025*1.1115*multiplier
		if green_now >= 0:
			green_now -= 0.000053*1.1115*multiplier
		if blue_now >= 0:
			blue_now -= 0.000076*1.1115*multiplier
			
	if VarGlobales.WorldDimension == 1:
		get_node("ParallaxBackground/Fond/Sprite2D").self_modulate = Color(red_now,green_now,blue_now)
	if VarGlobales.WorldDimension == 2:
		get_node("ParallaxBackground/Fond/Sprite2D").self_modulate = Color(red_now,green_now/4,blue_now/3)

func breaking_sounds():
	if VarGlobales.WorldMode == 0:
		if VarGlobales.inGUI < 1:
			if get_cell(pose_x,pose_y,$TileMap) != -1:
				if block_dur < 4.9 and block_dur > 4.7:
					MusicController.play_block_breaking_sound()
				if block_dur < 4 and block_dur > 3.7:
					MusicController.play_block_breaking_sound()
				if block_dur < 3 and block_dur > 2.7:
					MusicController.play_block_breaking_sound()
				if block_dur < 2 and block_dur > 1.7:
					MusicController.play_block_breaking_sound()
				if block_dur < 0.01 and block_dur > -1:
					MusicController.play_block_breaked_sound()

func check_click_block():
	if clickmode == -1 or clickmode == 1:
		if not Input.is_action_just_pressed("mouse_poseblock") or clicktest == 0:
			if not Input.is_action_just_pressed("mouse_breakblock") or clicktest == 0:
				if VarGlobales.inGUI < 1:
					pose_block = 0
					pose_timing = 0
					
	if clickmode == -1 or clickmode == 1:
		if Input.is_action_just_pressed("mouse_poseblock") or clicktest == 1:
			if VarGlobales.inGUI < 1:
				if posevar_x+7 > pose_x and posevar_x-7 < pose_x and posevar_y+7 > pose_y and posevar_y-7 < pose_y:
					if pose_block == 0:
						pose_timing += 1
						if pose_timing == 1:
							if get_cell(pose_x,pose_y,$TileMap) == 20: ##CLIC TABLE ASSEMBLAGE (ouvrir le GUI)
								if get_node("CanvasLayer_GUI/CraftGUI").visible == false:
									get_node("CanvasLayer_GUI/CraftGUI").visible = true
									VarGlobales.inGUI += 1
									VarGlobales.block_in = [pose_x,pose_y]
									if VarGlobales.block_in in VarGlobales.blocks_nbt: ## si le block est présent dans le dico des tags
										pass
									else:
										VarGlobales.blocks_nbt[VarGlobales.block_in] = [ "assemble" , [0,0] ] ## "assemble" [result,timer]
									
							if get_cell(pose_x,pose_y,$TileMap) == 81: ##CLIC FURNACE (ouvrir le GUI)
								if get_node("CanvasLayer_GUI/FurnaceGUI").visible == false:
									get_node("CanvasLayer_GUI/FurnaceGUI").visible = true
									VarGlobales.inGUI += 1
							if get_cell(pose_x,pose_y,$TileMap) == 83: ##CLIC ANVIL (ouvrir le GUI)
								if get_node("CanvasLayer_GUI/AnvilGUI").visible == false:
									get_node("CanvasLayer_GUI/AnvilGUI").visible = true
									VarGlobales.inGUI += 1
							if get_cell(pose_x,pose_y,$TileMap) == 85: ##CLIC CHISEL (ouvrir le GUI)
								if get_node("CanvasLayer_GUI/ChiselGUI").visible == false:
									get_node("CanvasLayer_GUI/ChiselGUI").visible = true
									VarGlobales.inGUI += 1
							if get_cell(pose_x,pose_y,$TileMap) == 84: ##CLIC CAULDRON (ouvrir le GUI)
								if get_node("CanvasLayer_GUI/CauldronGUI").visible == false:
									get_node("CanvasLayer_GUI/CauldronGUI").visible = true
									VarGlobales.inGUI += 1
									
							if get_cell(pose_x,pose_y,$TileMap) == 136: ##CLIC CHEST (ouvrir le GUI)
								if get_node("CanvasLayer_GUI/ChestGUI").visible == false:
									VarGlobales.block_in = [pose_x,pose_y]
									if VarGlobales.block_in in VarGlobales.blocks_nbt: ## si le block est présent dans le dico des tags
										pass
									else:
										VarGlobales.blocks_nbt[VarGlobales.block_in] = [ "chest" , [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] ] ## "chest" [contains] -> [id,nbr]*20
										if pose_x == 2 and pose_y == -1:
											VarGlobales.blocks_nbt[VarGlobales.block_in] = [ "chest" , [ [79,1,-1],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] ] ## "chest" [contains] -> [id,nbr]*20
									get_node("CanvasLayer_GUI").show_chest_slots()
									get_node("CanvasLayer_GUI/ChestGUI").visible = true
									VarGlobales.inGUI += 1
											
							if get_cell(pose_x,pose_y,$TileMap) == 174: ##CLIC SIGN (ouvrir le GUI)
								if get_node("CanvasLayer_GUI/SignGUI").visible == false:
									VarGlobales.block_in = [pose_x,pose_y]
									if VarGlobales.block_in in VarGlobales.blocks_nbt: ## si le block est présent dans le dico des tags
										pass
									else:
										VarGlobales.blocks_nbt[VarGlobales.block_in] = [ "sign" , ""] ## "sign" [text]
									get_node("CanvasLayer_GUI/SignGUI").visible = true
									VarGlobales.inGUI += 1
							
							## DOORS
							update_door(116,pose_x,pose_y)
							update_door(120,pose_x,pose_y)
							update_door(124,pose_x,pose_y)
							update_door(128,pose_x,pose_y)
							update_door(132,pose_x,pose_y)
							
							if VarGlobales.Teleportation == 0:
								if VarGlobales.WorldDimension == 1:
									if get_cell(pose_x,pose_y,$TileMap) == 105: ##CLIC SHADOW PORTAL (ouvrir le GUI)
										VarGlobales.Teleportation = 3 ## Téléporte shadow après save
										VarGlobales.inGUI += 1
										VarGlobales.save()
										
								if VarGlobales.WorldDimension == 2:
									if get_cell(pose_x,pose_y,$TileMap) == 105: ##CLIC SHADOW PORTAL (ouvrir le GUI)
										VarGlobales.Teleportation = 1 ## Téléporte earth après save
										VarGlobales.inGUI += 1
										VarGlobales.save()
							
							if get_cell(pose_x,pose_y,$TileMap) == 66: ##CLIC CONVEYOR BELT (changer de sens)
								if get_node(tilemap).is_cell_x_flipped(pose_x,pose_y) == true:
									if pose_timing == 1:
										VarGlobales.blocks_nbt.erase([pose_x,pose_y])
									pose_block = 0
									pose_timing = 0
									$TileMap.set_cell(pose_x,pose_y,66,0)
								else:
									if pose_timing == 1:
										VarGlobales.blocks_nbt[[pose_x,pose_y]] = [ "flip" ]
										pose_block = 0
										pose_timing = 0
										$TileMap.set_cell(pose_x,pose_y,66,1)
									
							if get_cell(pose_x,pose_y,$TileMap) == 107: ##CLIC PEDESTAL
								VarGlobales.spawn_mob(Vector2(pose_x,pose_y-2)*16,3,1000)
								set_cell(pose_x,pose_y,106,$TileMap)
								MusicController.play_boss_spawn()

func check_pose_block():
	if clickmode == -1 or clickmode == 1:
		if Input.is_action_pressed("mouse_poseblock") or clicktest == 1:
			if str(VarGlobales.inv_slot[VarGlobales.slot_selected-1]) in VarGlobales.collection:
			#if VarGlobales.inv_pose[VarGlobales.inv_slot[VarGlobales.slot_selected-1]] > -1:
				if VarGlobales.inv_slot[VarGlobales.slot_selected-1] != -1:
					var blockpose_x = floor(get_viewport().get_mouse_position().x/16)
					var blockpose_y = floor(get_viewport().get_mouse_position().y/16)
					if not Vector2(blockpose_x,blockpose_y) == Vector2(31,-1):
						##range pose blocs
						if posevar_x+7*(VarGlobales.potions_active[8]+1) > pose_x and posevar_x-7*(VarGlobales.potions_active[8]+1) < pose_x and posevar_y+7*(VarGlobales.potions_active[8]+1) > pose_y and posevar_y-7*(VarGlobales.potions_active[8]+1) < pose_y:
							##not pose blocs in player
								if Vector2(posevar_x,posevar_y) != Vector2(pose_x,pose_y):
									if Vector2(posevar_x,posevar_y-1) != Vector2(pose_x,pose_y):
										if pose_y < 128:
											if get_cell(pose_x,pose_y,$TileMap) == -1 or get_cell(pose_x,pose_y,$TileMap) == 10 or get_cell(pose_x,pose_y,$TileMap) == 11:
												set_cell(pose_x,pose_y,VarGlobales.collection[str(VarGlobales.inv_slot[VarGlobales.slot_selected-1])][9],get_node("TileMap"))
												VarGlobales.stats_value[9] += 1
												pose_block = 1
												if VarGlobales.WorldMode == 0:
													VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1

func check_reset_breaking():
	if clickmode == -1 or clickmode == 0:
		if Input.is_action_just_released("mouse_breakblock") or clicktest == 0:
			if get_node("CanvasLayer").click_inv >= 0:
				block_dur = 5
				$TileMapBreak.clear()

func check_breaking_block():
	if clickmode == -1 or clickmode == 0:
		if Input.is_action_pressed("mouse_breakblock") or clicktest == 1:
			if VarGlobales.inGUI < 1:
				if get_node("CanvasLayer").click_inv >= 0:
					var block_brocked = get_cell(pose_x,pose_y,get_node("TileMap"))
					pose_x = floor(get_local_mouse_position().x/16)
					pose_y = floor(get_local_mouse_position().y/16)
					var posed_x = pose_x
					var posed_y = pose_y
					if get_cell(pose_x,pose_y,get_node("TileMap")) != -1:
						if block_dur < 5 and block_dur > 4:
							$TileMapBreak.clear()
							set_cell(pose_x,pose_y,0,get_node("TileMapBreak"))
							if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 72:
								set_cell(pose_x+1,pose_y,0,get_node("TileMapBreak"))
								set_cell(pose_x-1,pose_y,0,get_node("TileMapBreak"))
								set_cell(pose_x,pose_y+1,0,get_node("TileMapBreak"))
								set_cell(pose_x,pose_y-1,0,get_node("TileMapBreak"))
								set_cell(pose_x-1,pose_y-1,0,get_node("TileMapBreak"))
								set_cell(pose_x+1,pose_y+1,0,get_node("TileMapBreak"))
								set_cell(pose_x-1,pose_y+1,0,get_node("TileMapBreak"))
								set_cell(pose_x+1,pose_y-1,0,get_node("TileMapBreak"))
							posed_x = pose_x
							posed_y = pose_y
						if not posed_x == pose_x:
							$TileMapBreak.clear()
							block_dur = 5
						if not posed_y == pose_y:
							$TileMapBreak.clear()
							block_dur = 5
						if block_dur < 3 and block_dur > 2:
							set_cell(pose_x,pose_y,1,get_node("TileMapBreak"))
							if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 72:
								set_cell(pose_x+1,pose_y,1,get_node("TileMapBreak"))
								set_cell(pose_x-1,pose_y,1,get_node("TileMapBreak"))
								set_cell(pose_x,pose_y+1,1,get_node("TileMapBreak"))
								set_cell(pose_x,pose_y-1,1,get_node("TileMapBreak"))
								set_cell(pose_x-1,pose_y-1,1,get_node("TileMapBreak"))
								set_cell(pose_x+1,pose_y+1,1,get_node("TileMapBreak"))
								set_cell(pose_x-1,pose_y+1,1,get_node("TileMapBreak"))
								set_cell(pose_x+1,pose_y-1,1,get_node("TileMapBreak"))
						if block_dur < 2 and block_dur > 1:
							set_cell(pose_x,pose_y,2,get_node("TileMapBreak"))
							if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 72:
								set_cell(pose_x+1,pose_y,2,get_node("TileMapBreak"))
								set_cell(pose_x-1,pose_y,2,get_node("TileMapBreak"))
								set_cell(pose_x,pose_y+1,2,get_node("TileMapBreak"))
								set_cell(pose_x,pose_y-1,2,get_node("TileMapBreak"))
								set_cell(pose_x-1,pose_y-1,2,get_node("TileMapBreak"))
								set_cell(pose_x+1,pose_y+1,2,get_node("TileMapBreak"))
								set_cell(pose_x-1,pose_y+1,2,get_node("TileMapBreak"))
								set_cell(pose_x+1,pose_y-1,2,get_node("TileMapBreak"))
						if block_dur < 1 and block_dur > 0:
							set_cell(pose_x,pose_y,3,get_node("TileMapBreak"))
							if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 72:
								set_cell(pose_x+1,pose_y,3,get_node("TileMapBreak"))
								set_cell(pose_x-1,pose_y,3,get_node("TileMapBreak"))
								set_cell(pose_x,pose_y+1,3,get_node("TileMapBreak"))
								set_cell(pose_x,pose_y-1,3,get_node("TileMapBreak"))
								set_cell(pose_x-1,pose_y-1,3,get_node("TileMapBreak"))
								set_cell(pose_x+1,pose_y+1,3,get_node("TileMapBreak"))
								set_cell(pose_x-1,pose_y+1,3,get_node("TileMapBreak"))
								set_cell(pose_x+1,pose_y-1,3,get_node("TileMapBreak"))
					if block_dur >= 0 and get_cell(pose_x,pose_y,get_node("TileMap")) != -1:
						if posevar_x+7*(VarGlobales.potions_active[8]+1) > pose_x and posevar_x-7*(VarGlobales.potions_active[8]+1) < pose_x and posevar_y+7*(VarGlobales.potions_active[8]+1) > pose_y and posevar_y-7*(VarGlobales.potions_active[8]+1) < pose_y:
							if VarGlobales.inGUI < 1:
								if VarGlobales.WorldMode == 0:
									var minus_block_dur = VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][3]
									if VarGlobales.inv_slot[VarGlobales.slot_selected-1] != -1:
										minus_block_dur *= (pow(1+VarGlobales.collection[str(VarGlobales.inv_slot[VarGlobales.slot_selected-1])][8],2))
									if VarGlobales.potions_active[2] == 1:
										minus_block_dur *= 5
									if get_cell(pose_x,pose_y,get_node("TileMap")) >= 0 and get_cell(pose_x,pose_y,get_node("TileMap")) <= VarGlobales.collection.size():
										if VarGlobales.inv_slot[VarGlobales.slot_selected-1] >= 0 and VarGlobales.inv_slot[VarGlobales.slot_selected-1] <= VarGlobales.collection.size():
											if VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][5] == VarGlobales.collection[str(VarGlobales.inv_slot[VarGlobales.slot_selected-1])][6]:
												if VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][7] <= VarGlobales.collection[str(VarGlobales.inv_slot[VarGlobales.slot_selected-1])][8]:
													if minus_block_dur >= 1:
														minus_block_dur = 5
													if not VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 72:
														block_dur = block_dur - minus_block_dur
													else:
														block_dur = (block_dur - minus_block_dur)/9
												else:
													if not VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 72:
														block_dur -= VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][3]
													else:
														block_dur -= VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][3]/9
											else:
												if not VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 72:
													block_dur -= VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][3]
												else:
													block_dur -= VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][3]/9
										else:
											if not VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 72:
												block_dur -= VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][3]
											else:
												block_dur -= VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][3]/9
										VarGlobales.food -= 0.001
								if VarGlobales.WorldMode == 1:
									if get_cell(pose_x,pose_y,get_node("TileMap")) >= 0 and get_cell(pose_x,pose_y,get_node("TileMap")) <= VarGlobales.collection.size():
										set_cell(pose_x,pose_y,-1,get_node("TileMap"))
					
					
				##INVENTORY PLACE ITEM
					if block_dur <= 0:
						
						if get_cell(pose_x,pose_y,get_node("TileMap")) == 109:## BeeHive Breaked
							for i in VarGlobales.rng.randi_range(1,4):
								VarGlobales.spawn_mob(Vector2(pose_x*16+i*5,pose_y*16+i*5),2,3)
						
						MusicController.play_block_breaked_sound()
						
						## Succès casser premier bloc
						if VarGlobales.achievements_completed[0] == 0:
							VarGlobales.new_achievement(0)
						## Succès casser 10 000 blocs
						if VarGlobales.achievements_completed[1] == 0:
							VarGlobales.achivements_value[1] += 1
						$TileMapBreak.clear()
						block_dur = 5
						if not VarGlobales.inv_slot[VarGlobales.slot_selected-1] == -1:
							
							if VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][5] == VarGlobales.collection[str(VarGlobales.inv_slot[VarGlobales.slot_selected-1])][6] or VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][5] == 0:
								if VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][7] <= VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][8] or VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][7] == 0:
									if VarGlobales.WorldMode != 2:
										if get_cell(pose_x+1,pose_y-1,get_node("TileMap")) != -1:
											if get_cell(pose_x+1,pose_y-1,get_node("TileMap")) in [3,4,5,6,7,8,39,40,41,42,43,44] and VarGlobales.potions_active[7] == 1:
												VarGlobales.spawn_item(Vector2(pose_x*16+16,pose_y*16+16),block_brocked,rng.randi_range(1,5))
											else:
												VarGlobales.spawn_item(Vector2(pose_x*16+16,pose_y*16+16),block_brocked,1)
											set_cell(pose_x,pose_y,-1,get_node("TileMap"))
											VarGlobales.stats_value[8] += 1
											
										if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 72:
											if get_cell(pose_x+1,pose_y+1,get_node("TileMap")) != -1:
												VarGlobales.spawn_item(Vector2(pose_x*16+16,pose_y*16+16),VarGlobales.collection[str(get_cell(pose_x+1,pose_y+1,get_node("TileMap")))][10],1)
												set_cell(pose_x+1,pose_y+1,-1,get_node("TileMap"))
												VarGlobales.stats_value[8] += 1
											if get_cell(pose_x+1,pose_y-1,get_node("TileMap")) != -1:
												VarGlobales.spawn_item(Vector2(pose_x*16+16,pose_y*16+16),VarGlobales.collection[str(get_cell(pose_x+1,pose_y-1,get_node("TileMap")))][10],1)
												set_cell(pose_x+1,pose_y,-1,get_node("TileMap"))
												VarGlobales.stats_value[8] += 1
											if get_cell(pose_x,pose_y+1,get_node("TileMap")) != -1:
												VarGlobales.spawn_item(Vector2(pose_x*16+16,pose_y*16+16),VarGlobales.collection[str(get_cell(pose_x,pose_y+1,get_node("TileMap")))][10],1)
												set_cell(pose_x,pose_y+1,-1,get_node("TileMap"))
												VarGlobales.stats_value[8] += 1
											if get_cell(pose_x-1,pose_y-1,get_node("TileMap")) != -1:
												VarGlobales.spawn_item(Vector2(pose_x*16+16,pose_y*16+16),VarGlobales.collection[str(get_cell(pose_x-1,pose_y-1,get_node("TileMap")))][10],1)
												set_cell(pose_x-1,pose_y-1,-1,get_node("TileMap"))
												VarGlobales.stats_value[8] += 1
											if get_cell(pose_x-1,pose_y,get_node("TileMap")) != -1:
												VarGlobales.spawn_item(Vector2(pose_x*16+16,pose_y*16+16),VarGlobales.collection[str(get_cell(pose_x-1,pose_y,get_node("TileMap")))][10],1)
												set_cell(pose_x-1,pose_y,-1,get_node("TileMap"))
												VarGlobales.stats_value[8] += 1
											if get_cell(pose_x,pose_y-1,get_node("TileMap")) != -1:
												VarGlobales.spawn_item(Vector2(pose_x*16+16,pose_y*16+16),VarGlobales.collection[str(get_cell(pose_x,pose_y-1,get_node("TileMap")))][10],1)
												set_cell(pose_x,pose_y-1,-1,get_node("TileMap"))
												VarGlobales.stats_value[8] += 1
											if get_cell(pose_x-1,pose_y+1,get_node("TileMap")) != -1:
												VarGlobales.spawn_item(Vector2(pose_x*16+16,pose_y*16+16),VarGlobales.collection[str(get_cell(pose_x-1,pose_y+1,get_node("TileMap")))][10],1)
												set_cell(pose_x-1,pose_y+1,-1,get_node("TileMap"))
												VarGlobales.stats_value[8] += 1
											if get_cell(pose_x+1,pose_y-1,get_node("TileMap")) != -1:
												VarGlobales.spawn_item(Vector2(pose_x*16+16,pose_y*16+16),VarGlobales.collection[str(get_cell(pose_x+1,pose_y-1,get_node("TileMap")))][10],1)
												set_cell(pose_x+1,pose_y-1,-1,get_node("TileMap"))
												VarGlobales.stats_value[8] += 1
							
						##SI LEVEL DU BLOCK = MAIN
						if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == -1:
							if VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][7] == 0:
								print("ici2")
								if get_cell(pose_x,pose_y,get_node("TileMap")) != -1:
									print("ici3")
									if VarGlobales.WorldMode != 2:
										VarGlobales.spawn_item(Vector2(pose_x*16+16,pose_y*16+16),VarGlobales.collection[str(get_cell(pose_x,pose_y,get_node("TileMap")))][10],1)
										set_cell(pose_x,pose_y,-1,get_node("TileMap"))
										print("ici4")
										VarGlobales.stats_value[8] += 1

func save_mobs():
	var file_mob = ConfigFile.new()
	file_mob.set_value("Mobs","Values",VarGlobales.mobs_saving)
	file_mob.set_value("Mobs","Caps",VarGlobales.mob_caps)
	if VarGlobales.WorldDimension == 1:
		file_mob.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Earth/Entities.txt")
	if VarGlobales.WorldDimension == 2:
		file_mob.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Shadow/Entities.txt")
	VarGlobales.mobs_saving = {}
	VarGlobales.save_mobs = 0

func potions():
	if VarGlobales.potions_active[6] == 1:
		if VarGlobales.potions_timer[6] > 1:
			get_node("TileMapLights").visible = false
			get_node("TileMapLights_Torchs").visible = false
		else:
			get_node("TileMapLights").visible = true
			get_node("TileMapLights_Torchs").visible = true

func add_recipe(x,y,id):
	if get_node_or_null("TileMap/"+str(x,y)) == null:
		var instanced = show_results.instantiate()
		instanced.name = str(x,y)
		instanced.position = get_local_mouse_position()-Vector2(10,32)
		get_node("TileMap").add_child(instanced)

func _process(_delta):

				
			
	if VarGlobales.save_mobs == 2:
		save_mobs()
			
	if VarGlobales.inGUI < 1:
		posevar_x = VarGlobales.player_positions.x/16
		posevar_y = VarGlobales.player_positions.y/16
		VarGlobales.pose_x = floor(get_local_mouse_position().x/16)
		VarGlobales.pose_y = floor(get_local_mouse_position().y/16)
		
		clickmode = -1
		clicktest = -1
			
		potions()
		blocks_preview()
		refresh_blocks()
		check_achievement()
		refresh_time()
		breaking_sounds()
		check_click_block()
		check_pose_block()
		check_reset_breaking()
		check_breaking_block()
	check_teleportation()
	
func _unhandled_input(event):
	if OS.get_name() == "Android":
		if event is InputEventScreenTouch:
			if event.is_pressed():
				clicktest = 1
			else:
				clicktest = 0

func update_door_part(id_door,pose_x,pose_y):
	if pose_timing == 1:
		if get_cell(pose_x,pose_y,get_node("TileMap")) == id_door+2: ##CLIC DOOR CLOSE
			set_cell(pose_x,pose_y,id_door,get_node("TileMap")) # Le bas
			pose_block = 0
			pose_timing = 0
		if get_cell(pose_x,pose_y-1,get_node("TileMap")) == id_door+1:
			set_cell(pose_x,pose_y-1,id_door-1,get_node("TileMap")) # Le haut
			pose_block = 0
			pose_timing = 0
	if pose_timing == 1:
		if get_cell(pose_x,pose_y,get_node("TileMap")) == id_door: ##CLIC DOOR OPEN
			set_cell(pose_x,pose_y,id_door+2,get_node("TileMap")) # Le bas
			pose_block = 0
			pose_timing = 0
		if get_cell(pose_x,pose_y-1,get_node("TileMap")) == id_door-1:
			set_cell(pose_x,pose_y-1,id_door+1,get_node("TileMap")) # Le haut
			pose_block = 0
			pose_timing = 0

func update_door(id_door,pose_x,pose_y):
	update_door_part(id_door,pose_x,pose_y)

func place_door(id_door,pose_x,pose_y,node):
	var coordinates = id_to_coords(id_door)
	node.set_cell(0, Vector2(pose_x, pose_y), 0, Vector2i(coordinates.x, coordinates.y))
	coordinates = id_to_coords(id_door-1)
	node.set_cell(0, Vector2(pose_x, pose_y-1), 0, Vector2i(coordinates.x, coordinates.y))
	
	

func load_world():
	get_node("CharacterBody2D").invincibility = 1
	$TileMapLights.clear()
	get_node("CanvasLayer/TextureRect").visible = true
	get_node("CanvasLayer/TextureRect").texture = load("res://Textures/Blocks/dirt.png")
	await get_tree().create_timer(0.1).timeout
		
	if VarGlobales.Teleportation != -1:
		get_node("CanvasLayer/TextureRect/loadworld").text = "LOADING WORLD"
		get_node("CanvasLayer/TextureRect/loadinfos").text = "INFORMATIONS"
		await get_tree().create_timer(0.1).timeout
	var file_infos = ConfigFile.new()
	file_infos.load("user://Worlds/"+str(VarGlobales.WorldFile)+"/Infos.txt")
	VarGlobales.WorldName = file_infos.get_value("World","Name",VarGlobales.WorldName)
	VarGlobales.WorldSeed = file_infos.get_value("World","Seed",VarGlobales.WorldSeed)
	VarGlobales.WorldSaveVersion = file_infos.get_value("World","SaveVersion",VarGlobales.WorldSaveVersion)
	VarGlobales.WorldAchievementLocked = file_infos.get_value("World","Achievement Locked",VarGlobales.WorldAchievementLocked)
	VarGlobales.WorldWaterLevel = file_infos.get_value("World","Water Level",VarGlobales.WorldWaterLevel)
	VarGlobales.WorldSurfaceHeight = file_infos.get_value("World","Surface Height",VarGlobales.WorldSurfaceHeight)
	
	
	VarGlobales.WorldThumbnail = file_infos.get_value("World","Thumbnail")
	
	var file2 = ConfigFile.new()
	file2.load("user://Worlds/"+str(VarGlobales.WorldFile)+"/Player.txt")
	if VarGlobales.Teleportation != -1:
		get_node("CanvasLayer/TextureRect/loadinfos").text = "PLAYERS"
	if FileAccess.file_exists("user://Worlds/"+str(VarGlobales.WorldFile)+"/Player.txt") == true:
		await get_tree().create_timer(0.1).timeout
		get_node("CharacterBody2D").position = Vector2(file2.get_value("Player","x",0)*16,file2.get_value("Player","y",0)*16)
		VarGlobales.inv_slot = file2.get_value("Inventory","inv_slot",VarGlobales.inv_slot)
		VarGlobales.inv_slot_count = file2.get_value("Inventory","inv_slot_count",VarGlobales.inv_slot_count)
		VarGlobales.inv_slot_tag = file2.get_value("Inventory","inv_slot_tag",VarGlobales.inv_slot_tag)
		
		var potions1 = file2.get_value("Effects","Active Potions",VarGlobales.potions_active)
		if potions1.size() < VarGlobales.potions_active.size():
			for i in VarGlobales.potions_active.size()-potions1.size():
				potions1.append(0)
		var potions2 = file2.get_value("Effects","Potions durations",VarGlobales.potions_timer)
		if potions2.size() < VarGlobales.potions_active.size():
			for i in VarGlobales.potions_active.size()-potions2.size():
				potions2.append(0)
		VarGlobales.potions_active = potions1
		VarGlobales.potions_timer = potions2
		
		VarGlobales.backpack_numbers = file2.get_value("Backpack","Numbers",VarGlobales.backpack_numbers)
		VarGlobales.backpack_slots = file2.get_value("Backpack","Slots",VarGlobales.backpack_slots)
		VarGlobales.backpack_slots_count = file2.get_value("Backpack","Count",VarGlobales.backpack_slots_count)
		VarGlobales.backpack_slots_tag = file2.get_value("Backpack","Tag",VarGlobales.backpack_slots_tag)
		VarGlobales.armor_slot = file2.get_value("Inventory","armor_slot",VarGlobales.armor_slot)
		VarGlobales.armor_slot_count = file2.get_value("Inventory","armor_slot_count",VarGlobales.armor_slot_count)
		VarGlobales.armor_slot_tag = file2.get_value("Inventory","armor_slot_tag",VarGlobales.armor_slot_tag)
		if VarGlobales.WorldSaveVersion == 1:
			get_node("CharacterBody2D").position = Vector2(file2.get_value("Player","x",8000),file2.get_value("Player","y",-10))*16
		if VarGlobales.WorldSaveVersion == 2.1:
			var fileplayerv2 = ConfigFile.new()
			fileplayerv2.load("user://Worlds/"+str(VarGlobales.WorldFile)+"/"+str(VarGlobales.WorldDimensionNames[VarGlobales.WorldDimension-1])+"/Player.txt")
			get_node("CharacterBody2D").position = Vector2(fileplayerv2.get_value("Player","x",16),fileplayerv2.get_value("Player","y",-10)-1.5)*16
	
	if VarGlobales.Teleportation != -1:
		get_node("CanvasLayer/TextureRect/loadinfos").text = "BLOCKS"
	await get_tree().create_timer(0.1).timeout
	if VarGlobales.WorldSaveVersion == 1: ## Si la save est celle des snapshots de le bêta 9
		var file_world = ConfigFile.new()
		file_world.load("user://Worlds/"+str(VarGlobales.WorldFile)+"/Save.txt")
		VarGlobales.chunk_biome = file_world.get_value("World","ChunksID",VarGlobales.chunk_biome)
		for i in VarGlobales.inv_name.size():
			if file_world.has_section_key("Save",str(i)) == true:
				for j in range(0,file_world.get_value("Save",str(i)).size()):
					get_node(tilemap).set_cell(file_world.get_value("Save",str(i))[j][0],file_world.get_value("Save",str(i))[j][1],i)
	if VarGlobales.WorldSaveVersion == 2.1: ## Saves après la 22m11b
		var file_world = ConfigFile.new()
		var file_chunk = ConfigFile.new()
		file_world.load("user://Worlds/"+str(VarGlobales.WorldFile)+"/"+str(VarGlobales.WorldDimensionNames[VarGlobales.WorldDimension-1])+"/Infos.txt")
		VarGlobales.WorldBiome = file_world.get_value("Chunks","WorldBiome",0)
		if VarGlobales.WorldDimension == 1:
			VarGlobales.chunk_biome = file_world.get_value("Chunks","Biomes",VarGlobales.chunk_biome)
		if VarGlobales.WorldDimension == 2:
			VarGlobales.chunk_biome_shadow = file_world.get_value("Chunks","Biomes",VarGlobales.chunk_biome_shadow)
		VarGlobales.blocks_nbt = file_world.get_value("Custom","Tags",VarGlobales.blocks_nbt)
		VarGlobales.LoadedRegions = {"Chunk-1":1,"Chunk0":1,"Chunk1":1}
		VarGlobales.LoadedTimes = 1
		VarGlobales.LoadedRegions = file_world.get_value("Chunks","Loaded",VarGlobales.LoadedRegions)
		VarGlobales.LoadedTimes = file_world.get_value("Chunks","LoadedTimes",1)
		for i in VarGlobales.LoadedRegions.keys():
			var i_int = str(i).replace("Chunk","")
			i_int = int(i_int)
			if VarGlobales.LoadedRegions[i] >= 1:
				file_chunk.load("user://Worlds/"+str(VarGlobales.WorldFile)+"/"+str(VarGlobales.WorldDimensionNames[VarGlobales.WorldDimension-1])+"/Chunk"+str(i_int)+"/Blocks.txt")
				for k in VarGlobales.collection.size():
					if file_chunk.has_section_key("Save",str(k)) == true:
						for j in range(0,file_chunk.get_value("Save",str(k)).size()):
							set_cell(file_chunk.get_value("Save",str(k))[j][0],file_chunk.get_value("Save",str(k))[j][1],k,get_node(tilemap))
							
							if k == 66:
								VarGlobales.block_in = [ file_chunk.get_value("Save",str(k))[j][0] , file_chunk.get_value("Save",str(k))[j][1] ]
								if VarGlobales.block_in in VarGlobales.blocks_nbt:
									if VarGlobales.blocks_nbt[[file_chunk.get_value("Save",str(k))[j][0],file_chunk.get_value("Save",str(k))[j][1]]] == ["flip"]:
										set_cell(file_chunk.get_value("Save",str(k))[j][0],file_chunk.get_value("Save",str(k))[j][1],k,get_node(tilemap))

	
	if VarGlobales.Teleportation != -1:
		get_node("CanvasLayer/TextureRect/loadinfos").text = "STATISTICS"
	if FileAccess.file_exists("user://Worlds/"+str(VarGlobales.WorldFile)+"/Player.txt") == true:
		await get_tree().create_timer(0.1).timeout
		if file2.has_section_key("Stats","Statistics") == true:
			var array_stats = file2.get_value("Stats","Statistics")
			for i in range(0,array_stats.size()):
				if i < VarGlobales.stats_name.size():
					VarGlobales.stats_value[i] = file2.get_value("Stats","Statistics")[i]
		if FileAccess.file_exists("user://Worlds/"+str(VarGlobales.WorldFile)+"/Infos.txt") == true:
			file2.load("user://Worlds/"+str(VarGlobales.WorldFile)+"/Infos.txt")
			VarGlobales.WorldMode = file2.get_value("World","Mode",VarGlobales.WorldMode)
			VarGlobales.WorldAchievementLocked = file2.get_value("World","Achievement Locked",VarGlobales.WorldAchievementLocked)
	
	if VarGlobales.Teleportation != -1:
		get_node("CanvasLayer/TextureRect/loadinfos").text = "MOBS"
		if FileAccess.file_exists("user://Worlds/"+str(VarGlobales.WorldFile)+"/"+str(VarGlobales.WorldDimensionNames[VarGlobales.WorldDimension-1])+"/Entities.txt") == true:
			await get_tree().create_timer(0.1).timeout
			var file3 = ConfigFile.new()
			file3.load("user://Worlds/"+str(VarGlobales.WorldFile)+"/"+str(VarGlobales.WorldDimensionNames[VarGlobales.WorldDimension-1])+"/Entities.txt")
			if file3.has_section_key("Mobs","Values") == true:
				for i in VarGlobales.LoadedRegions.keys():
					var i_int = str(i).replace("Chunk","")
					i_int = int(i_int)
					if VarGlobales.LoadedRegions[i] >= 1:
						if i in file3.get_value("Mobs","Values"):
							var array_mobs = file3.get_value("Mobs","Values")[str(i)]
							for k in array_mobs.size():
								VarGlobales.spawn_mob(Vector2(array_mobs[k][1],array_mobs[k][2]),array_mobs[k][0],array_mobs[k][3])
	
	if VarGlobales.Teleportation != -1:
		get_node("CanvasLayer/TextureRect/loadinfos").text = "ITEMS"
	if VarGlobales.WorldDimension == 1:
		if FileAccess.file_exists("user://Worlds/"+str(VarGlobales.WorldFile)+"/"+str(VarGlobales.WorldDimensionNames[VarGlobales.WorldDimension-1])+"/Items.txt") == true:
			await get_tree().create_timer(0.1).timeout
			var file3 = ConfigFile.new()
			file3.load("user://Worlds/"+str(VarGlobales.WorldFile)+"/"+str(VarGlobales.WorldDimensionNames[VarGlobales.WorldDimension-1])+"/Items.txt")
			if file3.has_section_key("Items","Values") == true:
				for i in VarGlobales.LoadedRegions.keys():
					var i_int = str(i).replace("Chunk","")
					i_int = int(i_int)
					if VarGlobales.LoadedRegions[i] >= 1:
						if i in file3.get_value("Items","Values"):
							var array_items = file3.get_value("Items","Values")[str(i)]
							for k in array_items.size():
								VarGlobales.spawn_item(Vector2(array_items[k][1],array_items[k][2]),array_items[k][0],array_items[k][3],array_items[k][4])
	
	if VarGlobales.Teleportation != -1:
		get_node("CanvasLayer/TextureRect/loadinfos").text = "TIME"
	if FileAccess.file_exists("user://Worlds/"+str(VarGlobales.WorldFile)+"/Time.txt") == true:
		await get_tree().create_timer(0.1).timeout
		var file4 = ConfigFile.new()
		if file4.has_section("Time") == true:
			file4.load("user://Worlds/"+str(VarGlobales.WorldFile)+"/Time.txt")
			red_now = file4.get_value("Time","Background")[0]
			green_now = file4.get_value("Time","Background")[1]
			blue_now = file4.get_value("Time","Background")[2]
			VarGlobales.time_tick = file4.get_value("Time","Ticks")
			VarGlobales.time_min = file4.get_value("Time","Minutes")
			VarGlobales.time_hour = file4.get_value("Time","Hours")
			VarGlobales.time_day = file4.get_value("Time","Days")
	
	get_node("CanvasLayer/TextureRect").visible = false
	get_node("CharacterBody2D").invincibility = 0
	VarGlobales.WorldState = 2
	VarGlobales.Teleportation = 0

func find_surface(x):
	var find = false
	for i in range(-100,200):
		if get_cell(x,i,$TileMap) != -1:
			find = true
		return i-1
