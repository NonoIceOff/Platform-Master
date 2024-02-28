extends Node2D
var speed = 0.025

#var tilemap = tilemap
var tilemap = null
var tilemap_torch = null
var tilemap_lights = null

var rng = RandomNumberGenerator.new()

var grass_test = FastNoiseLite.new()
var caves = FastNoiseLite.new()
var ore = FastNoiseLite.new()
var tree = FastNoiseLite.new()
var biomenoise = FastNoiseLite.new()
var tempnoise = FastNoiseLite.new()

var index = 0

var ranbiome = 0

var world_depth = 138
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

func id_to_coords(j):
	var tilesPerRow = 11  # Nombre de tuiles par ligne
	var x = j % tilesPerRow
	var y = j / tilesPerRow
	return Vector2(x, y)

func _ready():
	grass_test.seed = VarGlobales.WorldSeed
	grass_test.noise_type = FastNoiseLite.TYPE_PERLIN
	grass_test.frequency = 0.1
	
	tree.seed = VarGlobales.WorldSeed*5.8
	tree.noise_type = FastNoiseLite.TYPE_PERLIN
	tree.fractal_octaves = 2
	tree.fractal_lacunarity = 5
	tree.frequency = 0.25
#
	caves.seed = VarGlobales.WorldSeed/4
	caves.noise_type = FastNoiseLite.TYPE_PERLIN
	caves.frequency = 0.025
	caves.fractal_octaves = 2
	caves.fractal_lacunarity = 5
	
	ore.seed = VarGlobales.WorldSeed/2
	ore.noise_type = FastNoiseLite.TYPE_PERLIN
	ore.frequency = 0.2 ##augmente la taille si - grand
	#ore.fractal_gain = 2
	ore.fractal_weighted_strength = 2
	ore.fractal_octaves = 8 ## séparer
	ore.fractal_lacunarity = 1

	
	biomenoise.seed = VarGlobales.WorldSeed
	biomenoise.noise_type = FastNoiseLite.TYPE_PERLIN
	biomenoise.fractal_gain = 10
	biomenoise.fractal_octaves = 5
	biomenoise.frequency = 0.00075
	
	tempnoise.seed = VarGlobales.WorldSeed/3.14
	tempnoise.noise_type = FastNoiseLite.TYPE_PERLIN
	tempnoise.fractal_gain = 10
	tempnoise.fractal_octaves = 5
	tempnoise.frequency = 0.0075

func _process(delta):
	pass


func get_cell(a, b, node):
	var coords = get_node(node).get_cell_atlas_coords(0, Vector2(a, b), false)
	var id = coords.y * 11 + coords.x
	if id < -1:
		return -1
	return id
	
func set_cell(a, b, id, node):
	if id != -1:
		var coordinates = id_to_coords(id)
		get_node(node).set_cell(0, Vector2(a, b), 0, Vector2i(coordinates.x, coordinates.y))
	else:
		if id in [10,11,147,148,149,150]:
			place_liquid(a,b,id)
		get_node(node).set_cell(0, Vector2(a, b), 0, Vector2i(-1, -1))

func place_liquid(x, y, id):
	var existing_id = get_cell(x, y, tilemap)
	if existing_id != -1:
		return  # Ne place pas de liquide s'il y a déjà quelque chose à cet endroit

	set_cell(x, y, id, tilemap)
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

		var existing_id = get_cell(nx, ny,tilemap)
		if existing_id == -1:
			set_cell(nx, ny, id, tilemap)
			propagate_liquid(Vector2(nx, ny), id)
	
func gen_block(x,y,id):
	set_cell(x,y,id,tilemap)

func top_y(x):
	var top = -1
	var y = world_depth
	while top == -1:
		if get_cell(x,y,tilemap) == -1:
			return y
		else:
			y -= 1
	return top


func new_block(x : int,y : int,id : int) -> void:
	if not id == -1:
		if VarGlobales.shadows == true:
			if id == 135 or id == 141:
				if VarGlobales.achievements_completed[18] == 0:
					VarGlobales.new_achievement(18)
				
		tilemap.set_cell(x,y,id)
		
	if id == -1:
		if VarGlobales.shadows == true:
			if tilemap.get_cell(x,y) == 136:
				for cle in VarGlobales.blocks_nbt:
					if cle[0] == x and cle[1] == y:
						for i in VarGlobales.blocks_nbt[cle][1].size():
							if VarGlobales.blocks_nbt[cle][1][i] != []:
								VarGlobales.spawn_item(Vector2(x,y)*16,VarGlobales.blocks_nbt[cle][1][i][0],VarGlobales.blocks_nbt[cle][1][i][1],VarGlobales.blocks_nbt[cle][1][i][2])
						VarGlobales.blocks_nbt.erase(cle)
			if tilemap.get_cell(x,y) == 174:
				for cle in VarGlobales.blocks_nbt:
					if cle[0] == x and cle[1] == y:
						VarGlobales.blocks_nbt.erase(cle)
					
		tilemap.set_cell(x,y,-1)

func new_biome(nbr_region):
	if VarGlobales.WorldBiome == 0:
		var temperature = 0
		# -1 Froid | 0 Normal | 1 Chaud
		#["PLAINS","DESERT","COLD PLAINS","BIRCH FOREST","RIPARIAN FOREST","OCEAN"]
		var biomes = [
			[1], #FROID
			[0,3,4,5], #NORMAL
			[2] #CHAUD
		]
		var rantemp = tempnoise.get_noise_2d((get_global_transform().origin.x/16 + nbr_region),nbr_region)
		if rantemp < .25 and rantemp > -0.25:
			temperature = 1
		elif rantemp <= -0.25:
			temperature = 0
		else:
			temperature = 2
		var ranbiome = floor(abs(biomenoise.get_noise_2d((get_global_transform().origin.x/16 + nbr_region),nbr_region)*10))
		
		var maxbiome = int(biomes[temperature].size())-1
		if ranbiome > maxbiome:
			ranbiome = maxbiome
		VarGlobales.chunk_biome[nbr_region] = biomes[temperature][ranbiome]
	if VarGlobales.WorldBiome > 0:
		VarGlobales.chunk_biome[nbr_region] = VarGlobales.WorldBiome-1

func wait(sec):
	if sec == 0:
		return 0
	var t = Timer.new()
	t.set_wait_time(sec)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await t.timeout
	t.queue_free()

func ungen_world(nbr_region):
	for x in range(0,16):
		for y in range(-25,world_depth):
			gen_block((nbr_region*16)+x,y,-1)
	print("Chunk ungenered")

func gen_world(nbr_region,mode):
		VarGlobales.chunk_biome[nbr_region] = 0
		new_biome(nbr_region-1)
		new_biome(nbr_region)
		new_biome(nbr_region+1)
		for x in range(0,16):
			gen_biome((nbr_region*16)+x,VarGlobales.chunk_biome[nbr_region],nbr_region,mode)
			await wait(speed)

func gen_ores(x,yy,biome):
	if get_cell(x,yy,tilemap) == -1:
		return 0
	var ores = [
		[3,39,3,3,3,3],
		[4,40,4,4,4,4],
		[5,41,5,5,5,5],
		[6,42,6,6,6,6],
		[7,43,7,7,7,7],
		[8,44,8,8,8,8],
		[-1,-1,-1,-1,-1,-1]
	]
	
	##COAL_ORE
	if (ore.get_noise_2d(x,yy) > 0.2) and yy > 10 and yy < 35 and get_cell(x,yy,tilemap) != 111:
		gen_block(x,yy,ores[0][biome])
	##IRON_ORE
	if (ore.get_noise_2d(x,yy) > 0.3) and yy > 30 and yy < 60 and get_cell(x,yy,tilemap) != 111:
		gen_block(x,yy,ores[1][biome])
	##RUBY_ORE
	if (ore.get_noise_2d(x,yy) > 0.35) and yy > 55 and yy < 85 and get_cell(x,yy,tilemap) != 111:
		gen_block(x,yy,ores[2][biome])
	##SAPH_ORE
	if (ore.get_noise_2d(x,yy) > 0.4) and yy > 80 and yy < 110 and get_cell(x,yy,tilemap) != 111:
		gen_block(x,yy,ores[3][biome])
	##EMERALD_ORE
	if (ore.get_noise_2d(x,yy) > 0.4) and yy > 105 and yy < 142 and get_cell(x,yy,tilemap) != 111:
		gen_block(x,yy,ores[4][biome])
	##ELECTRITIUM_ORE
	if (ore.get_noise_2d(x,yy) > 0.45) and yy > 120 and yy < 142 and get_cell(x,yy,tilemap) != 111:
		gen_block(x,yy,ores[5][biome])

func transi_biome(x,y):
	var numberblock = VarGlobales.rng.randi_range(0,25)
	if numberblock >= 0 and numberblock < 10:
		gen_block(x,y,2)
	elif numberblock >= 10 and numberblock < 20:
		gen_block(x,y,13)
	else:
		gen_block(x,y,149)
	

func gen_biome(x,id,nbr_region,mode):
	x = int(x)
	## [grass block, dirt, stone, grass, water surface, biome transi, stone level multiplier,stone variation y multiplier, grass amount, tree amont,treetype]
	var blocks_biome = [
		[0,1,2,[108,108,108,108,151,108,152],1,1,20,0,2,0,0.5,0],
		[12,12,13,-1,0,0,36,0,2,0,0,1],
		[14,1,2,-1,1,1,20,0,2,0,0.5,2],
		[0,1,2,[108,108,108,151],1,1,46,0,2,-1,0.25,3],
		[0,1,2,[108,108,108,154],1,1,64,0,2,0,0.25,4],
		[12,12,2,-1,1,0,20,20,5,0,0,-1]
	]
	
	VarGlobales.WorldSurfaceHeight = blocks_biome[id][6]
	var old_y = floor(grass_test.get_noise_2d((get_global_transform().origin.x + x)*.1,0)*VarGlobales.WorldSurfaceHeight)
	var frac_x = 0
	if x % 16 != 0:
		frac_x = (x % 16)/100
	var y = ( (old_y*frac_x) + ( smooth_biome(x,nbr_region) * (100-frac_x) ) /100)
	if id != 5:
		## SURFACE
		gen_block(x,y,blocks_biome[id][0])
		
		if typeof(blocks_biome[id][3]) == TYPE_ARRAY:
			if get_cell(x,1,tilemap) == -1:
				if grass_test.get_noise_2d(x,y-1) >= blocks_biome[id][10]:
					var randomgrass = VarGlobales.rng.randi_range(0,blocks_biome[id][3].size())
					for i in range(0,blocks_biome[id][3].size()):
						if randomgrass == i:
							gen_block(x,y-1,blocks_biome[id][3][i])
					
		if blocks_biome[id][4] == 1 and mode == 1:
			water_surface(x)
		
		##TROUPEAU MOUONS
		if genpics <= 0:
			var numberpics = VarGlobales.rng.randi_range(50,100)
			genpics = numberpics+1
			if numberpics > 0:
				spawn_troupeau_moutons(x,y)
		else:
			genpics -= 1
			
		if get_cell(x,y,tilemap) != -1 and get_cell(x,y-1,tilemap) != 10 and get_cell(x,y-1,tilemap) != 11:
			if id == 3 or id == 4:
				##STONE PICS
				if genpics <= 0:
					var numberpics = VarGlobales.rng.randi_range(5,10)
					genpics = numberpics+1
					if numberpics > 0 and id == 3:
						spawn_stone_pics(x,y)
					if numberpics > 0 and id == 4:
						spawn_lake(x,y)
				else:
					genpics -= 1
			##ARBRES
			if tree.get_noise_2d(x,y-1) >= blocks_biome[id][10]:
				spawn_tree(x,y,blocks_biome[id][11])
						
	else: ## oceans
		y = floor(grass_test.get_noise_2d((get_global_transform().origin.x + x)*.1,0)*VarGlobales.WorldSurfaceHeight)+40
		## SURFACE
		gen_block(x,y,blocks_biome[id][0])
		water_surface(x)
		
		
		
	## UNDERGROUND
	var stone_y = floor(grass_test.get_noise_2d((get_global_transform().origin.x + x)*.1,0)*VarGlobales.WorldSurfaceHeight)
	if id == 5:
		stone_y += 40
	for yy in range(y+1,world_depth):
		await wait(speed)
		if yy > 25 and mode == 0:
			return 0
		if yy > blocks_biome[id][7]+world_depth*0.05+stone_y:
			var ranore = int(pow(int( str(VarGlobales.WorldSeed)[1] ) , int( str(VarGlobales.WorldSeed)[2] )) + x)
			## STONE
			if caves.get_noise_2d(x,yy) > -0.35 and caves.get_noise_2d(x,yy) < 0.35:
				var biome_transi = blocks_biome[id][5]
				if VarGlobales.chunk_biome[nbr_region] != biome_transi and VarGlobales.chunk_biome[nbr_region+1] == biome_transi and x == 16*(nbr_region+1)-1: # Si biome sable à droite
					transi_biome(x,yy)
				elif VarGlobales.chunk_biome[nbr_region] != biome_transi and VarGlobales.chunk_biome[nbr_region-1] == biome_transi and x == 16*nbr_region: # Si biome sable à gauche
					transi_biome(x,yy)
				else:
					gen_block(x,yy,blocks_biome[id][2])
			else:
				if yy < 100:
					gen_block(x,yy,-1)
				else:
					gen_block(x,yy,158)
					if yy == 100:
						gen_block(x,yy,157)
			if id != 5:
				gen_ores(x,yy,id)
			
		else:
			gen_block(x,yy,blocks_biome[id][1])
			
	## LAST BLOCK
	gen_block(x,world_depth,9)
		
	## TRANSI OCEAN AUTRE BIOME
	var negatif = 1
	var offset_negatif = 0
	var offset_x = 0
	if x < 0:
		negatif = -1
		offset_negatif = 16
		offset_x = 1
	if not VarGlobales.chunk_biome.has(nbr_region-1):
		new_biome(nbr_region-1)
	if not VarGlobales.chunk_biome.has(nbr_region+1):
		new_biome(nbr_region+1)
		
	if VarGlobales.chunk_biome[nbr_region-1] != 5 and id == 5:
		var last_biome_id = biome_id(nbr_region-1)
		var y_ancien_biome = floor(grass_test.get_noise_2d((get_global_transform().origin.x + x)*.1,0)*blocks_biome[last_biome_id][6])
		var y_ocean =  floor(grass_test.get_noise_2d((get_global_transform().origin.x + x)*.1,0)*blocks_biome[id][6])
		
		for i in range(0,y_ocean+42-x%16):
			var frac_xo = 0
			if x % 16 != 0:
				frac_xo = (x % 16)/100
			var new_y = ( (y_ancien_biome*frac_xo) + ( y_ocean * (100-frac_xo ) /100) )+x%16
			gen_block(x,new_y+i,blocks_biome[id][1])
			

func smooth_biome(x,nbr_region):
	var blocks_biome = [
		[0,1,2,[108,108,108,108,151,108,152],1,1,20,0,2,0,0.5,0],
		[12,12,13,-1,0,0,36,0,2,0,0,1],
		[14,1,2,-1,1,1,20,0,2,0,0.5,2],
		[0,1,2,[108,108,108,151],1,1,46,0,2,-1,0.25,3],
		[0,1,2,[108,108,108,154],1,1,64,0,2,0,0.25,4],
		[12,12,2,-1,1,0,20,20,5,0,0,-1]
	]
	var last_biome_id = biome_id(nbr_region-1)
	VarGlobales.WorldSurfaceHeight = blocks_biome[last_biome_id][6]
	var y = floor(grass_test.get_noise_2d((get_global_transform().origin.x + x)*.1,0)*VarGlobales.WorldSurfaceHeight)
	return y
	
func biome_id(nbr_region):
	if VarGlobales.chunk_biome.has(nbr_region):
		return VarGlobales.chunk_biome[nbr_region]
	else:
		return 0

func water_surface(x):
	var ransand = VarGlobales.rng.randi_range(0,2)
	for water in range(VarGlobales.WorldWaterLevel,world_depth):
		await wait(1)
		if get_cell(x,water,tilemap) == -1:
			if get_cell(x,water-1,tilemap) == 10 or get_cell(x,water-1,tilemap) == 11:
				set_cell(x,water,11,tilemap)
			else:
				set_cell(x,water,10,tilemap)
		else:
			if get_cell(x,water-1,tilemap) == 11 or get_cell(x,water-1,tilemap) == 10:
				if ransand == 0:
					set_cell(x,water,12,tilemap)
				elif ransand == 1:
					set_cell(x,water,80,tilemap)
				else:
					set_cell(x,water,1,tilemap)
					
func water_surface_desert(x):
	for water in range(VarGlobales.WorldWaterLevel,world_depth):
		if get_cell(x,water,tilemap) == -1:
			if get_cell(x,water-1,tilemap) == 10 or get_cell(x,water-1,tilemap) == 11:
				set_cell(x,water,11,tilemap)
			else:
				set_cell(x,water,10,tilemap)
		else:
			if get_cell(x,water-1,tilemap) == 11 or get_cell(x,water-1,tilemap) == 10:
				set_cell(x,water,12,tilemap)

func spawn_tree(x,y,id):
	if get_cell(x,y-1,tilemap) == -1:
		if id == 0:
			spawn_oak_tree(x,y)
		if id == 1:
			spawn_cactus(x,y)
		if id == 2:
			spawn_pine_tree(x,y)
		if id == 3:
			spawn_birch_tree(x,y)
		if id == 4:
			spawn_poplar_tree(x,y)

func spawn_oak_tree(x,y):
	var random_tree = VarGlobales.rng.randi_range(0,2)
	if random_tree == 0:
		set_cell(x,y,1,tilemap)
		set_cell(x,y-1,16,tilemap)
		set_cell(x,y-2,16,tilemap)
		set_cell(x,y-3,16,tilemap)
		set_cell(x,y-4,17,tilemap)
		set_cell(x-1,y-4,17,tilemap)
		set_cell(x+1,y-4,17,tilemap)
		set_cell(x,y-5,17,tilemap)
		set_cell(x+1,y-5,17,tilemap)
		set_cell(x+1,y-4,17,tilemap)
		set_cell(x-1,y-4,17,tilemap)
	if random_tree == 1:
		set_cell(x,y,1,tilemap)
		set_cell(x,y-1,16,tilemap)
		set_cell(x,y-2,16,tilemap)
		set_cell(x,y-3,16,tilemap)
		set_cell(x,y-4,16,tilemap)
		set_cell(x,y-5,17,tilemap)
		set_cell(x-1,y-5,17,tilemap)
		set_cell(x+1,y-5,17,tilemap)
		set_cell(x,y-6,17,tilemap)
		set_cell(x-1,y-6,17,tilemap)
		set_cell(x+1,y-4,17,tilemap)
		set_cell(x-1,y-4,17,tilemap)
	if random_tree == 2:
		set_cell(x,y,1,tilemap)
		set_cell(x,y-1,16,tilemap)
		set_cell(x,y-2,16,tilemap)
		set_cell(x,y-3,16,tilemap)
		set_cell(x,y-4,16,tilemap)
		set_cell(x,y-5,17,tilemap)
		set_cell(x-1,y-5,17,tilemap)
		set_cell(x+1,y-5,17,tilemap)
		set_cell(x,y-6,17,tilemap)
		set_cell(x+1,y-4,17,tilemap)
		set_cell(x-1,y-4,17,tilemap)
		
	
func spawn_pine_tree(x,y):
	var random_tree = VarGlobales.rng.randi_range(0,2)
	if random_tree == 0:
		set_cell(x,y,1,tilemap)
		set_cell(x,y-1,18,tilemap)
		set_cell(x,y-2,18,tilemap)
		set_cell(x,y-3,18,tilemap)
		set_cell(x,y-4,17,tilemap)
		set_cell(x-1,y-4,17,tilemap)
		set_cell(x+1,y-4,17,tilemap)
		set_cell(x,y-5,17,tilemap)
		set_cell(x+1,y-5,17,tilemap)
		set_cell(x+1,y-4,17,tilemap)
		set_cell(x-1,y-4,17,tilemap)
	if random_tree == 1:
		set_cell(x,y,1,tilemap)
		set_cell(x,y-1,18,tilemap)
		set_cell(x,y-2,18,tilemap)
		set_cell(x,y-3,18,tilemap)
		set_cell(x,y-4,18,tilemap)
		set_cell(x,y-5,17,tilemap)
		set_cell(x-1,y-5,17,tilemap)
		set_cell(x+1,y-5,17,tilemap)
		set_cell(x,y-6,17,tilemap)
		set_cell(x-1,y-6,17,tilemap)
		set_cell(x+1,y-4,17,tilemap)
		set_cell(x-1,y-4,17,tilemap)
	if random_tree == 2:
		set_cell(x,y,1,tilemap)
		set_cell(x,y-1,18,tilemap)
		set_cell(x,y-2,18,tilemap)
		set_cell(x,y-3,18,tilemap)
		set_cell(x,y-4,18,tilemap)
		set_cell(x,y-5,17,tilemap)
		set_cell(x-1,y-5,17,tilemap)
		set_cell(x+1,y-5,17,tilemap)
		set_cell(x,y-6,17,tilemap)
		set_cell(x+1,y-4,17,tilemap)
		set_cell(x-1,y-4,17,tilemap)

func spawn_birch_tree(x,y):
	var random_tree = VarGlobales.rng.randi_range(0,2)
	set_cell(x,y,1,tilemap)
	set_cell(x,y-1,45,tilemap)
	set_cell(x,y-2,45,tilemap)
	set_cell(x,y-3,45,tilemap)
	set_cell(x,y-4,45,tilemap)
	set_cell(x,y-5,45,tilemap)
	set_cell(x,y-6,45,tilemap)
	set_cell(x,y-7,17,tilemap)
	set_cell(x,y-8,17,tilemap)
	set_cell(x-1,y-7,17,tilemap)
	set_cell(x+1,y-7,17,tilemap)
	set_cell(x+1,y-8,17,tilemap)
	set_cell(x+1,y-6,17,tilemap)
	set_cell(x-1,y-6,17,tilemap)
	if random_tree == 1:
		set_cell(x+1,y-4,45,tilemap)
		set_cell(x+2,y-5,45,tilemap)
		set_cell(x+2,y-6,17,tilemap)
	if random_tree == 2:
		set_cell(x-1,y-4,45,tilemap)
		set_cell(x-2,y-5,45,tilemap)
		set_cell(x-2,y-6,17,tilemap)

func spawn_poplar_tree(x,y):
	var random_tree = VarGlobales.rng.randi_range(0,2)
	set_cell(x,y,1,tilemap)
	set_cell(x,y-1,46,tilemap)
	set_cell(x,y-2,46,tilemap)
	set_cell(x,y-3,46,tilemap)
	set_cell(x,y-4,46,tilemap)
	set_cell(x,y-5,46,tilemap)
	set_cell(x,y-6,46,tilemap)
	set_cell(x,y-7,46,tilemap)
	set_cell(x,y-8,46,tilemap)
	set_cell(x+1,y-3,17,tilemap)
	set_cell(x+1,y-4,17,tilemap)
	set_cell(x+1,y-5,17,tilemap)
	set_cell(x+1,y-6,17,tilemap)
	set_cell(x+1,y-7,17,tilemap)
	set_cell(x+1,y-8,17,tilemap)
	set_cell(x-1,y-3,17,tilemap)
	set_cell(x-1,y-4,17,tilemap)
	set_cell(x-1,y-5,17,tilemap)
	set_cell(x-1,y-6,17,tilemap)
	set_cell(x-1,y-7,17,tilemap)
	set_cell(x-1,y-8,17,tilemap)
	set_cell(x-1,y-9,17,tilemap)
	set_cell(x,y-9,17,tilemap)
	set_cell(x+1,y-9,17,tilemap)

func spawn_cactus(x,y):
	##ARBRES
	var rantree = int(pow(int( str(VarGlobales.WorldSeed)[0] ) , int( str(VarGlobales.WorldSeed)[1] )) + x/16)
	var numbertree = 0
	if rantree % 2 == 0:
		numbertree = 5
	if rantree % 3 == 0:
		numbertree = 7
	if rantree % 5 == 0:
		numbertree = 9
	if numbertree > 0:
		if x % numbertree == 0:
			if x % 2 != 0:
				gen_block(x,y,12)
				gen_block(x,y-1,19)
				if numbertree > 5:
					gen_block(x,y-2,19)
				if numbertree > 9:
					gen_block(x,y-3,19)

func spawn_shaded_tree(x,y):
	set_cell(x,y,103,tilemap)
	for i in VarGlobales.rng.randi_range(1,5):
		set_cell(x,y-i,106,tilemap)

func spawn_stone_pics(x,y):
	set_cell(x,y,2,tilemap)
	set_cell(x,y-1,2,tilemap)
	set_cell(x+1,y-1,2,tilemap)
	set_cell(x+1,y,2,tilemap)
	set_cell(x-1,y,2,tilemap)

func spawn_lake(x,y):
	set_cell(x-2,y,1,tilemap)
	if get_cell(x-1,y-1,tilemap) != 108:
		set_cell(x-1,y,10,tilemap)
	set_cell(x,y,10,tilemap)
	if get_cell(x+1,y-1,tilemap) != 108:
		set_cell(x+1,y,10,tilemap)
	set_cell(x+2,y,1,tilemap)

func spawn_shaded_structure(x,y,jigsaws_nbr):
	if jigsaws_nbr >= 0:
		spawn_shaded_structure_central(x,y,jigsaws_nbr-1)
	
func spawn_shaded_structure_central(x,y,jigsaws_nbr):
	var jigsaws_nbr1 = 0
	var jigsaws_nbr2 = 0
	if jigsaws_nbr >= 0:
		var hauteur = 10
		var longueur = 14
		for i in longueur+1: ## MURS DE LA STRUCTURE
			set_cell(x+i,y+1,112,tilemap)
			set_cell(x+i,y-hauteur,112,tilemap)
			for j in hauteur:
				set_cell(x+i,y-j,111,tilemap)
				set_cell(x+1-1,y-j,112,tilemap)
				set_cell(x+longueur,y-j,112,tilemap)
				
		set_cell(x+(longueur/2),y-hauteur/2,107,tilemap) ## ELEMENTS DE LA STRUCTURE
		set_cell(x+(longueur/2),y-hauteur/2+1,141,tilemap)
		for w in range(0,hauteur+1):
			if w < hauteur/2 or w > hauteur-(hauteur/3):
				set_cell(x+(longueur/2),y-w+1,141,tilemap)
				if w%2 == 0:
					for ww in range(-w/2,w/2+1):
						set_cell(x+(longueur/2)-ww,y-w+1,113,tilemap)
		for i in range(0,longueur+1,5):
			if i == 0 or i == longueur:
				set_cell(x+i,y-1,124,tilemap)
				set_cell(x+i,y,111,tilemap)
						
		jigsaws_nbr1 = spawn_shaded_structure_corridor(x+longueur,y,floor(jigsaws_nbr/2),"right")
		jigsaws_nbr2 = spawn_shaded_structure_corridor(x-longueur*1.5+1,y,floor(jigsaws_nbr/2),"left")
	return jigsaws_nbr1 + jigsaws_nbr2
		
func spawn_shaded_structure_corridor(x,y,jigsaws_nbr,dir):
	if jigsaws_nbr >= 0:
		var hauteur = 3
		var longueur = 20
		for i in longueur+1: ## MURS DE LA STRUCTURE
			set_cell(x+i,y+1,112,tilemap)
			set_cell(x+i,y-hauteur,112,tilemap)
			for j in hauteur:
				set_cell(x+i,y-j,111,tilemap)
				set_cell(x+1-1,y-j,112,tilemap)
				set_cell(x+longueur,y-j,112,tilemap)
		for i in range(0,longueur+1,5):
			if i == 0 or i == longueur:
				set_cell(x+i,y-1,124,tilemap)
				set_cell(x+i,y,111,tilemap)
			else:
				set_cell(x+i,y+1,141,tilemap)
		if dir == "right":
			jigsaws_nbr = spawn_shaded_structure_mob_spawner(x+longueur,y,jigsaws_nbr-1,"right")
		if dir == "left":
			jigsaws_nbr = spawn_shaded_structure_mob_spawner(x-longueur*1.5+1,y,jigsaws_nbr-1,"left")
	return jigsaws_nbr
	
func spawn_shaded_structure_mob_spawner(x,y,jigsaws_nbr,dir):
	if jigsaws_nbr >= 0:
		var hauteur = 10
		var longueur = 10
		for i in longueur+1: ## MURS DE LA STRUCTURE
			set_cell(x+i,y+1,112,tilemap)
			set_cell(x+i,y-hauteur,112,tilemap)
			for j in hauteur:
				set_cell(x+i,y-j,111,tilemap)
				set_cell(x+1-1,y-j,112,tilemap)
				set_cell(x+longueur,y-j,112,tilemap)
		for i in range(0,longueur+1,5):
			if i == 0 or i == longueur:
				set_cell(x+i,y-1,124,tilemap)
				set_cell(x+i,y,111,tilemap)
			else:
				set_cell(x+i,y+1,141,tilemap)
		set_cell(x+5,y-5,139,tilemap)
		
		set_cell(x+4,y-6,141,tilemap)
		set_cell(x+5,y-6,141,tilemap)
		set_cell(x+6,y-6,141,tilemap)
		if dir == "right":
			jigsaws_nbr = spawn_shaded_structure_corridor(x+longueur,y,jigsaws_nbr-1,"right")
		if dir == "left":
			jigsaws_nbr = spawn_shaded_structure_corridor(x-longueur*1.5+1,y,jigsaws_nbr-1,"left")
	return jigsaws_nbr

func spawn_troupeau_moutons(x,y):
		if VarGlobales.mob_caps["Sheep"] < 25:
			var numbersheep = VarGlobales.rng.randi_range(1,3)
			for i in numbersheep:
#				VarGlobales.spawn_mob(Vector2(x-i,-20)*16,0,25)
				pass

