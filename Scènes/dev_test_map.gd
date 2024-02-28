extends Node2D

func _init():
	Generation.tilemap = "../DevTestMap/TileMap"
	Generation.tilemap_torch = "../DevTestMap/TileMap_Torchs"
	Generation.tilemap_lights = "../DevTestMap/TileMap_Light"
	Generation.speed = 0
	
func wait(sec):
	var t = Timer.new()
	t.set_wait_time(sec)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await t.timeout
	t.queue_free()
	
func _ready():
	var grandeur = 100
	for i in range(0,grandeur):
		await Generation.gen_world(i,1)
		await wait(0.1)
	print("ok")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


