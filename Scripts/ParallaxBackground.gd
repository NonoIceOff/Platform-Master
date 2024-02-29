extends ParallaxBackground

var biomes_text = [
	"res://Textures/Biome/plains.png",
	"res://Textures/Biome/desert.png",
	"res://Textures/Biome/snowy_plains.png",
	"res://Textures/Biome/birch.png",
	"res://Textures/Biome/riverian_forest.png",
	"res://Textures/Biome/ocean.png"
	]
	
var biomes_musics = [
	"res://Sounds/Biomes/plains.mp3",
	"res://Sounds/Biomes/desert.mp3",
	"res://Sounds/Biomes/snowy_plains.mp3",
	"res://Sounds/Biomes/birch_forest.mp3",
	"res://Sounds/Biomes/riverian_forest.mp3",
	"res://Sounds/Biomes/ocean.mp3"
]

func biome_id(nbr_region):
	if VarGlobales.chunk_biome.has(nbr_region):
		return VarGlobales.chunk_biome[nbr_region]
	else:
		return 0

func _process(delta):
	get_node("Nuages").motion_offset.x += 0.1
	if floor(get_node("../CharacterBody2D").get_position().x/16/16) in VarGlobales.chunk_biome:
		var biome_id = biome_id(floor(get_node("../CharacterBody2D").get_position().x/16/16))
		get_node("BiomeBackground/Sprite2D").texture = load(biomes_text[biome_id])
		if get_node("../../MusicController/Music").stream != load(biomes_musics[biome_id]):
			get_node("../../MusicController/Music").stream = load(biomes_musics[biome_id])
			get_node("../../MusicController/Music").playing = true
