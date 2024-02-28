extends TileMap

func _init():
	Generation.tilemap = "../Control/MainMenu/Camera2D/BackgroundMap"
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
	await Generation.gen_world(-1,0)
	await Generation.gen_world(0,0)
	await Generation.gen_world(1,0)
	await Generation.gen_world(2,0)
	var i = 3
	while true:
		if i % 10 == 0:
			clear()
			await Generation.gen_world(i-4,0)
			await Generation.gen_world(i-3,0)
			await Generation.gen_world(i-2,0)
			await Generation.gen_world(i-1,0)
		else:
			await Generation.gen_world(i,0)
		await wait(5)
		i += 1
