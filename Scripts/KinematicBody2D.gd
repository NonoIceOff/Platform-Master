extends CharacterBody2D

var item = preload("res://Scènes/Item.tscn")
var mob = preload("res://Scènes/Mob.tscn")

var SPEED = 75
var JUMP_VELOCITY = -150
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var FLOOR = Vector2(0,-1)
var on_ground = false
var rng = RandomNumberGenerator.new()

var y_fall_start = 0
var y_fall_end = 0
var in_fall = false
var mouse = 0
var pos_x = get_position().x
var pos_y = get_position().y
var invincibility = 0

var item_use = 0
var item_use_i = 0
var item_use_i_max = 0

var direc = 2

func _init():
	Generation.tilemap = "/root/World/TileMap"
	Generation.tilemap_torch = "/root/World/TileMapLigths_Torchs"
	Generation.tilemap_lights = "/root/World/TileMapLights"
	Generation.speed = 0

func _ready():
	get_node("Nick").text = VarGlobales.nickname
	get_node("Nick").self_modulate = VarGlobales.color_nickmane
	get_node("Hair").self_modulate = VarGlobales.color_hair
	get_node("TShirt").self_modulate = VarGlobales.color_tshirt
	get_node("Head").texture = load("res://Textures/Personnage/Heads/"+str(VarGlobales.skin_head_shape)+".png")
	
	rng.randomize()
	MusicController.play_spawn_sound()

func get_cell(a,b,node):
	return node.get_cell_source_id(0,Vector2(a,b),false)
	
func set_cell(a,b,id,node):
	node.set_cell(0,Vector2(a,b),0,Vector2i(id-floor(id/11),0+floor(id/11)))

func wait(sec):
	var t = Timer.new()
	t.set_wait_time(sec)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await t.timeout
	t.queue_free()

func _process(_delta):
		if VarGlobales.WorldMode != 2:
			get_node("../Camera2D").position = position
		pos_x = get_position().x
		pos_y = get_position().y
		var cam_x = get_node("../Camera2D").get_position().x+get_position().x
		var cam_y = get_node("../Camera2D").get_position().y+get_position().y
		var pose_x = floor(get_global_mouse_position().x/16)
		var pose_y = floor(get_global_mouse_position().y/16)
		VarGlobales.player_positions = position

		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				if VarGlobales.inGUI < 1:
					get_node("Perso").play("wait")
					
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			if VarGlobales.inv_slot[VarGlobales.slot_selected-1] != -1:
				if VarGlobales.collection[str(VarGlobales.inv_slot[VarGlobales.slot_selected-1])][9] > -1:
					get_node("Perso").play("break")
					get_node("Perso").frame = 1
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if VarGlobales.inGUI < 1:
				get_node("Perso").play("break")


		if invincibility == 1:
			y_fall_start = pos_y/16
			y_fall_end = pos_y/16

		if VarGlobales.WorldDimension == 1 and VarGlobales.WorldParty == 0:
			if floor(get_node("../CharacterBody2D").get_position().x/16/16) in VarGlobales.chunk_biome:
				if VarGlobales.chunk_discovered[str(VarGlobales.chunk_name[VarGlobales.chunk_biome[floor(get_node("../CharacterBody2D").get_position().x/16/16)]])] == 0:
					VarGlobales.chunk_discovered[str(VarGlobales.chunk_name[VarGlobales.chunk_biome[floor(get_node("../CharacterBody2D").get_position().x/16/16)]])] = 1
					VarGlobales.chunk_discovered["TOTAL"] += 1
					print("New chunk discovered : ",str(VarGlobales.chunk_name[VarGlobales.chunk_biome[floor(get_node("../CharacterBody2D").get_position().x/16/16)]]))
					if VarGlobales.achivements_value[17] < VarGlobales.chunk_discovered["TOTAL"]:
						VarGlobales.achivements_value[17] = VarGlobales.chunk_discovered["TOTAL"]

		if VarGlobales.WorldDimension == 2 and VarGlobales.WorldParty == 0:
			if floor(get_node("../CharacterBody2D").get_position().x/16/16) in VarGlobales.chunk_biome_shadow:
				if VarGlobales.chunk_discovered[str(VarGlobales.chunk_shadow_name[VarGlobales.chunk_biome_shadow[floor(get_node("../CharacterBody2D").get_position().x/16/16)]])] == 0:
					VarGlobales.chunk_discovered[str(VarGlobales.chunk_shadow_name[VarGlobales.chunk_biome_shadow[floor(get_node("../CharacterBody2D").get_position().x/16/16)]])] = 1
					VarGlobales.chunk_discovered["TOTAL"] += 1
					print("New chunk discovered : ",str(VarGlobales.chunk_shadow_name[VarGlobales.chunk_biome_shadow[floor(get_node("../CharacterBody2D").get_position().x/16/16)]]))
					if VarGlobales.achivements_value[17] < VarGlobales.chunk_discovered["TOTAL"]:
						VarGlobales.achivements_value[17] = VarGlobales.chunk_discovered["TOTAL"]




		if VarGlobales.death >= 1 and VarGlobales.death < 1000:
			MusicController.play_player_dead_sound()
			for i in VarGlobales.inv_slot.size():
				if VarGlobales.inv_slot[i] != -1:
					VarGlobales.spawn_item(Vector2(position.x,position.y-32),VarGlobales.inv_slot[i],VarGlobales.inv_slot_count[i],VarGlobales.inv_tags[i])
					VarGlobales.inv_slot[i] = -1
					VarGlobales.inv_slot_count[i] = 0
					VarGlobales.inv_tags[i] = -1
			VarGlobales.inGUI = 1
			get_node("../CanvasLayer_GUI/DeadGUI").visible = true
			VarGlobales.death = 1000
			
			
		if VarGlobales.WorldParty == 0:
			if "Chunk"+str(floor(VarGlobales.player_positions.x/16/16)-1) in VarGlobales.LoadedRegions: ## chunk à gauche
				VarGlobales.LoadedRegions["Chunk"+str(floor(VarGlobales.player_positions.x/16/16)-1)] = VarGlobales.LoadedTimes
			else:
				if VarGlobales.WorldDimension == 1:
					Generation.gen_world(round(VarGlobales.player_positions.x/16/16)-2,1)
					Generation.gen_world(round(VarGlobales.player_positions.x/16/16)-1,1)
					VarGlobales.save_chunk(round(VarGlobales.player_positions.x/16/16)+3)
#				if VarGlobales.WorldDimension == 2:
#					await get_node("../").gen_shadow(floor(VarGlobales.player_positions.x/16/16)-1)
					
				VarGlobales.LoadedRegions["Chunk"+str(floor(VarGlobales.player_positions.x/16/16)-1)] = VarGlobales.LoadedTimes
			
			if "Chunk"+str(floor(VarGlobales.player_positions.x/16/16)) in VarGlobales.LoadedRegions: ## chunk milieu
				VarGlobales.LoadedRegions["Chunk"+str(floor(VarGlobales.player_positions.x/16/16))] = VarGlobales.LoadedTimes
			else:
				if VarGlobales.WorldDimension == 1:
					Generation.gen_world(floor(VarGlobales.player_positions.x/16/16),1)
#				if VarGlobales.WorldDimension == 2:
#					await get_node("../").gen_shadow(floor(VarGlobales.player_positions.x/16/16))
				VarGlobales.LoadedRegions["Chunk"+str(floor(VarGlobales.player_positions.x/16/16))] = VarGlobales.LoadedTimes

			if "Chunk"+str(floor(VarGlobales.player_positions.x/16/16)+1) in VarGlobales.LoadedRegions: ## chunk à droite
				VarGlobales.LoadedRegions["Chunk"+str(floor(VarGlobales.player_positions.x/16/16)+1)] = VarGlobales.LoadedTimes
			else:
				if VarGlobales.WorldDimension == 1:
					Generation.gen_world(floor(VarGlobales.player_positions.x/16/16)+2,1)
					Generation.gen_world(floor(VarGlobales.player_positions.x/16/16)+1,1)
					VarGlobales.save_chunk(round(VarGlobales.player_positions.x/16/16)-3)
#				if VarGlobales.WorldDimension == 2:
#					await get_node("../").gen_shadow(floor(VarGlobales.player_positions.x/16/16)+1)
				VarGlobales.LoadedRegions["Chunk"+str(floor(VarGlobales.player_positions.x/16/16)+1)] = VarGlobales.LoadedTimes

		## Dégats de void
		if position.y/16 >= Generation.world_depth:
			if VarGlobales.WorldMode == 0:
				VarGlobales.health -= 0.25
				MusicController.play_player_hit_sound()
				if VarGlobales.health <= 0:
					VarGlobales.death = 3
					VarGlobales.stats_value[7] += 1
					velocity.x = 0
					get_node("../CanvasLayer_GUI/DeadGUI/PanelPrincipal/Label2").text = str("DEAD_CAUSE3")
			if VarGlobales.WorldMode == 1:
				get_node("../CanvasLayer/CheckButton").button_pressed = true

		for i in VarGlobales.potions_timer.size():
			if VarGlobales.potions_active[i] == 1:
				VarGlobales.potions_timer[i] -= 0.02
				if get_node_or_null("../CanvasLayer/HBoxContainer/Panel"+str(i)+"/Time") != null:
					get_node("../CanvasLayer/HBoxContainer/Panel"+str(i)+"/Time").text = str(floor(VarGlobales.potions_timer[i]))
				else:
					VarGlobales.add_effect(i,VarGlobales.potions_timer[i])
				if i == 0:
					if VarGlobales.health < 100:
						VarGlobales.health += 0.01
				if VarGlobales.potions_timer[i] <= 0:
					VarGlobales.potions_active[i] = 0
					get_node("../CanvasLayer/HBoxContainer/Panel"+str(i)).queue_free()

		if VarGlobales.inGUI < 1:
			if VarGlobales.WorldState == 1:
				y_fall_start = 0
				y_fall_end = 0

			## Item use
			for i in range(0,8):
				if VarGlobales.inv_slot_cooldown_max[i] > -1:
					VarGlobales.inv_slot_cooldown[i] += 1
					get_node("../CanvasLayer/inv_slot"+str(i+1)+"/Bar").value  = VarGlobales.inv_slot_cooldown[i]
					if VarGlobales.inv_slot_cooldown[i] == 1:
						get_node("../CanvasLayer/inv_slot"+str(i+1)+"/Bar").visible = true
						get_node("../CanvasLayer/inv_slot"+str(i+1)+"/Bar").max_value = VarGlobales.inv_slot_cooldown_max[i]
					if VarGlobales.inv_slot_cooldown[i] == VarGlobales.inv_slot_cooldown_max[i]:
						VarGlobales.inv_slot_cooldown[i] = -1
						VarGlobales.inv_slot_cooldown_max[i] = -1
						get_node("../CanvasLayer/inv_slot"+str(i+1)+"/Bar").value = 0
						get_node("../CanvasLayer/inv_slot"+str(i+1)+"/Bar").visible = false

			if get_viewport().get_mouse_position().x < 985 or get_viewport().get_mouse_position().y > 36:
				## WOODEN SWORD
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 92:
						if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
							VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
							VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 10
				## STONE SWORD
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 93:
						if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
							VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
							VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 15
				## IRON SWORD
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 94:
						if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
							VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
							VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 20
				## RUBY SWORD
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 95:
						if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
							VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
							VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 25
				## SAPPHIRE SWORD
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 96:
						if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
							VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
							VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 30
				## EMERALD SWORD
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 97:
						if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
							VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
							VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 35

				## FOOD
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 74:
						if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
							if VarGlobales.food < 200:
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.food += 10
								VarGlobales.stats_value[10] += 1
								VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
								VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 100

				## EMPTY BUCKET
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 78:
						if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
							if get_node("../TileMap").get_cell(pose_x,pose_y) == 10:
								get_node("../TileMap").set_cell(pose_x,pose_y,-1)
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,79,1)
							if get_node("../TileMap").get_cell(pose_x,pose_y) == 147:
								get_node("../TileMap").set_cell(pose_x,pose_y,-1)
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,151,1)
							if get_node("../TileMap").get_cell(pose_x,pose_y) == 149:
								get_node("../TileMap").set_cell(pose_x,pose_y,-1)
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,152,1)
							VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
							VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 100

				## WATER BUCKET
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 79:
						if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
							if get_node("../TileMap").get_cell(pose_x,pose_y) == -1:
								get_node("../TileMap").set_cell(pose_x,pose_y,10)
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,78,1)
							VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
							VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 100
							
				## MAGMA BUCKET
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 161:
						if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
							if get_node("../TileMap").get_cell(pose_x,pose_y) == -1:
								get_node("../TileMap").set_cell(pose_x,pose_y,147)
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,78,1)
							VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
							VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 100
							
				## LAVA BUCKET
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 162:
						if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
							if get_node("../TileMap").get_cell(pose_x,pose_y) == -1:
								get_node("../TileMap").set_cell(pose_x,pose_y,149)
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,78,1)
							VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
							VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 100

				## HEALTH POTION
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.potions_active[0] == 0:
						if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 90:
							if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,88,1)
								VarGlobales.add_effect(0,50)
								VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
								VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 1000
								for j in VarGlobales.potions_active.size():
									if VarGlobales.potions_active[j] == 1:
										VarGlobales.achivements_value[20] += 1
									else:
										VarGlobales.achivements_value[20] = 0
								if VarGlobales.achivements_value[20] >= VarGlobales.achivements_max_value[20]:
									VarGlobales.new_achievement(15)
								else:
									VarGlobales.achievements_completed[20] = 0

				## STRENGHT POTION
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.potions_active[1] == 0:
						if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 91:
							if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,88,1)
								VarGlobales.add_effect(1,50)
								VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
								VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 1000
								for j in VarGlobales.potions_active.size():
									if VarGlobales.potions_active[j] == 1:
										VarGlobales.achivements_value[20] += 1
									else:
										VarGlobales.achivements_value[20] = 0
								if VarGlobales.achivements_value[20] >= VarGlobales.achivements_max_value[20]:
									VarGlobales.achievements_completed[20] = 1
								else:
									VarGlobales.achivements_value[20] = 0
									
				## SPEED BREAKING POTION
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.potions_active[2] == 0:
						if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 142:
							if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,88,1)
								VarGlobales.add_effect(2,50)
								VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
								VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 2000
								for j in VarGlobales.potions_active.size():
									if VarGlobales.potions_active[j] == 2:
										VarGlobales.achivements_value[20] += 1
									else:
										VarGlobales.achivements_value[20] = 0
								if VarGlobales.achivements_value[20] >= VarGlobales.achivements_max_value[20]:
									VarGlobales.new_achievement(20)
								else:
									VarGlobales.achivements_value[20] = 0
				
				## ATTRACTION POTION
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.potions_active[3] == 0:
						if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 143:
							if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,88,1)
								VarGlobales.add_effect(3,50)
								VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
								VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 2000
								for j in VarGlobales.potions_active.size():
									if VarGlobales.potions_active[j] == 3:
										VarGlobales.achivements_value[20] += 1
									else:
										VarGlobales.achivements_value[20] = 0
								if VarGlobales.achivements_value[20] >= VarGlobales.achivements_max_value[20]:
									VarGlobales.new_achievement(20)
								else:
									VarGlobales.achivements_value[20] = 0
									
				## JUMP POTION
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.potions_active[4] == 0:
						if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 144:
							if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,88,1)
								VarGlobales.add_effect(4,50)
								VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
								VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 2000
								for j in VarGlobales.potions_active.size():
									if VarGlobales.potions_active[j] == 4:
										VarGlobales.achivements_value[20] += 1
									else:
										VarGlobales.achivements_value[20] = 0
								if VarGlobales.achivements_value[20] >= VarGlobales.achivements_max_value[20]:
									VarGlobales.new_achievement(20)
								else:
									VarGlobales.achivements_value[20] = 0
									
				## SPEED POTION
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.potions_active[5] == 0:
						if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 145:
							if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,88,1)
								VarGlobales.add_effect(5,50)
								VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
								VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 2000
								for j in VarGlobales.potions_active.size():
									if VarGlobales.potions_active[j] == 5:
										VarGlobales.achivements_value[20] += 1
									else:
										VarGlobales.achivements_value[20] = 0
								if VarGlobales.achivements_value[20] >= VarGlobales.achivements_max_value[20]:
									VarGlobales.new_achievement(20)
								else:
									VarGlobales.achivements_value[20] = 0
									
				## NIGHT VISION POTION
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.potions_active[6] == 0:
						if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 146:
							if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,88,1)
								VarGlobales.add_effect(6,50)
								VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
								VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 2000
								for j in VarGlobales.potions_active.size():
									if VarGlobales.potions_active[j] == 6:
										VarGlobales.achivements_value[20] += 1
									else:
										VarGlobales.achivements_value[20] = 0
								if VarGlobales.achivements_value[20] >= VarGlobales.achivements_max_value[20]:
									VarGlobales.new_achievement(20)
								else:
									VarGlobales.achivements_value[20] = 0
									
				## FORTUNE POTION
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.potions_active[7] == 0:
						if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 147:
							if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,88,1)
								VarGlobales.add_effect(7,50)
								VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
								VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 2000
								for j in VarGlobales.potions_active.size():
									if VarGlobales.potions_active[j] == 7:
										VarGlobales.achivements_value[20] += 1
									else:
										VarGlobales.achivements_value[20] = 0
								if VarGlobales.achivements_value[20] >= VarGlobales.achivements_max_value[20]:
									VarGlobales.new_achievement(20)
								else:
									VarGlobales.achivements_value[20] = 0
									
				## JRANGE POTION
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.potions_active[8] == 0:
						if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 148:
							if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
								VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1
								VarGlobales.spawn_item(position,88,1)
								VarGlobales.add_effect(8,50)
								VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
								VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 2000
								for j in VarGlobales.potions_active.size():
									if VarGlobales.potions_active[j] == 8:
										VarGlobales.achivements_value[20] += 1
									else:
										VarGlobales.achivements_value[20] = 0
								if VarGlobales.achivements_value[20] >= VarGlobales.achivements_max_value[20]:
									VarGlobales.new_achievement(20)
								else:
									VarGlobales.achivements_value[20] = 0


				## BACKPACK
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
					if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
						if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 77:
							if typeof(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]) == TYPE_INT:
								if VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1] == -1:
									VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1] = "backpack"+str(VarGlobales.backpack_numbers)
									VarGlobales.backpack_numbers += 1
									var new_slots = [-1,-1,-1,-1,-1,-1,-1,-1]
									var new_slots_tag = [-1,-1,-1,-1,-1,-1,-1,-1]
									var new_slots_count = [0,0,0,0,0,0,0,0]
									VarGlobales.backpack_slots.append(new_slots)
									VarGlobales.backpack_slots_tag.append(new_slots_tag)
									VarGlobales.backpack_slots_count.append(new_slots_count)
							VarGlobales.inGUI += 1
							get_node("../CanvasLayer_GUI/BackPackGUI").visible = true
							VarGlobales.inv_slot_cooldown[VarGlobales.slot_selected-1] = 0
							VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] = 1000

			##PARACHUTES
			if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 68:
				if VarGlobales.WorldMode == 0:
					if VarGlobales.achievements_completed[14] == 0:
						VarGlobales.new_achievement(14)
				get_node("Parachute").visible = true
				get_node("ParticulesJetpack").emitting = false
				if on_ground == false:
					gravity = 1
				if on_ground == true:
					JUMP_VELOCITY = 0
				y_fall_start = 0
				y_fall_end = 0
			else:
				get_node("Parachute").visible = false

			##JETPACK
			if VarGlobales.armor_slot[0] == 70:
				if VarGlobales.WorldMode == 0:
					if VarGlobales.achievements_completed[13] == 0:
						VarGlobales.new_achievement(13)
				get_node("Jetpack").visible = true
				get_node("ParticulesJetpack").visible = VarGlobales.particules
				y_fall_start = 0
				y_fall_end = 0
			else:
				get_node("Jetpack").visible = false
				get_node("ParticulesJetpack").visible = false


		if not VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 68:
			if get_cell(floor(self.get_position().x/16),floor(self.get_position().y/16),get_node("../TileMap")) == 10 or get_cell(floor(self.get_position().x/16),floor(self.get_position().y/16),get_node("../TileMap")) == 11:
				SPEED = 75/2
				gravity = ProjectSettings.get_setting("physics/2d/default_gravity")/2
				JUMP_VELOCITY = -100
				on_ground = true
				y_fall_start = 0
				y_fall_end = 0
			else:
				SPEED = 75
				gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
				JUMP_VELOCITY = -150

		if VarGlobales.death <= 0:
			if Input.is_action_just_pressed("ui_cancel"):
				if get_node("../CanvasLayer").click_inv == 1:
					get_node("../CanvasLayer").click_inv = 0
					VarGlobales.spawn_item(position,get_node("../CanvasLayer").selected_inv,get_node("../CanvasLayer").selected_count,get_node("../CanvasLayer").selected_tag)
					get_node("../CanvasLayer/cursor_slot/item").texture = null
					get_node("../CanvasLayer/cursor_slot/Label").text = ""
					get_node("../CanvasLayer").selected_count = 0
					get_node("../CanvasLayer").selected_inv = 0
					get_node("../CanvasLayer").selected_tag = -1
				if get_node("../CanvasLayer").click_inv == 0:
					if get_node("../CanvasLayer_GUI").stats_visible == 0:
						if VarGlobales.inGUI > 0:
							get_node("../CanvasLayer_GUI/CheatGUI").visible = false
							get_node("../CanvasLayer_GUI/SoftCraftGUI").visible = false
							get_node("../CanvasLayer_GUI/CraftGUI").visible = false
							get_node("../CanvasLayer_GUI/PauseGUI").visible = false
							get_node("../CanvasLayer_GUI/BackPackGUI").visible = false
							get_node("../CanvasLayer_GUI/FurnaceGUI").visible = false
							get_node("../CanvasLayer_GUI/AnvilGUI").visible = false
							get_node("../CanvasLayer_GUI/ChiselGUI").visible = false
							get_node("../CanvasLayer_GUI/CauldronGUI").visible = false
							get_node("../CanvasLayer_GUI/ChestGUI").visible = false
							get_node("../CanvasLayer_GUI/SignGUI").visible = false
							for i in range(1,9):
								get_node("../CanvasLayer/inv_slot"+str(i)).visible = true
							get_node("../CanvasLayer/NameItem").visible = true
							VarGlobales.inGUI = 0
							if VarGlobales.WorldMode == 1:
								get_node("../CanvasLayer/CheckButton").visible = true
						else:
							get_node("../CanvasLayer_GUI/PauseGUI").visible = true
							for i in range(1,9):
								get_node("../CanvasLayer/inv_slot"+str(i)).visible = false
							get_node("../CanvasLayer/NameItem").visible = false
							VarGlobales.inGUI = 1

		if VarGlobales.WorldState == 2:
			if get_node("../CanvasLayer_GUI/PauseGUI").visible == true:
				y_fall_start = 0
				y_fall_end = 0
			
		if Input.is_action_just_pressed("ui_drop"):
			if VarGlobales.inGUI < 1:
				if VarGlobales.inv_slot[VarGlobales.slot_selected-1] != -1:
					if scale.x <= 0:
						VarGlobales.spawn_item(Vector2(position.x-30,position.y),VarGlobales.inv_slot[VarGlobales.slot_selected-1],1,VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1])
					else:
						VarGlobales.spawn_item(Vector2(position.x+30,position.y),VarGlobales.inv_slot[VarGlobales.slot_selected-1],1,VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1])
					VarGlobales.inv_slot_count[VarGlobales.slot_selected-1] -= 1

func _physics_process(delta):
		var sprint = 0
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			VarGlobales.food -= 0.1
			VarGlobales.stats_value[1] += 1

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if Input.is_action_pressed("ui_ctrl"):
			sprint = 1
		else:
			sprint = 0
		
		if Input.is_action_just_pressed("ui_right"):
			if direc != 2:
				scale.x = scale.x * -1
				direc = 2
					
		if Input.is_action_just_pressed("ui_left"):
			if direc != 1:
				scale.x = scale.x * -1
				direc = 1
		
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED * (sprint+1)
			VarGlobales.food -= 0.002*(sprint+1)
			VarGlobales.stats_value[2] += 0.13032*(sprint+1)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		if VarGlobales.WorldState == 2:
			if VarGlobales.inGUI < 1:
				if VarGlobales.death == 0:
					##CONVEYOR BELTS RIGHT
					if get_cell(floor(self.get_position().x/16),floor(self.get_position().y/16),get_node("../TileMap")) == 66:
						if get_node("../TileMap").is_cell_x_flipped(floor(self.get_position().x/16),floor(self.get_position().y/16)) == true:
							position.x -= 5
							## Succès 1000 blocs de transport
							if VarGlobales.achievements_completed[12] == 0:
								VarGlobales.achivements_value[12] += 0.285
						else:
							position.x += 5
							## Succès 1000 blocs de transport
							if VarGlobales.achievements_completed[12] == 0:
								VarGlobales.achivements_value[12] += 0.285

					if not get_cell(floor(self.get_position().x/16),floor(self.get_position().y/16),get_node("../TileMap")) == 66:
						if VarGlobales.WorldMode != 2:
							get_node("../CanvasLayer/CheckButton").visible = false

				if VarGlobales.WorldMode == 2:
					get_node("../CanvasLayer/CheckButton").visible = false

			if invincibility == 0:
				if VarGlobales.Teleportation == 0:
					if is_on_floor():
						on_ground = true
						if in_fall == false:
							y_fall_start = pos_y/16
						else:
							in_fall = false

					else:
						on_ground = false
						y_fall_end = pos_y/16
						in_fall = true

			if invincibility == 0:
				if VarGlobales.WorldMode == 0:
					if VarGlobales.Teleportation == 0:
						if int(y_fall_end-y_fall_start) > 4 and y_fall_start != 0:
							VarGlobales.health -= int(y_fall_end-y_fall_start)*10-30
							VarGlobales.stats_value[4] += int(y_fall_end-y_fall_start)*10-30
							MusicController.play_player_hit_sound()
							if VarGlobales.health <= 0:
								VarGlobales.death = 1
								VarGlobales.stats_value[7] += 1
								velocity.x = 0
								get_node("../CanvasLayer_GUI/DeadGUI/PanelPrincipal/Label2").text = str("DEAD_CAUSE1")
							y_fall_start = 0
							y_fall_end = 0
