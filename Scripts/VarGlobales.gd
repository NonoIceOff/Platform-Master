extends Node

var demo = 0

var rng = RandomNumberGenerator.new()
var VersionName = "1.0"

var mob = preload("res://Scènes/Mob.tscn")
var item = preload("res://Scènes/Item.tscn")

var save_mobs = 0
var number_save_mobs = 0
var save_items = 0
var number_save_items = 0

##{chunk:[ [id_mob,x,y,health],[id_mob,x,y,health] ] ,}
var mobs_saving = {}

##{chunk:[ [id_item,x,y,count,tag],[id_item,x,y,count,tag] ] ,}
var items_saving = {}

var Mode = {"survival":0, "cheat":1, "vision":2}

##Options Infos
var effects_volume = 80
var player_volume = 80
var blocks_volume = 80
var music_volume = 80
var fov = 1.5
var particules = true
var shadows = true
var resolution = [1280,720]
var fullscreen = false
var nickname = "PLAYER"

var color_nickmane = Color(1,1,1)
var color_hair = Color(1,1,1)
var color_tshirt = Color(1,1,1)
var color_legs = Color(1,1,1)
var skin_head_shape = 1
var skin_hair_style = 1

##World Infos
var pause = 0
var pose_x = 0
var pose_y = 0
var health = 100
var food = 100
var saturation = 0
var death = 0
var destroy_items = 0
##INDEX | 1 - Health | 2 - Force
var potions_active = [0,0]
var potions_timer = [0,0]
var spawnpoint = Vector2(0,-6)
var time_day = 1
var time_hour = 9
var time_min = 0
var time_sec = 0
var time_tick = time_hour*60*60

#1 = Normal | 2 = Shadow
var WorldDimension = 1
var WorldDimensionNames = ["Earth","Shadow"]
#0 = génère/1 = load/2 = jouable
var WorldSize = 4000
var WorldState = 2
var WorldBiome = 0
var WorldMode = 1
var WorldName = "none"
var WorldFile = ""
var WorldSeed = 656456475454655
var WorldAchievementLocked = 0
var WorldSaveVersion = 2.1
var WorldThumbnail = 0
var WorldWaterLevel = 2
var WorldSurfaceHeight = 36
var WorldParty = 0

var ServerMode = 0
var ServerPlayer = -1
var ServerInfos = ["",-1,[],[]] #theme, plot visu, [plot points], [pseudos]
var ServerOn = 0

var player_positions = Vector2(0,0)

var LoadedRegions = {"Chunk0":1,"Chunk1":1}
var LoadedTimes = 1

##Mob Caps
var mob_caps = {"Sheep":0,"Zombie":0,"Bee":0,"Shadow Boss":0,"Shadow Sbire":0}
var mob_names = ["Sheep","Zombie","Bee","Shadow Boss","Shadow Sbire"]
var items_number = 0

var inGUI = 0

var click_slot = 0

var slot_selected = 1

## "BLOCID": [ ItemTexture , Name , [Tags] , Hardness , Category , Tool needed , Item tool type , Level needed , Item tool level , Pose ID , Drop ID) , Light State]
## Category : 0 Bloc | 1 Item

var collection = {
	"0": 	["res://Textures/Blocks/grass_block.png"			, "GRASS_BLOCK"				, ["dirt"]						, 0.1 		, 0	,2	,0	,0	,0	,0	,1 , 0],
	"1": 	["res://Textures/Blocks/dirt.png"					, "DIRT"					, ["dirt"]						, 0.1 		, 0	,2	,0	,0	,0	,1	,1 , 0],
	"2": 	["res://Textures/Blocks/stone.png"					, "STONE"					,["stone"]						,0.027		, 0	,1	,0	,1	,1	,2	,2	,0],
	"3": 	["res://Textures/Blocks/coal_ore.png"				, "COAL_ORE"				,["stone","ore","coal"]			,0.01		, 0	,1	,0	,1	,0	,3	,55	,0],
	"4": 	["res://Textures/Blocks/iron_ore.png"				, "IRON_ORE"				,["stone","ore","iron"]			,0.008		, 0	,1	,0	,2	,0	,4	,56	,0],
	"5": 	["res://Textures/Blocks/ruby_ore.png"				, "RUBY_ORE"				,["stone","ore","ruby"]			,0.0075		, 0	,1	,0	,3	,0	,5	,57	,0],
	"6": 	["res://Textures/Blocks/sapphire_ore.png"			, "SAPPHIRE_ORE"			,["stone","ore","sapphire"]		,0.005		, 0	,1	,0	,4	,0	,6	,58	,0],
	"7": 	["res://Textures/Blocks/emerald_ore.png"			, "EMERALD_ORE"				,["stone","ore","emerald"]		,0.0009		, 0	,1	,0	,5	,0	,7	,59	,0],
	"8": 	["res://Textures/Blocks/void_ore.png"				, "VOID_ORE"				,["stone","ore","void"]			,0.0008		, 0	,1	,0	,6	,0	,8	,87	,0],
	"9": 	["res://Textures/Blocks/void_stone.png"				, "VOID_STONE"				,["stone","coal"]				,0.000001	, 0	,1	,0	,6	,0	,9	,9	,0],
	"10": 	["res://Textures/Blocks/water_up.png"				, "WATER_UP"				,["water","fluid"]				,0			, 0	,0	,0	,0	,0	,-1	,-1	,1],
	"11": 	["res://Textures/Blocks/water_down.png"				, "WATER_DOWN"				,["water","fluid"]				,0			, 0	,0	,0	,0	,0	,-1	,-1	,1],
	"12": 	["res://Textures/Blocks/sand.png"					, "SAND"					,["SAND"]						,0.1		, 0	,2	,0	,0	,0	,12	,12	,0],
	"13": 	["res://Textures/Blocks/sandstone.png"				, "SANDSTONE"				,["stone"]						,0.005		, 0	,1	,0	,0	,0	,13	,13	,0],
	"14": 	["res://Textures/Blocks/snowy_grass.png"			, "SNOWY_GRASS"				,["dirt"]						,0.07		, 0	,2	,0	,0	,0	,14	,1	,0],
	"15": 	["res://Textures/Blocks/snow.png"					, "SNOW"					,["SNOW"]						,0.1		, 0	,2	,0	,0	,0	,15	,15	,0],
	"16": 	["res://Textures/Blocks/oak_log.png"				, "OAK_LOG"					,["log","oak"]					,0.05		, 0	,3	,0	,0	,0	,16	,16	,1],
	"17": 	["res://Textures/Blocks/leaves.png"					, "LEAVES"					,["LEAVES"]						,0.5		, 0	,0	,0	,0	,0	,17	,17	,1],
	"18": 	["res://Textures/Blocks/pine_log.png"				, "PINE_LOG"				,["log","pine"]					,0.05		, 0	,3	,0	,0	,0	,18	,18	,1],
	"19": 	["res://Textures/Blocks/cactus.png"					, "CACTUS"					,[]								,0.1		, 0	,0	,0	,0	,0	,19	,19	,1],
	"20": 	["res://Textures/Blocks/assembly_table.png"			, "ASSEMBLY_TABLE"			,[]								,0.01		, 0	,3	,0	,0	,0	,20	,20	,0],
	"21": 	["res://Textures/Items/wooden_pick.png"				, "WOODEN_PICKAXE"			,["WOODEN PICKAXE"]				,0			, 1	,0	,1	,0	,1	,-1	,-1	,0],
	"22": 	["res://Textures/Items/stone_pick.png"				, "STONE_PICKAXE"			,["STONE PICKAXE"]				,0			, 1	,0	,1	,0	,2	,-1	,-1	,0],
	"23": 	["res://Textures/Items/iron_pick.png"				, "IRON_PICKAXE"			,["IRON PICKAXE"]				,0			, 1	,0	,1	,0	,3	,-1	,-1	,0],
	"24": 	["res://Textures/Items/ruby_pick.png"				, "RUBY_PICKAXE"			,["RUBY PICKAXE"]				,0			, 1	,0	,1	,0	,4	,-1	,-1	,0],
	"25": 	["res://Textures/Items/saph_pick.png"				, "SAPPHIRE_PICKAXE"		,["SAPPHIRE PICKAXE"]			,0			, 1	,0	,1	,0	,5	,-1	,-1	,0],
	"26": 	["res://Textures/Items/emerald_pick.png"			, "EMERALD_PICKAXE"			,["EMERALD PICKAXE"]			,0			, 1	,0	,1	,0	,6	,-1	,-1	,0],
	"27": 	["res://Textures/Items/wooden_shovel.png"			, "WOODEN_SHOVEL"			,["WOODEN SHOVEL"]				,0			, 1	,0	,2	,0	,1	,-1	,-1	,0],
	"28": 	["res://Textures/Items/stone_shovel.png"			, "STONE_SHOVEL"			,["STONE SHOVEL"]				,0			, 1	,0	,2	,0	,2	,-1	,-1	,0],
	"29": 	["res://Textures/Items/iron_shovel.png"				, "IRON_SHOVEL"				,["IRON SHOVEL"]				,0			, 1	,0	,2	,0	,3	,-1	,-1	,0],
	"30": 	["res://Textures/Items/ruby_shovel.png"				, "RUBY_SHOVEL"				,["RUBY SHOVEL"]				,0			, 1	,0	,2	,0	,4	,-1	,-1	,0],
	"31": 	["res://Textures/Items/saph_shovel.png"				, "SAPPHIRE_SHOVEL"			,["SAPPHIRE SHOVEL"]			,0			, 1	,0	,2	,0	,5	,-1	,-1	,0],
	"32": 	["res://Textures/Items/eme_shovel.png"				, "EMERALD_SHOVEL"			,["EMERALD SHOVEL"]				,0			, 1	,0	,2	,0	,6	,-1	,-1	,0],
	"33": 	["res://Textures/Items/wooden_axe.png"				, "WOODEN_AXE"				,["WOODEN AXE"]					,0			, 1	,0	,3	,0	,1	,-1	,-1	,0],
	"34": 	["res://Textures/Items/stone_axe.png"				, "STONE_AXE"				,["STONE AXE"]					,0			, 1	,0	,3	,0	,2	,-1	,-1	,0],
	"35": 	["res://Textures/Items/iron_axe.png"				, "IRON_AXE"				,["IRON AXE"]					,0			, 1	,0	,3	,0	,3	,-1	,-1	,0],
	"36": 	["res://Textures/Items/ruby_axe.png"				, "RUBY_AXE"				,["RUBY AXE"]					,0			, 1	,0	,3	,0	,4	,-1	,-1	,0],
	"37": 	["res://Textures/Items/saph_axe.png"				, "SAPPHIRE_AXE"			,["SAPPHIRE AXE"]				,0			, 1	,0	,3	,0	,5	,-1	,-1	,0],
	"38": 	["res://Textures/Items/eme_axe.png"					, "EMERALD_AXE"				,["EMERALD AXE"]				,0			, 1	,0	,3	,0	,6	,-1	,-1	,0],
	"39": 	["res://Textures/Blocks/sandstone_coal_ore.png"		, "SANDSTONE_COAL_ORE"		,["SANDSTONE COAL ORE"]			,0.01		, 0	,1	,0	,1	,0	,39	,55	,0],
	"40": 	["res://Textures/Blocks/sandstone_iron_ore.png"		, "SANDSTONE_IRON_ORE"		,["SANDSTONE IRON ORE"]			,0.008		, 0	,1	,0	,2	,0	,40	,56	,0],
	"41": 	["res://Textures/Blocks/sandstone_ruby_ore.png"		, "SANDSTONE_RUBY_ORE"		,["SANDSTONE RUBY ORE"]			,0.0075		, 0	,1	,0	,3	,0	,41	,57	,0],
	"42": 	["res://Textures/Blocks/sandstone_sapphire_ore.png"	, "SANDSTONE_SAPPHIRE_ORE"	,["SANDSTONE SAPPHIRE ORE"]		,0.005		, 0	,1	,0	,4	,0	,42	,58	,0],
	"43": 	["res://Textures/Blocks/sandstone_emerald_ore.png"	, "SANDSTONE_EMERALD_ORE"	,["SANDSTONE EMERALD ORE"]		,0.0009		, 0	,1	,0	,5	,0	,43	,59	,0],
	"44": 	["res://Textures/Blocks/sandstone_void_ore.png"		, "SANDSTONE_VOID_ORE"		,["SANDSTONE VOID ORE"]			,0.0008		, 0	,1	,0	,6	,0	,44	,87	,0],
	"45": 	["res://Textures/Blocks/birch_log.png"				, "BIRCH_LOG"				,["log","birch"]				,0.05		, 0	,3	,0	,0	,0	,45	,45	,1],
	"46": 	["res://Textures/Blocks/poplar_log.png"				, "POPLAR_LOG"				,["log","poplar"]				,0.05		, 0	,3	,0	,0	,0	,46	,46	,1],
	"47": 	["res://Textures/Blocks/oak_planks.png"				, "OAK_PLANKS"				,["planks","oak"]				,0.05		, 0	,3	,0	,0	,0	,47	,47	,0],
	"48": 	["res://Textures/Blocks/pine_planks.png"			, "PINE_PLANKS"				,["planks","pine"]				,0.05		, 0	,3	,0	,0	,0	,48	,48	,0],
	"49": 	["res://Textures/Blocks/birch_planks.png"			, "BIRCH_PLANKS"			,["planks","birch"]				,0.05		, 0	,3	,0	,0	,0	,49	,49	,0],
	"50": 	["res://Textures/Blocks/poplar_planks.png"			, "POPLAR_PLANKS"			,["planks","poplar"]			,0.05		, 0	,3	,0	,0	,0	,50	,50	,0],
	"51": 	["res://Textures/Items/stick.png"					,"STICK"					,["STICK"]						,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"52": 	["res://Textures/Blocks/stonebricks.png"			,"STONE_BRICKS"				,["stone","bricks"]				,0.027		, 0	,1	,0	,1	,0	,52	,52	,0],
	"53": 	["res://Textures/Blocks/sandstone_bricks.png"		,"SANDSTONE_BRICKS"			,["stone","bricks"]				,0.027		, 0	,1	,0	,1	,0	,53	,53	,0],
	"54": 	["res://Textures/Items/wood_particles.png"			,"WOOD_PARTICLES"			,["wood","particles"]			,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"55": 	["res://Textures/Items/coal.png"					,"COAL"						,["coal"]						,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"56": 	["res://Textures/Items/iron_particules.png"			,"IRON_PARTICLES"			,["iron","particles"]			,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"57": 	["res://Textures/Items/ruby.png"					,"RUBY"						,["ruby"]						,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"58": 	["res://Textures/Items/sapphire.png"				,"SAPPHIRE"					,["sapphire"]					,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"59": 	["res://Textures/Items/emerald.png"					,"EMERALD"					,["emerald"]					,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"60": 	["res://Textures/Items/void_ingot.png"				,"VOID_INGOT"				,["void"]						,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"61": 	["res://Textures/Blocks/coal_block.png"				,"COAL_BLOCK"				,["coal","block"]				,0.01		, 0	,1	,0	,1	,0	,61	,61	,0],
	"62": 	["res://Textures/Blocks/iron_block.png"				,"IRON_BLOCK"				,["iron","block"]				,0.008		, 0	,1	,0	,2	,0	,62	,62	,0],
	"63": 	["res://Textures/Blocks/ruby_block.png"				,"RUBY_BLOCK"				,["ruby","block"]				,0.0075		, 0	,1	,0	,3	,0	,63	,63	,0],
	"64": 	["res://Textures/Blocks/sapphire_block.png"			,"SAPPHIRE_BLOCK"			,["sapphire","block"]			,0.005		, 0	,1	,0	,4	,0	,64	,64	,0],
	"65": 	["res://Textures/Blocks/emerald_block.png"			,"EMERALD_BLOCK"			,["emerald","block"]			,0.001		, 0	,1	,0	,5	,0	,65	,65	,0],
	"66": 	["res://Textures/Blocks/conveyor_belt.png"			,"CONVEYOR_BELT"			,["CONVEYOR BELT"]				,0.027		, 0	,1	,0	,0	,0	,66	,66	,0],
	"67": 	["res://Textures/Items/rope.png"					,"ROPE"						,["ROPE"]						,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"68": 	["res://Textures/Items/parachute.png"				,"PARACHUTE"				,["PARACHUTE"]					,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"69": 	["res://Textures/Items/strings.png"					,"STRINGS"					,["STRINGS"]					,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"70": 	["res://Textures/Items/jetpack.png"					,"JETPACK"					,["JETPACK"]					,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"71": 	["res://Textures/Blocks/wool.png"					,"WOOL"						,["WOOL"]						,0.05		, 0	,1	,0	,0	,0	,71	,71	,0],
	"72": 	["res://Textures/Items/hammer.png"					,"HAMMER"					,["HAMMER"]						,0			, 1	,0	,1	,0	,6	,-1	,-1	,0],
	"73": 	["res://Textures/Items/clock.png"					,"CLOCK"					,["CLOCK"]						,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"74": 	["res://Textures/Items/food.png"					,"FOOD"						,["FOOD"]						,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"75": 	["res://Textures/Items/zombie_bone.png"				,"ZOMBIE_BONE"				,[]								,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"76": 	["res://Textures/Items/honey.png"					,"HONEY"					,[]								,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"77": 	["res://Textures/Items/backpack.png"				,"BACKPACK"					,["BACKPACK"]					,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"78": 	["res://Textures/Items/bucket.png"					,"EMPTY_BUCKET"				,["bucket","empty"]				,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"79": 	["res://Textures/Items/water_bucket.png"			,"WATER_BUCKET"				,["bucket","water"]				,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"80": 	["res://Textures/Blocks/clay_block.png"				,"CLAY_BLOCK"				,["clay","block"]				,0.2		, 0	,2	,0	,0	,0	,80	,80	,0],
	"81": 	["res://Textures/Blocks/furnace.png"				,"FURNACE"					,[]								,0.05		, 0	,1	,0	,2	,0	,81	,81	,0],
	"82": 	["res://Textures/Items/iron_ingot.png"				,"IRON_INGOT"				,["iron","ingot"]				,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"83": 	["res://Textures/Blocks/anvil.png"					,"ANVIL"					,[]								,0.01		, 0	,1	,0	,3	,0	,83	,83	,0],
	"84": 	["res://Textures/Blocks/cauldron.png"				,"CAULDRON"					,[]								,0.01		, 0	,1	,0	,3	,0	,84	,84	,0],
	"85": 	["res://Textures/Blocks/chisel_block.png"			,"CHISEL_BLOCK"				,[]								,0.05		, 0	,3	,0	,2	,0	,85	,85	,0],
	"86": 	["res://Textures/Blocks/clay_bricks.png"			,"CLAY_BRICKS"				,["clay","bricks"]				,0.05		, 0	,2	,0	,1	,0	,86	,86	,0],
	"87": 	["res://Textures/Items/void_particules.png"			,"VOID_PARTICLES"			,["void","particles"]			,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"88": 	["res://Textures/Items/empty_potion.png"			,"EMPTY_POTION"				,["potion","empty"]				,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"89": 	["res://Textures/Items/piece_of_glass.png"			,"PIECE_OF_GLASS"			,["glass"]						,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"90": 	["res://Textures/Items/health_potion.png"			,"HEALTH_POTION"			,["potion","health"]			,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"91": 	["res://Textures/Items/force_potion.png"			,"STRENGHT_POTION"			,["potion","strenght"]			,0			, 1	,0	,0	,0	,0	,-1	,-1	,0],
	"92": 	["res://Textures/Items/wooden_sword.png"			,"WOODEN_SWORD"				,["sword","wood"]				,0			, 1	,0	,4	,0	,1	,-1	,-1	,0],
	"93": 	["res://Textures/Items/stone_sword.png"				,"STONE_SWORD"				,["sword","stone"]				,0			, 1	,0	,4	,0	,2	,-1	,-1	,0],
	"94": 	["res://Textures/Items/iron_sword.png"				,"IRON_SWORD"				,["sword","iron"]				,0			, 1	,0	,4	,0	,3	,-1	,-1	,0],
	"95": 	["res://Textures/Items/ruby_sword.png"				,"RUBY_SWORD"				,["sword","ruby"]				,0			, 1	,0	,4	,0	,4	,-1	,-1	,0],
	"96": 	["res://Textures/Items/saph_sword.png"				,"SAPPHIRE_SWORD"			,["sword","sapphire"]			,0			, 1	,0	,4	,0	,5	,-1	,-1	,0],
	"97": 	["res://Textures/Items/emerald_sword.png"			,"EMERALD_SWORD"			,["sword","emerald"]			,0			, 1	,0	,4	,0	,6	,-1	,-1	,0],
	"98": 	["res://Textures/Blocks/stone_tiles.png"			,"STONE_TILES"				,["stone","tiles"]				,0.027		, 0	,1	,0	,1	,1	,98	,98	,0],
	"99": 	["res://Textures/Blocks/smooth_stone.png"			,"SMOOTH_STONE"				,["stone","smooth"]				,0.027		, 0	,1	,0	,1	,1	,99	,99	,0],
	"100": 	["res://Textures/Blocks/sandstone_tiles.png"		,"SANDSTONE_TILES"			,["SANDSTONE TILES"]			,0.027		, 0	,1	,0	,1	,1	,100,100,0],
	"101": 	["res://Textures/Blocks/smooth_sandstone.png"		,"SMOOTH_SANDSTONE"			,["SMOOTH SANDSTONE"]			,0.027		, 0	,1	,0	,1	,1	,101,101,0],
	"102": 	["res://Textures/Blocks/shaded_grass.png"			,"SHADED_GRASS"				,["dirt"]						,0.05		, 0	,2	,0	,0	,0	,102,102,0],
	"103": 	["res://Textures/Blocks/shaded_dirt.png"			,"SHADED_DIRT"				,["dirt"]						,0.1		, 0	,2	,0	,0	,1	,103,103,0],
	"104": 	["res://Textures/Blocks/shaded_stone.png"			,"SHADED_STONE"				,["stone"]						,0.0135		, 0	,1	,0	,1	,0	,104,104,0],
	"105": 	["res://Textures/Blocks/shaded_portal.png"			,"SHADED_PORTAL"			,["portal"]						,0.01		, 0	,1	,0	,4	,0	,105,105,0],
	"106": 	["res://Textures/Blocks/shaded_log.png"				,"SHADED_LOG"				,["log","shaded"]				,0.5		, 0	,3	,0	,3	,0	,106,106,1],
	"107": 	["res://Textures/Blocks/shaded_boss_piedestal.png"	,"SHADED_BOSS_PIEDESTAL"	,[]								,0.01		, 0	,1	,0	,6	,0	,107,107,0],
	"108": 	["res://Textures/Blocks/grass.png"					,"GRASS"					,["GRASS"]						,1			, 0	,0	,0	,0	,0	,108,108,1],
	"109": 	["res://Textures/Blocks/beehive.png"				,"BEEHIVE"					,["BEEHIVE"]					,0.1		, 0	,0	,0	,0	,0	,109,109,1],
	"110": 	["res://Textures/Blocks/glass_block.png"			,"GLASS_BLOCK"				,["glass","block"]				,0.1		, 0	,0	,0	,0	,0	,110,89	,1],
	"111": 	["res://Textures/Blocks/structure_air.png"			,"STRUCTURE_AIR"			,["STRUCTURE AIR"]				,0			, -1,0	,0	,0	,0	,111,-1	,1],
	"112": 	["res://Textures/Blocks/shaded_stone_bricks.png"	,"SHADED_STONE_BRICKS"		,["stone","bricks"]				,0.025		, 0	,1	,0	,3	,0	,112,112,0],
	"113": 	["res://Textures/Blocks/shaded_stone_tiles.png"		,"SHADED_STONE_TILES"		,["stone","tiles"]				,0.025		, 0	,1	,0	,3	,0	,113,113,0],
	"114": 	["res://Textures/Blocks/smooth_shaded_stone.png"	,"SMOOTH_SHADED_STONE"		,["stone","smooth"]				,0.025		, 0	,1	,0	,3	,0	,114,114,0],
	"115": 	["res://Textures/Items/oak_door_item.png"			,"OAK_DOOR_OPEN_1"			,[]								,0.05		, -1,0	,0	,0	,0	,115,115,0],
	"116": 	["res://Textures/Items/oak_door_item.png"			,"OAK_DOOR"					,[]								,0.05		, 0	,0	,0	,0	,0	,116,116,0],
	"117": 	["res://Textures/Items/oak_door_item.png"			,"OAK_DOOR_CLOSE_1"			,[]								,0.05		, -1,0	,0	,0	,0	,117,117,0],
	"118": 	["res://Textures/Items/oak_door_item.png"			,"OAK_DOOR_CLOSE_2"			,[]								,0.05		, -1,0	,0	,0	,0	,118,118,0],
	"119": 	["res://Textures/Items/pine_door_item.png"			,"PINE_DOOR_OPEN_1"			,[]								,0.05		, -1,0	,0	,0	,0	,119,119,0],
	"120": 	["res://Textures/Items/pine_door_item.png"			,"PINE_DOOR"					,[]								,0.05		, 0	,0	,0	,0	,0	,120,120,0],
	"121": 	["res://Textures/Items/pine_door_item.png"			,"PINE_DOOR_CLOSE_1"		,[]								,0.05		, -1,0	,0	,0	,0	,121,121,0],
	"122": 	["res://Textures/Items/pine_door_item.png"			,"PINE_DOOR_CLOSE_2"		,[]								,0.05		, -1,0	,0	,0	,0	,122,122,0],
	"123": 	["res://Textures/Items/birch_door_item.png"			,"BIRCH_DOOR_OPEN_1"		,[]								,0.05		, -1,0	,0	,0	,0	,123,123,0],
	"124": 	["res://Textures/Items/birch_door_item.png"			,"BIRCH_DOOR"				,[]								,0.05		, 0	,0	,0	,0	,0	,124,124,0],
	"125": 	["res://Textures/Items/birch_door_item.png"			,"BIRCH_DOOR_CLOSE_1"		,[]								,0.05		, -1,0	,0	,0	,0	,125,125,0],
	"126": 	["res://Textures/Items/birch_door_item.png"			,"BIRCH_DOOR_CLOSE_2"		,[]								,0.05		, -1,0	,0	,0	,0	,126,126,0],
	"127": 	["res://Textures/Items/poplar_door_item.png"		,"POPLAR_DOOR_OPEN_1"		,[]								,0.05		, -1,0	,0	,0	,0	,127,127,0],
	"128": 	["res://Textures/Items/poplar_door_item.png"		,"POPLAR_DOOR"				,[]								,0.05		, 0	,0	,0	,0	,0	,128,128,0],
	"129": 	["res://Textures/Items/poplar_door_item.png"		,"POPLAR_DOOR_CLOSE_1"		,[]								,0.05		, -1,0	,0	,0	,0	,129,129,0],
	"130": 	["res://Textures/Items/poplar_door_item.png"		,"POPLAR_DOOR_CLOSE_2"		,[]								,0.05		, -1,0	,0	,0	,0	,130,130,0],
	"131": 	["res://Textures/Items/shaded_door_item.png"		,"SHADED_DOOR_OPEN_1"		,[]								,0.05		, -1,0	,0	,0	,0	,131,131,0],
	"132": 	["res://Textures/Items/shaded_door_item.png"		,"SHADED_DOOR"				,[]								,0.05		, 0	,0	,0	,0	,0	,132,132,0],
	"133": 	["res://Textures/Items/shaded_door_item.png"		,"SHADED_DOOR_CLOSE_1"		,[]								,0.05		, -1,0	,0	,0	,0	,133,133,0],
	"134": 	["res://Textures/Items/shaded_door_item.png"		,"SHADED_DOOR_CLOSE_2"		,[]								,0.05		, -1,0	,0	,0	,0	,134,134,0],
	"135": 	["res://Textures/Blocks/torch.png"					,"TORCH"					,["torch"]						,0.2		, 0	,3	,0	,0	,0	,135,135,0],
	"136": 	["res://Textures/Blocks/chest.png"					,"CHEST"					,["chest"]						,0.05		, 0	,1	,0	,6	,0	,136,136,0],
	"137": 	["res://Textures/Blocks/mob_spawner.png"			,"EMPTY_MOB_SPAWNER"		,["spawner","empty"]			,0.001		, 0	,1	,0	,6	,0	,137,137,0],
	"138": 	["res://Textures/Blocks/mob_spawner_sheep.png"		,"SHEEP_MOB_SPAWNER"		,["spawner","sheep"]			,0.001		, 0	,1	,0	,6	,0	,138,138,0],
	"139": 	["res://Textures/Blocks/mob_spawner_zombie.png"		,"ZOMBIE_MOB_SPAWNER"		,["spawner","zombie"]			,0.001		, 0	,1	,0	,6	,0	,139,139,0],
	"140": 	["res://Textures/Blocks/mob_spawner_bee.png"		,"BEE_MOB_SPAWNER"			,["spawner","bee"]				,0.001		, 0	,1	,0	,6	,0	,140,140,0],
	"141": 	["res://Textures/Blocks/luminous_shaded_stone.png"	,"LUMINOUS_SHADED_STONE"	,["stone","shaded","torch"]		,0.01		, 0	,0	,0	,3	,0	,141,141,0],
	"142": 	["res://Textures/Items/speed_breaking_potion.png"	,"SPEED_BREAKING_POTION"	,["potion","breaking","speed"]	,0			, 1	,0	,0	,0	,0	,-1,-1,0],
	"143": 	["res://Textures/Items/attraction_potion.png"		,"NON_ATTRACTION_POTION"	,["potion","attraction"]		,0			, 1	,0	,0	,0	,0	,-1,-1,0],
	"144": 	["res://Textures/Items/jump_potion.png"				,"JUMP_POTION"				,["potion","jump"]				,0			, 1	,0	,0	,0	,0	,-1,-1,0],
	"145": 	["res://Textures/Items/speed_potion.png"			,"SPEED_POTION"				,["potion","speed"]				,0			, 1	,0	,0	,0	,0	,-1,-1,0],
	"146": 	["res://Textures/Items/night_vision_potion.png"		,"NIGHT_VISION_POTION"		,["potion","night","vision"]	,0			, 1	,0	,0	,0	,0	,-1,-1,0],
	"147": 	["res://Textures/Items/fortune_potion.png"			,"FORTUNE_POTION"			,["potion","fortune"]			,0			, 1	,0	,0	,0	,0	,-1,-1,0],
	"148": 	["res://Textures/Items/range_potion.png"			,"RANGE_POTION"				,["potion","range"]				,0			, 1	,1	,0	,1	,0	,-1,-1,0],
	"149": 	["res://Textures/Blocks/stone_mixed_sandstone.png"	,"STONE_MIXED_SANDSTONE"	,["stone","mixed","sandstone"]	,0.027		, 0	,0	,0	,0	,0	,149,149,0],
	"150": 	["res://Textures/Items/crown.png"					,"CROWN"					,["crown"]						,0			, 0	,0	,0	,0	,0	,-1,-1,0],
	"151": 	["res://Textures/Blocks/red_tulip.png"				,"RED_TULIP"				,["red","tulip"]				,0.1		, 0	,0	,0	,0	,0	,151,151,0],
	"152": 	["res://Textures/Blocks/rose.png"					,"ROSE"						,["rose"]						,0.1		, 0	,0	,0	,0	,0	,152,152,0],
	"153": 	["res://Textures/Blocks/white_tulip.png"			,"WHITE_TULIP"				,["white","tulip"]				,0.1		, 0	,0	,0	,0	,0	,153,153,0],
	"154": 	["res://Textures/Blocks/yellow_tulip.png"			,"YELLOW_TULIP"				,["yellow","tulip"]				,0.1		, 0	,0	,0	,0	,0	,154,154,0],
	"155": 	["res://Textures/Blocks/shaded_tulip.png"			,"SHADED_TULIP"				,["shaded","tulip"]				,0.1		, 0	,0	,0	,0	,0	,155,155,0],
	"156": 	["res://Textures/Blocks/pink_tulip.png"				,"PINK_TULIP"				,["pink","tulip"]				,0.1		, 0	,0	,0	,0	,0	,156,156,0],
	"157": 	["res://Textures/Blocks/magma_up.png"				,"MAGMA_UP"					,[]								,0			, -1,0	,0	,0	,0	,157,157,0],
	"158": 	["res://Textures/Blocks/magma_down.png"				,"MAGMA_DOWN"				,[]								,0			, -1,0	,0	,0	,0	,158,158,0],
	"159": 	["res://Textures/Blocks/lava_up.png"				,"LAVA_UP"					,[]								,0			, -1,0	,0	,0	,0	,159,159,0],
	"160": 	["res://Textures/Blocks/lava_down.png"				,"LAVA_DOWN"				,[]								,0			, -1,0	,0	,0	,0	,160,160,0],
	"161": 	["res://Textures/Items/magma_bucket.png"			,"MAGMA_BUCKET"				,["magma","bucket"]				,0			, 1	,0	,0	,0	,0	,-1,-1,0],
	"162": 	["res://Textures/Items/lava_bucket.png"				,"LAVA_BUCKET"				,["lava","bucket"]				,0			, 1	,1	,0	,0	,0	,-1,-1,0],
	"163": 	["res://Textures/Blocks/obsidian.png"				,"OBSIDIAN"					,["obsidian"]					,0.001		, 0	,1	,0	,5	,0	,163,163,0],
	"164": 	["res://Textures/Blocks/volcanic_rock.png"			,"VOLCANIC ROCK"			,["volcanic","rock"]			,0.03		, 0	,0	,0	,1	,0	,164,164,0],
	"165": 	["res://Textures/Blocks/Blé/wheat_1.png" 			,"WHEAT_STATE_1"			,[]								,0.5		, -1,0	,0	,0	,0	,165,165,0],
	"166": 	["res://Textures/Blocks/Blé/wheat_2.png" 			,"WHEAT_STATE_2"			,[]								,0.5		, -1,0	,0	,0	,0	,166,166,0],
	"167": 	["res://Textures/Blocks/Blé/wheat_3.png" 			,"WHEAT_STATE_3"			,[]								,0.5		, -1,0	,0	,0	,0	,167,167,0],
	"168": 	["res://Textures/Blocks/Blé/wheat_4.png" 			,"WHEAT_STATE_4"			,[]								,0.5		, -1,0	,0	,0	,0	,168,168,0],
	"169": 	["res://Textures/Blocks/Blé/wheat_5.png" 			,"WHEAT_STATE_5"			,[]								,0.5		, -1,0	,0	,0	,0	,169,169,0],
	"170": 	["res://Textures/Blocks/Blé/wheat_6.png" 			,"WHEAT_STATE_6"			,[]								,0.5		, -1,0	,0	,0	,0	,170,170,0],
	"171": 	["res://Textures/Blocks/plowland.png"				,"PLOWLAND"					,[]								,0.2		, 0	,0	,0	,0	,0	,171,171,0],
	"172": 	["res://Textures/Items/wheat.png"					,"WHEAT"					,["wheat"]						,0			, 1	,0	,0	,0	,0	,-1,-1,0],
	"173": 	["res://Textures/Blocks/shaded_sbire_block.png"		,"SHADED_SBIRE_BLOCK"		,["shaded","sbire","block"]		,0.1		, 0	,0	,0	,0	,0	,173,173,0],
	"174": 	["res://Textures/Blocks/oak_sign.png"				,"OAK_SIGN"					,["oak","sign"]					,0.05		, 0	,3	,0	,0	,0	,174,147,0]
}

var cat_blocks = []
var cat_items = []
var cat_all = []

var tag_texture = {"planks":"res://Textures/Blocks/oak_planks.png"}
var tools_name = ["HAND","PICKAXE","SHOVEL","AXE","SWORD"]

#Level de l'outil necessaire au break
#0 - Main minimum
#1 - Bois min
#2 - stone min
#3 - Fer min
#4 - Rubis min
#5 - Saph min
#6 - Emeraude min
var tools_level = ["NONE","WOOD","STONE","IRON","RUBY","SAPPHIRE","EMERALD"]

var lights_pos = []

var inv_slot = [
	-1,-1,-1,-1,-1,-1,-1,-1
]

var inv_slot_cooldown = [-1,-1,-1,-1,-1,-1,-1,-1]
var inv_slot_cooldown_max = [-1,-1,-1,-1,-1,-1,-1,-1]

var armor_slot = [
	-1
]

var inv_slot_count = [
	0,0,0,0,0,0,0,0
]
var armor_slot_count = [
	0
]

var block_in = [0,0] ## bloc en cours d'utilisation
var block_in_current = [] #tag du bloc en cours d'utilisation

var backpack_numbers = 0
var backpack_slots = []
var backpack_slots_count = []
var backpack_slots_tag = []

## TAG "backpack0" : détecte l'id du backpack |
var inv_slot_tag = [
	-1,-1,-1,-1,-1,-1,-1,-1
]
var armor_slot_tag = [
	-1
]

#[result,number,requirement1,hisnumber1,requirement2,hisnumber2,requirement3,hisnumber3,requirement4,hisnumber4,...]
var softrecipes = [
	[20,1,"planks",2,51,4,0,0,0,0],
	[47,4,16,1,0,0,0,0,0,0],
	[48,4,18,1,0,0,0,0,0,0],
	[49,4,45,1,0,0,0,0,0,0],
	[50,4,46,1,0,0,0,0,0,0],
	[51,4,"planks",1,0,0,0,0,0,0],
	[52,1,2,4,0,0,0,0,0,0],
	[53,1,13,4,0,0,0,0,0,0],
	[67,1,69,4,0,0,0,0,0,0],
	[71,1,69,4,0,0,0,0,0,0],
	[125,5,51,1,55,1,0,0,0,0]
]
var recipes = [
	[20,1,"planks",2,51,4,0,0,0,0],
	[21,1,51,3,"planks",6,0,0,0,0],
	[22,1,51,3,2,6,0,0,0,0],
	[23,1,51,3,82,6,0,0,0,0],
	[24,1,51,3,57,6,0,0,0,0],
	[25,1,51,3,58,6,0,0,0,0],
	[26,1,51,3,59,6,0,0,0,0],
	[27,1,51,3,"planks",2,0,0,0,0],
	[28,1,51,3,2,2,0,0,0,0],
	[29,1,51,3,82,2,0,0,0,0],
	[30,1,51,3,57,2,0,0,0,0],
	[31,1,51,3,58,2,0,0,0,0],
	[32,1,51,3,59,2,0,0,0,0],
	[33,1,51,3,"planks",3,0,0,0,0],
	[34,1,51,3,2,3,0,0,0,0],
	[35,1,51,3,82,3,0,0,0,0],
	[36,1,51,3,57,3,0,0,0,0],
	[37,1,51,3,58,3,0,0,0,0],
	[38,1,51,3,59,3,0,0,0,0],
	[47,4,16,1,0,0,0,0,0,0],
	[48,4,18,1,0,0,0,0,0,0],
	[49,4,45,1,0,0,0,0,0,0],
	[50,4,46,1,0,0,0,0,0,0],
	[51,4,"planks",1,0,0,0,0,0,0],
	[52,1,2,4,0,0,0,0,0,0],
	[53,1,13,4,0,0,0,0,0,0],
	[61,1,55,9,0,0,0,0,0,0],
	[62,1,56,9,0,0,0,0,0,0],
	[63,1,57,9,0,0,0,0,0,0],
	[64,1,58,9,0,0,0,0,0,0],
	[65,1,59,9,0,0,0,0,0,0],
	[66,1,3,5,56,3,55,1,0,0],
	[67,1,69,4,0,0,0,0,0,0],
	[71,1,69,9,0,0,0,0,0,0],
	[68,1,67,4,71,6,0,0,0,0],
	[70,1,82,6,2,10,60,2,0,0],
	[72,1,56,2,57,2,58,3,59,6],
	[73,1,58,4,56,2,51,2,0,0],
	[77,1,71,8,69,16,82,1,0,0],
	[78,1,82,5,0,0,0,0,0,0],
	[81,1,2,8,0,0,0,0,0,0],
	[83,1,62,4,82,3,0,0,0,0],
	[84,1,82,8,0,0,0,0,0,0],
	[85,1,"planks",2,82,4,0,0,0,0],
	[88,1,89,8,0,0,0,0,0,0],
	[92,1,51,3,54,4,0,0,0,0],
	[93,1,51,3,2,4,0,0,0,0],
	[94,1,51,3,82,4,0,0,0,0],
	[95,1,51,3,57,4,0,0,0,0],
	[96,1,51,3,58,4,0,0,0,0],
	[97,1,51,3,59,4,0,0,0,0],
	[105,1,60,15,0,0,0,0,0,0],
	[110,1,89,4,0,0,0,0,0,0],
	[115,1,47,6,0,0,0,0,0,0],
	[117,1,48,6,0,0,0,0,0,0],
	[119,1,49,6,0,0,0,0,0,0],
	[121,1,50,6,0,0,0,0,0,0],
	[123,1,106,6,0,0,0,0,0,0],
	[125,5,51,1,55,1,0,0,0,0],
	[126,1,"planks",10,0,0,0,0,0,0]
]

## RESULTAT, NOMBRE, NOMBRE DE CHARBON, INGREDIENT, NOMBRE INGREDIENT
var furnace_recipes = [
	[82,1,2,56,4],
	[60,1,3,87,4],
	[89,4,1,12,1]
]

var anvil_recipes = [
	[23,1,22,1,82,3,0,0,0,0],
	[24,1,23,1,57,3,0,0,0,0],
	[25,1,24,1,58,3,0,0,0,0],
	[26,1,25,1,59,3,0,0,0,0],
	[29,1,28,1,82,1,0,0,0,0],
	[30,1,29,1,57,1,0,0,0,0],
	[31,1,30,1,58,1,0,0,0,0],
	[32,1,31,1,59,1,0,0,0,0],
	[35,1,34,1,82,2,0,0,0,0],
	[36,1,35,1,57,2,0,0,0,0],
	[37,1,36,1,58,2,0,0,0,0],
	[38,1,37,1,59,2,0,0,0,0],
	[94,1,93,1,82,2,0,0,0,0],
	[95,1,94,1,57,2,0,0,0,0],
	[96,1,95,1,58,2,0,0,0,0],
	[97,1,96,1,59,2,0,0,0,0]
]

## slot demandé - item 1 - item 2 - item 3
var chisel_recipes = [
	[2,52,98,99],
	[13,53,100,101],
	[16,47],
	[18,47],
	[45,49],
	[46,50],
	[80,86],
	[104,112,113,114]
]

var cauldron_recipes = [
	[90,1,88,1,74,5,142,5,0,0],
	[91,1,88,1,76,5,141,5,0,0],
	[132,1,88,1,59,5,144,5,0,0],
	[133,1,88,1,75,5,144,3,145,2],
	[134,1,88,1,76,5,144,3,145,4],
	[135,1,88,1,79,1,145,2,0,0],
	[136,1,88,1,79,2,145,4,0,0],
	[137,1,88,1,142,5,145,5,0,0],
	[138,1,88,1,142,4,145,5,0,0]
]

var chisel_slot = -1
var chisel_slot_count = 0
var chisel_slot_tag = -1

##World Stats
var stats_name = ["STAT_WALK","STAT_JUMP","STAT_SPRINT","STAT_DAMAGE_INFLICTED","STAT_DAMAGE_RECEIVED",
	"STAT_ITEMS","STAT_MOBS_KILLED","STAT_DEATHS","STAT_BLOCKS_BROKEN","STAT_BLOCKS_PLACED","STAT_FOOD_EATEN","STAT_FLIGHT","STAT_GAMEDAYPLAYED","STAT_REALHOURSPLAYED"]
var stats_value = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]

## [x,y] : ["nbt tag",contains]
var blocks_nbt = {}

var chunk_biome = {}
var chunk_biome_shadow = {}
var chunk_name = ["PLAINS","DESERT","COLD PLAINS","BIRCH FOREST","RIPARIAN FOREST","OCEAN"]
var chunk_shadow_name = ["SHADED FOREST"]
var chunk_discovered = {
	"PLAINS":0,
	"DESERT":0,
	"COLD PLAINS":0,
	"BIRCH FOREST":0,
	"RIPARIAN FOREST":0,
	"SHADED FOREST":0,
	"OCEAN":0,
	"TOTAL":0
}

## Global Achievements
var achievements_title = ["ACHIEVEMENT_TITLE_LAUNCHED","ACHIEVEMENT_TITLE_DESTROYER","ACHIEVEMENT_TITLE_MOBS","ACHIEVEMENT_TITLE_FINANCIALLY1","ACHIEVEMENT_TITLE_FINANCIALLY2","ACHIEVEMENT_TITLE_FINANCIALLY3","ACHIEVEMENT_TITLE_FINANCIALLY4","ACHIEVEMENT_TITLE_FINANCIALLY5","ACHIEVEMENT_TITLE_THOR","ACHIEVEMENT_TITLE_OVERPOWERED_PICK","ACHIEVEMENT_TITLE_OVERPOWERED_SHOVEL","ACHIEVEMENT_TITLE_OVERPOWERED_AXE","ACHIEVEMENT_TITLE_TRANSPORT","ACHIEVEMENT_TITLE_JETPACK","ACHIEVEMENT_TITLE_PARACHUTE","ACHIEVEMENT_TITLE_CHANGE_DIMENSION","ACHIEVEMENT_TITLE_BOSS","ACHIEVEMENT_TITLE_ALLBIOMES","ACHIEVEMENT_TITLE_POSETORCH","ACHIEVEMENT_TITLE_10DAYS","ACHIEVEMENT_TITLE_ALLPOTIONS","ACHIEVEMENT_TITLE_CHISELED100","ACHIEVEMENT_TITLE_OPENCHEST","ACHIEVEMENT_TITLE_ALL"]
var achievements_description = ["ACHIEVEMENT_DESC_LAUNCHED","ACHIEVEMENT_DESC_DESTROYER","ACHIEVEMENT_DESC_MOBS","ACHIEVEMENT_DESC_FINANCIALLY1","ACHIEVEMENT_DESC_FINANCIALLY2","ACHIEVEMENT_DESC_FINANCIALLY3","ACHIEVEMENT_DESC_FINANCIALLY4","ACHIEVEMENT_DESC_FINANCIALLY5","ACHIEVEMENT_DESC_THOR","ACHIEVEMENT_DESC_OVERPOWERED_PICK","ACHIEVEMENT_DESC_OVERPOWERED_SHOVEL","ACHIEVEMENT_DESC_OVERPOWERED_AXE","ACHIEVEMENT_DESC_TRANSPORT","ACHIEVEMENT_DESC_JETPACK","ACHIEVEMENT_DESC_PARACHUTE","ACHIEVEMENT_DESC_CHANGE_DIMENSION","ACHIEVEMENT_DESC_BOSS","ACHIEVEMENT_DESC_ALLBIOMES","ACHIEVEMENT_DESC_POSETORCH","ACHIEVEMENT_DESC_10DAYS","ACHIEVEMENT_DESC_ALLPOTIONS","ACHIEVEMENT_DESC_CHISELED100","ACHIEVEMENT_DESC_OPENCHEST","ACHIEVEMENT_DESC_ALL"]
var achievements_sprite = ["res://Textures/Blocks/grass.png","res://Textures/Blocks/stone.png","res://Textures/Items/food.png","res://Textures/Blocks/coal_block.png","res://Textures/Blocks/iron_block.png","res://Textures/Blocks/ruby_block.png","res://Textures/Blocks/sapphire_block.png","res://Textures/Blocks/emerald_block.png","res://Textures/Items/hammer.png","res://Textures/Items/emerald_pick.png","res://Textures/Items/eme_shovel.png","res://Textures/Items/eme_axe.png","res://Textures/Blocks/conveyor_belt.png","res://Textures/Items/jetpack.png","res://Textures/Items/parachute.png","res://Textures/Blocks/shaded_portal.png","res://Textures/Blocks/shaded_boss_piedestal.png","res://Textures/Items/backpack.png","res://Textures/Blocks/torch.png","res://Textures/Items/clock.png","res://Textures/Items/health_potion.png","res://Textures/Blocks/chisel_block.png","res://Textures/Blocks/chest.png","res://Textures/Items/void_ingot.png"]
var achievements_completed = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var achivements_value = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var achivements_max_value = [0,25000,100,25,25,25,25,25,0,0,0,0,1000,0,0,0,0,1,0,10,0,100,0,0]

var resolutions = [[1920,1080],[1600,900],[1366,768],[1280,720],[960,540],[854,480]]

var Teleportation = 0

var saving = 0

func initialisation():
	VarGlobales.block_in = [0,0]
	VarGlobales.block_in_current = []
	VarGlobales.backpack_numbers = 0
	VarGlobales.backpack_slots = []
	VarGlobales.backpack_slots_count = []
	VarGlobales.backpack_slots_tag = []
	VarGlobales.chisel_slot = -1
	VarGlobales.chisel_slot_count = 0
	VarGlobales.chisel_slot_tag = -1
	VarGlobales.stats_value = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	VarGlobales.health = 100
	VarGlobales.food = 100
	VarGlobales.saturation = 0
	VarGlobales.slot_selected = 1
	VarGlobales.blocks_nbt = {}
	VarGlobales.inv_slot = [-1,-1,-1,-1,-1,-1,-1,-1]
	VarGlobales.inv_slot_count = [0,0,0,0,0,0,0,0]
	VarGlobales.inv_slot_tag = [-1,-1,-1,-1,-1,-1,-1,-1]
	VarGlobales.armor_slot = [-1]
	VarGlobales.armor_slot_count = [0]
	VarGlobales.armor_slot_tag = [-1]
	VarGlobales.backpack_numbers = 0
	VarGlobales.backpack_slots = []
	VarGlobales.backpack_slots_tag = []
	VarGlobales.backpack_slots_count = []
	VarGlobales.spawnpoint = Vector2(16,-64)
	VarGlobales.potions_active = [0,0,0,0,0,0,0,0,0]
	VarGlobales.potions_timer = [0,0,0,0,0,0,0,0,0]
	VarGlobales.mobs_saving = {}
	VarGlobales.items_saving = {}
	VarGlobales.LoadedTimes = 1

func all_tags_in_txt(id):
	var text = ""
	if collection[str(id)][2] == []:
		return ""
	for i in len(collection[str(id)][2]):
		text += str(collection[str(id)][2][i])
		if i < len(collection[str(id)][2])-1:
			text += ", "
	return text
		
func check_tag(tag,id):
	if str(id) in collection.keys():
		for i in len(collection[str(id)][2]):
			if tag == collection[str(id)][2][i]:
				return true
	return false

func new_achievement(id):
	get_node("../World/CanvasLayer/Achievement_Info").new_achievement = 1
	get_node("../World/CanvasLayer/Achievement_Info/Icon").texture = load(VarGlobales.achievements_sprite[id])
	get_node("../World/CanvasLayer/Achievement_Info/Title").text = VarGlobales.achievements_title[id]
	get_node("../World/CanvasLayer/Achievement_Info/Description").text = VarGlobales.achievements_description[id]
	VarGlobales.achievements_completed[id] = 1

func _ready():
	for key in collection.keys():
		if collection[key][4] == 0: ## Bloc
			cat_blocks.append(int(key))
			cat_all.append(int(key))
		if collection[key][4] == 1: ## Item
			cat_items.append(int(key))
			cat_all.append(int(key))
	
	initialisation()
	get_tree().set_auto_accept_quit(false)
	achivements_max_value[17] = VarGlobales.chunk_name.size()+VarGlobales.chunk_shadow_name.size()
	achivements_max_value[20] = VarGlobales.potions_active.size()
	achivements_max_value[len(achivements_max_value)-1] = achievements_title.size()-1
	VarGlobales.load_options()
	MusicController.play_title_music()

func _process(_delta):
	rng.randomize()
	if VarGlobales.destroy_items == 1:
		VarGlobales.destroy_items = 0

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_options()
		get_tree().quit()

func save_options():
	var file = ConfigFile.new()
	file.set_value("Music","Effects",VarGlobales.effects_volume)
	file.set_value("Music","Music",VarGlobales.music_volume)
	file.set_value("Music","Blocks",VarGlobales.blocks_volume)
	file.set_value("Music","Player",VarGlobales.player_volume)
	file.set_value("Language","Language",TranslationServer.get_locale())
	file.set_value("Video","FOV",VarGlobales.fov)
	file.set_value("Video","Particules",VarGlobales.particules)
	file.set_value("Video","Shadows",VarGlobales.shadows)
	file.set_value("Video","Fullscreen",VarGlobales.fullscreen)
	file.set_value("Video","Resolution",VarGlobales.resolution)
	file.set_value("Apparences","Nickname",VarGlobales.nickname)
	file.set_value("Apparences","Nickname Color",VarGlobales.color_nickmane)
	file.set_value("Apparences","Hair Color",VarGlobales.color_hair)
	file.set_value("Apparences","TShirt Color",VarGlobales.color_tshirt)
	file.set_value("Apparences","Head Shape3D",VarGlobales.skin_head_shape)
	file.set_value("Apparences","Legs Color",VarGlobales.color_legs)
	file.set_value("Apparences","Hair Style",VarGlobales.skin_hair_style)
	
	file.save("user://Options.txt")
	for i in VarGlobales.achivements_value.size():
		file.set_value("Values",str(VarGlobales.achievements_title[i]).replace(" ",""),VarGlobales.achivements_value[i])
		file.set_value("Completed",str(VarGlobales.achievements_title[i]).replace(" ",""),VarGlobales.achievements_completed[i])
	file.save("user://Achievements.txt")
	
func load_options():
	var filesave = ConfigFile.new()
	var err = filesave.load("user://Options.txt")
	if err == OK:
		VarGlobales.effects_volume = filesave.get_value("Music","Effects",VarGlobales.effects_volume)
		VarGlobales.music_volume = filesave.get_value("Music","Music",VarGlobales.music_volume)
		VarGlobales.blocks_volume = filesave.get_value("Music","Blocks",VarGlobales.blocks_volume)
		VarGlobales.player_volume = filesave.get_value("Music","Player",VarGlobales.player_volume)
		
		MusicController.get_node("Music").volume_db = VarGlobales.music_volume
		MusicController.get_node("Effects").volume_db = VarGlobales.effects_volume
		MusicController.get_node("Player").volume_db = VarGlobales.player_volume
		MusicController.get_node("Blocks").volume_db = VarGlobales.blocks_volume
		
		
		TranslationServer.set_locale(filesave.get_value("Language","Language","en"))
		VarGlobales.fov = filesave.get_value("Video","FOV",VarGlobales.fov)
		VarGlobales.particules = filesave.get_value("Video","Particules",VarGlobales.particules)
		VarGlobales.shadows = filesave.get_value("Video","Shadows",VarGlobales.shadows)
		VarGlobales.fullscreen = filesave.get_value("Video","Fullscreen",VarGlobales.fullscreen)
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (VarGlobales.fullscreen) else Window.MODE_WINDOWED
		VarGlobales.resolution = filesave.get_value("Video","Resolution",VarGlobales.resolution)
		VarGlobales.nickname = filesave.get_value("Apparences","Nickname",VarGlobales.nickname)
		VarGlobales.color_nickmane = filesave.get_value("Apparences","Nickname Color",VarGlobales.color_nickmane)
		VarGlobales.color_hair = filesave.get_value("Apparences","Hair Color",VarGlobales.color_hair)
		VarGlobales.color_tshirt = filesave.get_value("Apparences","TShirt Color",VarGlobales.color_tshirt)
		VarGlobales.skin_head_shape = filesave.get_value("Apparences","Head Shape3D",VarGlobales.skin_head_shape)
		VarGlobales.color_legs = filesave.get_value("Apparences","Legs Color",VarGlobales.color_legs)
		VarGlobales.skin_hair_style = filesave.get_value("Apparences","Hair Style",VarGlobales.skin_hair_style)
		
		get_window().size = Vector2(VarGlobales.resolution[0],VarGlobales.resolution[1])
		#for i in len(InputMap.get_actions()):
			#change_key(filesave.get_value("Key Binds",InputMap.get_actions()[i]),i)
			
	err = filesave.load("user://Achievements.txt")
	if err == OK:
		for i in VarGlobales.achievements_title.size():
			if filesave.has_section_key("Values",str(VarGlobales.achievements_title[i]).replace(" ","")) == true:
				VarGlobales.achivements_value[i] = filesave.get_value("Values",str(VarGlobales.achievements_title[i]).replace(" ",""),VarGlobales.achivements_value[i])
				VarGlobales.achievements_completed[i] = filesave.get_value("Completed",str(VarGlobales.achievements_title[i]).replace(" ",""),VarGlobales.achievements_completed[i])
			else:
				VarGlobales.achivements_value[i] = 0
				VarGlobales.achievements_completed[i] = 0

func change_key(new_key,i):
	#Delete key of pressed button
	var action_string = InputMap.get_actions()[i]
	if !InputMap.action_get_events(action_string).is_empty():
		InputMap.action_erase_event(action_string, InputMap.action_get_events(action_string)[0])
			
	#Add new Key
	InputMap.action_add_event(action_string, new_key)

func id_to_coords(j):
	var tilesPerRow = 11  # Nombre de tuiles par ligne
	var x = j % tilesPerRow
	var y = j / tilesPerRow
	return Vector2(x, y)

func save_chunk(chunk):
	var filesave = ConfigFile.new()
	var i_int = chunk
	VarGlobales.LoadedRegions.erase("Chunk"+str(chunk))
	
	# Code pour save le chunk
	if VarGlobales.WorldFile == "":
		VarGlobales.WorldFile = "Unnamed World "+str(rng.randi_range(0,99999999))
		VarGlobales.WorldName = VarGlobales.WorldFile
	var dir = DirAccess.open("user://")
	dir.make_dir("Worlds")
	dir.make_dir("Worlds/"+str(VarGlobales.WorldFile))
	if WorldDimension == 1:
		dir.make_dir("Worlds/"+str(VarGlobales.WorldFile)+"/Earth/Chunk"+str(i_int))
	if WorldDimension == 2:
		dir.make_dir("Worlds/"+str(VarGlobales.WorldFile)+"/Shadow/Chunk"+str(i_int))
	
	for j in collection.size():
		var L = []
		var id = get_tree().get_root().get_node("World/TileMap").get_used_cells_by_id(0,0, id_to_coords(j) )
		if id != []:
			for c in id.size():
				if id[c][0] >= i_int*32 and id[c][0] < (i_int+1)*32:
					L.append([id[c][0],id[c][1]])
			filesave.set_value("Save",str(j),L)
			if WorldDimension == 1:
				filesave.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Earth/Chunk"+str(i_int)+"/Blocks.txt")
			if WorldDimension == 2:
				filesave.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Shadow/Chunk"+str(i_int)+"/Blocks.txt")

	print("Chunk saved "+str(chunk))
	Generation.ungen_world(chunk)

func save():
	if VarGlobales.WorldFile == "":
		VarGlobales.WorldFile = "Unnamed World "+str(rng.randi_range(0,99999999))
		VarGlobales.WorldName = VarGlobales.WorldFile
	var dir = DirAccess.open("user://")
	dir.make_dir("Worlds")
	dir.make_dir("Worlds/"+str(VarGlobales.WorldFile))
	
	saving = 1
	await get_tree().create_timer(0.1).timeout
	get_tree().get_root().get_node("World/CanvasLayer/SaveRect/ColorRect/ProgressBar").value = 0
	get_tree().get_root().get_node("World/CanvasLayer/SaveRect").visible = true
	get_tree().get_root().get_node("World/CanvasLayer/SaveRect/ColorRect/Label").text = "INFORMATIONS"
	await get_tree().create_timer(0.1).timeout
	rng.randomize()
	var file = ConfigFile.new()
	file.set_value("World","Name",VarGlobales.WorldName)
	file.set_value("World","Seed",VarGlobales.WorldSeed)
	file.set_value("World","Size",VarGlobales.WorldSize)
	file.set_value("World","Version",VarGlobales.VersionName)
	file.set_value("World","SaveVersion",VarGlobales.WorldSaveVersion)
	file.set_value("World","Mode",VarGlobales.WorldMode)
	file.set_value("World","Thumbnail",VarGlobales.WorldThumbnail)
	file.set_value("World","Achievement Locked",VarGlobales.WorldAchievementLocked)
	file.set_value("World","Water Level",VarGlobales.WorldWaterLevel)
	file.set_value("World","Surface Height",VarGlobales.WorldSurfaceHeight)
	file.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Infos.txt")

	get_tree().get_root().get_node("World/CanvasLayer/SaveRect/ColorRect/Label").text = "TIME"
	await get_tree().create_timer(0.1).timeout
	var file_time = ConfigFile.new()
	file_time.set_value("Time","Background",Vector3(get_tree().get_root().get_node("World").red_now,get_tree().get_root().get_node("World").green_now,get_tree().get_root().get_node("World").blue_now))
	file_time.set_value("Time","Ticks",VarGlobales.time_tick)
	file_time.set_value("Time","Minutes",VarGlobales.time_min)
	file_time.set_value("Time","Hours",VarGlobales.time_hour)
	file_time.set_value("Time","Days",VarGlobales.time_day)
	file_time.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Time.txt")


	get_tree().get_root().get_node("World/CanvasLayer/SaveRect/ColorRect/Label").text = "PLAYER"
	await get_tree().create_timer(0.1).timeout
	var file_player = ConfigFile.new()
	var file_playercords = ConfigFile.new()
	var file_player2 = ConfigFile.new()
	file_playercords.set_value("Player","x",get_node("/root/World/CharacterBody2D").get_position().x/32)
	file_playercords.set_value("Player","y",get_node("/root/World/CharacterBody2D").get_position().y/32)
	file_player.set_value("Inventory","inv_slot",VarGlobales.inv_slot)
	file_player.set_value("Inventory","inv_slot_count",VarGlobales.inv_slot_count)
	file_player.set_value("Inventory","inv_slot_tag",VarGlobales.inv_slot_tag)
	file_player.set_value("Inventory","armor_slot",VarGlobales.armor_slot)
	file_player.set_value("Inventory","armor_slot_count",VarGlobales.armor_slot_count)
	file_player.set_value("Inventory","armor_slot_tag",VarGlobales.armor_slot_tag)
	file_player.set_value("Effects","Active Potions",VarGlobales.potions_active)
	file_player.set_value("Effects","Potions durations",VarGlobales.potions_timer)
	file_player.set_value("Backpack","Numbers",VarGlobales.backpack_numbers)
	file_player.set_value("Backpack","Slots",VarGlobales.backpack_slots)
	file_player.set_value("Backpack","Count",VarGlobales.backpack_slots_count)
	file_player.set_value("Backpack","Tag",VarGlobales.backpack_slots_tag)
	file_player.set_value("Stats","Health",VarGlobales.health)
	file_player.set_value("Stats","Food",VarGlobales.food)
	file_player.set_value("Stats","Saturation",VarGlobales.saturation)
	file_player.set_value("Stats","Statistics",VarGlobales.stats_value)
	file_player.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Player.txt")

	if VarGlobales.WorldDimension == 1:
		dir.make_dir("user://Worlds/"+str(VarGlobales.WorldFile)+"/Earth")
		file_playercords.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Earth/Player.txt")
	if VarGlobales.WorldDimension == 2:
		dir.make_dir("user://Worlds/"+str(VarGlobales.WorldFile)+"/Shadow")
		file_playercords.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Shadow/Player.txt")

	get_tree().get_root().get_node("World/CanvasLayer/SaveRect/ColorRect/Label").text = "BLOCKS"
	await get_tree().create_timer(0.1).timeout
	## EXPERIMENTAL
	var max_chunks = 0
	var loaded_chunks = 0
	for val in VarGlobales.LoadedRegions.values():
		if val == VarGlobales.LoadedTimes:
			max_chunks += 1
	get_tree().get_root().get_node("World/CanvasLayer/SaveRect/ColorRect/ProgressBar").max_value = max_chunks
	for i in VarGlobales.LoadedRegions.keys():
		var i_int = str(i).replace("Chunk","")
		i_int = int(i_int)
		if VarGlobales.LoadedRegions[i] == VarGlobales.LoadedTimes:
			get_tree().get_root().get_node("World/CanvasLayer/SaveRect/ColorRect/Label").text = "BLOCKS : Chunk"+str(i_int)
			get_tree().get_root().get_node("World/CanvasLayer/SaveRect/ColorRect/ProgressBar").value = loaded_chunks
			await get_tree().create_timer(0.1).timeout
			if WorldDimension == 1:
				dir.make_dir("user://Worlds/"+str(VarGlobales.WorldFile)+"/Earth")
				dir.make_dir("user://Worlds/"+str(VarGlobales.WorldFile)+"/Earth/Chunk"+str(i_int))
			if WorldDimension == 2:
				dir.make_dir("user://Worlds/"+str(VarGlobales.WorldFile)+"/Shadow")
				dir.make_dir("user://Worlds/"+str(VarGlobales.WorldFile)+"/Shadow/Chunk"+str(i_int))
			var filesave = ConfigFile.new()
			for j in collection.size():
				var L = []
				var id = get_tree().get_root().get_node("World/TileMap").get_used_cells_by_id(0,0, id_to_coords(j) )
				if id != []:
					for c in id.size():
						if id[c][0] >= i_int*32 and id[c][0] < (i_int+1)*32:
							L.append([id[c][0],id[c][1]])
					filesave.set_value("Save",str(j),L)
					if WorldDimension == 1:
						filesave.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Earth/Chunk"+str(i_int)+"/Blocks.txt")
					if WorldDimension == 2:
						filesave.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Shadow/Chunk"+str(i_int)+"/Blocks.txt")
			loaded_chunks += 1

	get_tree().get_root().get_node("World/CanvasLayer/SaveRect/ColorRect/Label").text = "DIMENSION"
	await get_tree().create_timer(0.1).timeout
	var filesavechunks = ConfigFile.new()
	filesavechunks.set_value("Custom","Tags",VarGlobales.blocks_nbt)
	filesavechunks.set_value("Chunks","Biomes",VarGlobales.chunk_biome)
	VarGlobales.LoadedTimes += 1
	filesavechunks.set_value("Chunks","Loaded",VarGlobales.LoadedRegions)
	filesavechunks.set_value("Chunks","LoadedTimes",VarGlobales.LoadedTimes)
	filesavechunks.set_value("Chunks","WorldBiome",VarGlobales.WorldBiome)
	if WorldDimension == 1:
		filesavechunks.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Earth/Infos.txt")
	if WorldDimension == 2:
		filesavechunks.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Shadow/Infos.txt")

	get_tree().get_root().get_node("World/CanvasLayer/SaveRect/ColorRect/Label").text = "ENTITIES"
	await get_tree().create_timer(0.1).timeout
	VarGlobales.save_mobs = 1
	VarGlobales.save_items = 1
	get_tree().get_root().get_node("World/CanvasLayer/SaveRect").visible = false
	print("save ok")
	saving = 0
	
	
	if VarGlobales.Teleportation == 1: ## Si la demande de TP earth, tp earth
		VarGlobales.Teleportation = 2
	if VarGlobales.Teleportation == 3: ## Si la demande de TP shadow, tp shadow
		VarGlobales.Teleportation = 4
	
	if save_items == 1:
		var file_mob = DirAccess.open("user://")
		if VarGlobales.WorldDimension == 1:
			file_mob.remove("Worlds/"+str(VarGlobales.WorldFile)+"/Earth/Items.txt")
		if VarGlobales.WorldDimension == 2:
			file_mob.remove("Worlds/"+str(VarGlobales.WorldFile)+"/Shadow/Items.txt")
			
	await get_tree().create_timer(3).timeout
	var capture = get_viewport().get_texture().get_image()
	capture.crop(1280/2,720/2)
	capture.blit_rect(capture, Rect2(0, 0, 1280/2, 720/2), Vector2i(1280/2,720/2))
	var filename = "user://Worlds/"+str(VarGlobales.WorldFile)+"/screenshot.png"
	capture.save_png(filename)

func check_inv(id,number):
	if typeof(id) == TYPE_INT: ## Si c'est un id, trouver l'id dans l'inv
		for i in range(0,8):
			if VarGlobales.inv_slot[i] == id:
				if VarGlobales.inv_slot_count[i] >= number:
					return true
				else:
					return false
		return false
	if typeof(id) == TYPE_STRING: ## si c'est un tag, trouver le tag dans l'inv
		var nbr_in = 0
		for i in range(0,8):
			if check_tag(id,VarGlobales.inv_slot[i]) == true:
				nbr_in += VarGlobales.inv_slot_count[i]
		if nbr_in >= number:
			return true
		else:
			return false
	
func remove_inv(id,number):
	if typeof(id) == TYPE_INT: ## Si c'est un id, trouver l'id dans l'inv
		for i in 8:
			if VarGlobales.inv_slot[i] == id:
				VarGlobales.inv_slot_count[i] -= number
				return true
		return false
	if typeof(id) == TYPE_STRING: ## si c'est un tag, trouver le tag dans l'inv
		var nbr_in = number
		for i in 8:
			if check_tag(id,VarGlobales.inv_slot[i]) == true:
				if VarGlobales.inv_slot_count[i] >= nbr_in:
					VarGlobales.inv_slot_count[i] -= nbr_in
					return true
				else:
					nbr_in -= VarGlobales.inv_slot_count[i]
					VarGlobales.inv_slot_count[i] = 0
					VarGlobales.inv_slot[i] = -1
		return false
	
func spawn_mob(positionmob,id,healthvar):
	if VarGlobales.mob_caps[VarGlobales.mob_names[id]] < 25:
		var new_mob = mob.instantiate()
		new_mob.translate(positionmob)
		new_mob.get_node(".").id = id
		new_mob.get_node(".").health = healthvar
		new_mob.name = "Mob"+str(int(VarGlobales.mob_caps["Sheep"])+int(VarGlobales.mob_caps["Zombie"])+int(VarGlobales.mob_caps["Bee"]))
		VarGlobales.mob_caps[VarGlobales.mob_names[id]] += 1
		get_node("/root/PersistentNodes").add_child(new_mob)
	
func spawn_item(position,id,count,tag=-1):
		var new_item = item.instantiate()
		new_item.translate(position)
		new_item.get_node("Sprite2D").texture = load(VarGlobales.collection[str(id)][0])
		new_item.get_node(".").id = id
		new_item.get_node(".").count = count
		new_item.get_node(".").tag = tag
		get_node("/root/PersistentNodes").add_child(new_item)

func add_effect(id,time):
	var panel = Panel.new()
	panel.name = "Panel"+str(id)
	panel.custom_minimum_size = Vector2(30,30)
	panel.self_modulate = Color("7d00ff")
	get_node("../World/CanvasLayer/HBoxContainer").add_child(panel)
	var sprite = Sprite2D.new()
	if id == 0:
		sprite.texture = load("res://Textures/Items/health_potion.png")
	if id == 1:
		sprite.texture = load("res://Textures/Items/force_potion.png")
	if id == 2:
		sprite.texture = load("res://Textures/Items/speed_breaking_potion.png")
	if id == 3:
		sprite.texture = load("res://Textures/Items/attraction_potion.png")
	if id == 4:
		sprite.texture = load("res://Textures/Items/jump_potion.png")
	if id == 5:
		sprite.texture = load("res://Textures/Items/speed_potion.png")
	if id == 6:
		sprite.texture = load("res://Textures/Items/night_vision_potion.png")
	if id == 7:
		sprite.texture = load("res://Textures/Items/fortune_potion.png")
	if id == 8:
		sprite.texture = load("res://Textures/Items/range_potion.png")
	sprite.scale = Vector2(0.8,0.8)
	sprite.position = Vector2(15,14)
	panel.add_child(sprite)
	var label = Label.new()
	label.custom_minimum_size = Vector2(30*1.2,30)
	label.position = Vector2(0,30)
	label.text = str(time)
	label.name = "Time"
	label.scale = Vector2(0.8,0.8)
#	label.align = Label.ALIGNMENT_CENTER
#	label.valign = Label.VALIGN_TOP
	panel.add_child(label)
	potions_active[id] = 1
	potions_timer[id] = time
	
