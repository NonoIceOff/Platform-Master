extends CharacterBody2D

const speed = 100

var health = 100
var health_max = 100
var id = 0
var chunk = 0

var SPEED = 25
var GRAVITY = 9.8*2
var JUMP_POWER = -200
var FLOOR = Vector2(0,-1)
var on_ground = false

@onready var hit_timer = get_node("hit_timer")

var mouse_pressed = 0

var rng = RandomNumberGenerator.new()

var player_in = 0
var hit_delay = -1
var mouse_in = 0

func get_cell(a,b,node):
	return node.get_cell_source_id(0,Vector2(a,b),false)
	
func set_cell(a,b,id,node):
	node.set_cell(0,Vector2(a,b),0,Vector2i(id-floor(id/11),0+floor(id/11)))

func _ready():
	rng.randomize()
	get_node("Texture2D").visible = true
	get_node("AnimatedSprite2D").visible = false
	if id == 0: ##sheep
		health_max = 25
		get_node("Texture2D").texture = load("res://Textures/Mobs/sheep.png")
		load("res://shape_mob.tres").size = Vector2(16,16)
		load("res://shape_mob_hit.tres").size = Vector2(18,18)
		get_node("TextureProgressBar").position = Vector2(-16,-20)
		get_node("TextureProgressBar").size = Vector2(32,4)
	if id == 1: ##zombie
		health_max = 100
		get_node("Texture2D").texture = load("res://Textures/Mobs/zombie.png")
		load("res://shape_mob.tres").size = Vector2(18,26)
		load("res://shape_mob_hit.tres").size = Vector2(20,28)
		get_node("TextureProgressBar").position = Vector2(-16,-64)
		get_node("TextureProgressBar").size = Vector2(32,4)
		self.position.y -= 10
	if id == 2: ##bee
		health_max = 3
		get_node("Texture2D").texture = load("res://Textures/Mobs/bee.png")
		load("res://shape_mob.tres").size = Vector2(8,4)
		load("res://shape_mob_hit.tres").size = Vector2(20,6)
		get_node("TextureProgressBar").position = Vector2(-8,-8)
		get_node("TextureProgressBar").size = Vector2(16,2)
	if id == 3: ##shadow boss
		health_max = 1000
		get_node("Texture2D").texture = load("res://Textures/Mobs/boss.png")
		load("res://shape_mob.tres").size = Vector2(18,16)
		load("res://shape_mob_hit.tres").size = Vector2(18,16)
		get_node("/root/World").get_node("StatsPlayer/BossBar").visible = true
		get_node("/root/World").get_node("StatsPlayer/BossBar").max_value = health_max
		get_node("/root/World").get_node("StatsPlayer/BossBar").value = health_max
		get_node("/root/World").get_node("StatsPlayer/BossBar/Name").text = "Shadow Boss"
	if id == 4: ##shadow sbires
		health_max = 100
		get_node("Texture2D").texture = load("res://Textures/Mobs/shaded_sbire.png")
		load("res://shape_mob.tres").size = Vector2(16,16)
		load("res://shape_mob_hit.tres").size = Vector2(16,16)
		get_node("TextureProgressBar").position = Vector2(-16,-24)
		get_node("TextureProgressBar").size = Vector2(32,4)

	get_node("TextureProgressBar").max_value = health_max

func _process(_delta):
	
	if VarGlobales.Teleportation > 0:
		if id == 0:
			VarGlobales.mob_caps["Sheep"] -= 1
		if id == 1:
			VarGlobales.mob_caps["Zombie"] -= 1
		if id == 2:
			VarGlobales.mob_caps["Bee"] -= 1
		if id == 3:
			VarGlobales.mob_caps["Shadow Boss"] -= 1
		if id == 4:
			VarGlobales.mob_caps["Shadow Sbire"] -= 1
		queue_free()
	
	chunk = floor(self.position.x/32/32)
	
	if VarGlobales.save_mobs == 1:
		if "Chunk"+str(chunk) in VarGlobales.mobs_saving: ## Ajouter le mob dans le dictionnaire index de son chunk
			VarGlobales.mobs_saving["Chunk"+str(chunk)].append([id,position.x,position.y,health])
		else:
			VarGlobales.mobs_saving["Chunk"+str(chunk)] = [] ## La valeur du dictionnaire, une liste
			VarGlobales.mobs_saving["Chunk"+str(chunk)].append([id,position.x,position.y,health]) ## Ajouter le mob (liste) dans la liste
		VarGlobales.number_save_mobs += 1
		var mob_caps = int(VarGlobales.mob_caps["Sheep"])+int(VarGlobales.mob_caps["Zombie"])+int(VarGlobales.mob_caps["Bee"])
		if VarGlobales.number_save_mobs == mob_caps:
			print(VarGlobales.mobs_saving)
			VarGlobales.save_mobs = 2
			VarGlobales.number_save_mobs = 0
			
	

	if VarGlobales.inGUI < 1:
		
		## Dégats de void
		if get_node_or_null("/root/World") != null:
			if position.y/32 >= get_node("/root/World").world_depth+10:
				if id == 0:
					VarGlobales.mob_caps["Sheep"] -= 1
				if id == 1:
					VarGlobales.mob_caps["Zombie"] -= 1
				if id == 2:
					VarGlobales.mob_caps["Bee"] -= 1
				if id == 3:
					VarGlobales.mob_caps["Shadow Boss"] -= 1
				if id == 4:
					VarGlobales.mob_caps["Shadow Sbire"] -= 1
				queue_free()
		
		if VarGlobales.WorldMode == 0:
			if hit_delay > 0:
				hit_delay -= 1
			if player_in == 1:
				if hit_delay == 0:
					if id == 1:
						VarGlobales.health -= 10
						MusicController.play_player_hit_sound()
					if id == 2:
						VarGlobales.health -= 5
						MusicController.play_player_hit_sound()
					if id == 3:
						VarGlobales.health -= 50
						MusicController.play_player_hit_sound()
					if id == 4:
						VarGlobales.health -= 10
						MusicController.play_player_hit_sound()
						queue_free()
					if VarGlobales.health <= 0:
						VarGlobales.death = 1
						VarGlobales.stats_value[7] += 1
						get_node("../../World/CanvasLayer_GUI/DeadGUI/PanelPrincipal/Label2").text = str("DEAD_CAUSE2")
					hit_delay = 25
			
		ia()
	
	if Input.is_action_just_pressed("mouse_breakblock") or clicktest == 1 and clickmode == 0:
		if mouse_in == 1:
			if VarGlobales.inv_slot_cooldown_max[VarGlobales.slot_selected-1] == -1:
				
				if get_tree().is_server(): ## MULTI
					if VarGlobales.potions_active[1] == 1: ## Si la potion de force est activée
						rpc("hit_by_damager", 1)
					if VarGlobales.item_tool[VarGlobales.inv_slot[VarGlobales.slot_selected-1]] == 4:
						rpc("hit_by_damager", 1+VarGlobales.item_tool_level[VarGlobales.inv_slot[VarGlobales.slot_selected-1]]*5-5)
					else:
						rpc("hit_by_damager", 1)
						
				else: ## PAS MULTI
					modulate = Color(1, 0, 0, 1)
					hit_timer.start()
					MusicController.play_player_hit_sound()
					if VarGlobales.potions_active[1] == 1: ## Si la potion de force est activée
						health -= 1
					if VarGlobales.item_tool[VarGlobales.inv_slot[VarGlobales.slot_selected-1]] == 4:
						health -= 1+VarGlobales.item_tool_level[VarGlobales.inv_slot[VarGlobales.slot_selected-1]]*5-5
					else:
						health -= 1
					get_node("TextureProgressBar").value = health
					if health <= 0:
						if id == 0:
							VarGlobales.spawn_item(position,74,1)
							VarGlobales.spawn_item(position,71,1)
							VarGlobales.mob_caps["Sheep"] -= 1
						if id == 1:
							VarGlobales.spawn_item(position,75,1)
							VarGlobales.mob_caps["Zombie"] -= 1
						if id == 2:
							VarGlobales.spawn_item(position,76,1)
							VarGlobales.mob_caps["Bee"] -= 1
						if id == 3:
							VarGlobales.spawn_item(position,60,rng.randi_range(2,5))
							VarGlobales.spawn_item(position,140,1)
							VarGlobales.mob_caps["Shadow Boss"] -= 1
							VarGlobales.achievements_completed[16] = 1
							get_node("/root/World/StatsPlayer/BossBar").visible = false
						if id == 4:
							VarGlobales.mob_caps["Shadow Sbire"] -= 1
							set_cell(position.x/32,position.y/32,163,get_node("../../World/TileMap"))
						VarGlobales.stats_value[6] += 1
						## Succès tuer les 100 mobs
						if VarGlobales.achievements_completed[2] == 0:
							VarGlobales.achivements_value[2] += 1
						MusicController.play_player_dead_sound()
						queue_free()
		
var clicktest = 0
var clickmode = 0
		
func _unhandled_input(event):
	if OS.get_name() == "Android":
		if event is InputEventScreenTouch:
			if event.is_pressed():
				clicktest = 1
			else:
				clicktest = 0


func ia():
	if visible == true and position.x > VarGlobales.player_positions.x-(19*32) and position.x < VarGlobales.player_positions.x+(19*32):
		if id != 3:
			if health == health_max:
				get_node("TextureProgressBar").visible = false
			else:
				get_node("TextureProgressBar").visible = true
		##IA Gauche Droite Moutons
		if id == 0:
			var ia = rng.randi_range(0,61)
			if ia == 0:
				if get_cell(position.x/32-1,position.y/32-1,get_node("../../World/TileMap")) != -1:
					if get_cell(position.x/32-1,position.y/32-2,get_node("../../World/TileMap")) == -1:
						velocity.y = JUMP_POWER
				velocity.x = -SPEED/(VarGlobales.potions_active[3]+1)
				get_node("Texture2D").flip_h = true
			if ia == 60:
				if get_cell(position.x/32+1,position.y/32-1,get_node("../../World/TileMap")) != -1:
					if get_cell(position.x/32+1,position.y/32-2,get_node("../../World/TileMap")) == -1:
						velocity.y = JUMP_POWER
				velocity.x = SPEED/(VarGlobales.potions_active[3]+1)
				get_node("Texture2D").flip_h = false
		
		if id == 1:
			if VarGlobales.time_hour >= 7 and VarGlobales.time_hour <= 18:
				if get_cell(position.x/32,(position.y/32),get_node("../../World/TileMapLights")) >= 15:
					health -= 0.1
					if int(health) % 5 == 0:
						get_node("MobSounds").play_mob_hit_sound()
					get_node("TextureProgressBar").value = health
					get_node("Fire").visible = true
				else:
					get_node("Fire").visible = false
			if VarGlobales.time_hour >= 19 or VarGlobales.time_hour <= 6:
				get_node("Fire").visible = false
			if position.y != get_node("../../World/CharacterBody2D").position.y:
				if position.x > get_node("../../World/CharacterBody2D").position.x:
						if get_cell(position.x/32-1,position.y/32-1,get_node("../../World/TileMap")) != -1:
							if get_cell(position.x/32-1,position.y/32-2,get_node("../../World/TileMap")) == -1:
								velocity.y = JUMP_POWER*2
						velocity.x = -SPEED/(VarGlobales.potions_active[3]+1)
						get_node("Texture2D").flip_h = true
				if position.x < get_node("../../World/CharacterBody2D").position.x:
						if get_cell(position.x/32+1,position.y/32-1,get_node("../../World/TileMap")) != -1:
							if get_cell(position.x/32+1,position.y/32-2,get_node("../../World/TileMap")) == -1:
								velocity.y = JUMP_POWER*2
						velocity.x = SPEED/(VarGlobales.potions_active[3]+1)
						get_node("Texture2D").flip_h = false
						
		if id == 2:
			if VarGlobales.player_positions.x+3 < position.x:
				position.x -= 2.25/(VarGlobales.potions_active[3]+1)
			if VarGlobales.player_positions.x-3 > position.x:
				position.x += 2.25/(VarGlobales.potions_active[3]+1)
			if VarGlobales.player_positions.y+2 < position.y:
				position.y -= 1.25/(VarGlobales.potions_active[3]+1)
			if VarGlobales.player_positions.y-2 > position.y:
				position.y += 1.25/(VarGlobales.potions_active[3]+1)
				
		if id == 4:
			if VarGlobales.player_positions.x+3 < position.x:
				position.x -= 2/(VarGlobales.potions_active[3]+1)
			if VarGlobales.player_positions.x-3 > position.x:
				position.x += 2/(VarGlobales.potions_active[3]+1)
			if VarGlobales.player_positions.y+2 < position.y:
				position.y -= 2/(VarGlobales.potions_active[3]+1)
			if VarGlobales.player_positions.y-2 > position.y:
				position.y += 2/(VarGlobales.potions_active[3]+1)
				
		if id == 3:
			var spawn_sbires = rng.randi_range(500,1000)
			if spawn_sbires == 999:
				VarGlobales.spawn_mob(Vector2(position.x,position.y-16),4,100)
			get_node("/root/World").get_node("StatsPlayer/BossBar").value = health


func _physics_process(_delta):
	if VarGlobales.inGUI < 1:
		if visible == true:
			if id <= 1 or id == 3:
				#if on_ground == false:
				velocity.y = velocity.y + GRAVITY
				set_velocity(velocity)
				set_up_direction(FLOOR)
				move_and_slide()
				velocity = velocity
				if is_on_floor():
					on_ground = true
				else:
					on_ground = false

	
func _on_Area2D_body_entered(body):
	if id == 1 or id == 2 or id == 3 or id == 4:
		if VarGlobales.WorldState == 2:
			if body.is_in_group("Player") == true:
				player_in = 1
				hit_delay = 100
	
func _on_Area2D_body_exited(body):
	if id == 1 or id == 2 or id == 3 or id == 4:
		if VarGlobales.WorldState == 2:
			if body.is_in_group("Player") == true:
				player_in = 0
				hit_delay = -1

@rpc("any_peer", "call_local") func hit_by_damager(damage):
	health -= damage
	modulate = Color(1, 0, 0, 1)
	hit_timer.start()
	MusicController.play_player_hit_sound()
	if health <= 0:
		if id == 0:
			VarGlobales.spawn_item(position,74,1)
			VarGlobales.spawn_item(position,71,1)
			VarGlobales.mob_caps["Sheep"] -= 1
		if id == 1:
			VarGlobales.spawn_item(position,75,1)
			VarGlobales.mob_caps["Zombie"] -= 1
		if id == 2:
			VarGlobales.spawn_item(position,76,1)
			VarGlobales.mob_caps["Bee"] -= 1
		if id == 3:
			VarGlobales.spawn_item(position,60,rng.randi_range(2,5))
			VarGlobales.mob_caps["Shadow Boss"] -= 1
			VarGlobales.achievements_completed[16] = 1
		if id == 4:
			VarGlobales.mob_caps["Shadow Sbire"] -= 1
		VarGlobales.stats_value[6] += 1
		## Succès tuer les 100 mobs
		if VarGlobales.achievements_completed[2] == 0:
			VarGlobales.achivements_value[2] += 1
		MusicController.play_player_dead_sound()
		queue_free()
	get_node("TextureProgressBar").value = health
	
func _on_hit_timer_timeout():
	modulate = Color(1, 1, 1, 1)


func _on_Area2D_mouse_entered():
	mouse_in = 1

func _on_Area2D_mouse_exited():
	mouse_in = 0
