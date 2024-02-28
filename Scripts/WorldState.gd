extends Control


func _process(_delta):
	if VarGlobales.WorldState == 0:
		get_node("Title").text = "menu_worldstate_creating_world"
		get_node("WorldInfos").text = "\nWorld Name : "+str(VarGlobales.WorldName)+"\nWorld Seed : "+str(VarGlobales.WorldSeed)+"\nGame Mode : "+str(VarGlobales.WorldMode)

		var t = Timer.new()
		t.set_wait_time(1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		await t.timeout
		t.queue_free()
		get_tree().change_scene_to_file("res://Scènes/World.tscn")
		
	if VarGlobales.WorldState == 1:
		get_node("Title").text = "menu_worldstate_loading_world"
		get_node("WorldInfos").text =  "\nWorld Name : "+str(VarGlobales.WorldName)+"\nWorld Seed : "+str(VarGlobales.WorldSeed)+"\nGame Mode : "+str(VarGlobales.WorldMode)
		
		var t = Timer.new()
		t.set_wait_time(1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		await t.timeout
		t.queue_free()
		get_tree().change_scene_to_file("res://Scènes/World.tscn")
