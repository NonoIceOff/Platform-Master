extends CanvasLayer

func _process(_delta):
	if OS.get_name() == "Android":
		get_node("Mobile_Inventory").visible = true
		get_node("Mobile_Pause").visible = true
		get_node("Mobile_Up").visible = true
		get_node("Mobile_Mode").visible = true
		if get_node("../CanvasLayer/CheckButton").button_pressed == true:
			get_node("Mobile_Down").visible = true
		else:
			get_node("Mobile_Down").visible = false
		get_node("Mobile_Left").visible = true
		get_node("Mobile_Right").visible = true
		
		if get_node("Mobile_Mode").button_pressed == true:
			get_node("Mobile_Mode").icon = load("res://Textures/Mobile/break.png")
			get_node("../../World").clickmode = 0
		else:
			get_node("Mobile_Mode").icon = load("res://Textures/Mobile/pose.png")
			get_node("../../World").clickmode = 1
			
		get_node("HealthBar").position = Vector2(12,12)*2
		get_node("HealthBar").scale = Vector2(2,2)*2
		get_node("FoodBar").position = Vector2(12,34)*2
		get_node("FoodBar").scale = Vector2(2,2)*2
		get_node("SaturationBar").position = Vector2(12,34)*2
		get_node("SaturationBar").scale = Vector2(2,2)*2
		
	else:
		get_node("HealthBar").position = Vector2(12,12)
		get_node("HealthBar").scale = Vector2(2,2)
		get_node("FoodBar").position = Vector2(12,34)
		get_node("FoodBar").scale = Vector2(2,2)
		get_node("SaturationBar").position = Vector2(12,34)
		get_node("SaturationBar").scale = Vector2(2,2)
		
		get_node("Mobile_Inventory").visible = false
		get_node("Mobile_Pause").visible = false
		get_node("Mobile_Up").visible = false
		get_node("Mobile_Down").visible = false
		get_node("Mobile_Left").visible = false
		get_node("Mobile_Right").visible = false
		get_node("Mobile_Mode").visible = false
		
	if VarGlobales.WorldMode != 0:
		get_node("HealthBar").visible = false
		get_node("FoodBar").visible = false
		get_node("SaturationBar").visible = false
		get_node("TimeLabel").position.y = 8
		get_node("TimeProgress").position.y = 28
	else:
		get_node("HealthBar").visible = true
		get_node("FoodBar").visible = true
		get_node("SaturationBar").visible = true
		get_node("TimeLabel").position.y = 57
		get_node("TimeProgress").position.y = 76
		
	get_node("HealthBar").value = VarGlobales.health
	get_node("FoodBar").value = VarGlobales.food
	get_node("SaturationBar").value = VarGlobales.saturation
	
	if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 73:
		if get_node("TimeLabel").visible == true:
			get_node("TimeLabel").text = "Time : "
			if VarGlobales.time_hour >= 10:
				get_node("TimeLabel").text += str(VarGlobales.time_hour)
			if VarGlobales.time_hour < 10:
				get_node("TimeLabel").text += "0"+str(VarGlobales.time_hour)
			if VarGlobales.time_min >= 10:
				get_node("TimeLabel").text += ":"+str(VarGlobales.time_min)
			if VarGlobales.time_min < 10:
				get_node("TimeLabel").text += ":0"+str(VarGlobales.time_min)
			get_node("TimeLabel").text += " (Day "+str(VarGlobales.time_day)+")"
		get_node("TimeProgress").visible = true
		get_node("TimeProgress").value = VarGlobales.time_tick
	else:
		get_node("TimeLabel").text = ""
		get_node("TimeProgress").visible = false
	
	if VarGlobales.food > 100:
		VarGlobales.saturation = VarGlobales.food-100
		
			
		##CAUSES
		if VarGlobales.WorldMode == 0:
			if VarGlobales.death >= 1 and VarGlobales.death < 100:
				get_node("../CanvasLayer_GUI/DeadGUI").visible = true
				VarGlobales.inGUI = 1
				for i in range(1,9):
					get_node("../CanvasLayer/inv_slot"+str(i)).visible = false
				get_node("../CanvasLayer/Label").visible = false
				get_node("../CanvasLayer/InfoLabel").visible = false
				get_node("HealthBar").visible = false
				get_node("FoodBar").visible = false
				get_node("SaturationBar").visible = false
				VarGlobales.food = 50
				VarGlobales.health = 100
				VarGlobales.death = 100
				
			if VarGlobales.death == 0:
				if VarGlobales.food <= 0:
					if not VarGlobales.health < 0:
						VarGlobales.health -= 0.1
					if VarGlobales.health <= 0:
						VarGlobales.death = 1
						get_node("../CharacterBody2D").velocity.x = 0
						get_node("../Player").stream = load("res://Sounds/dead.mp3")
						get_node("../Player").pitch_scale = randf_range(0.75,1.25)
						get_node("../Player").play()
						get_node("../CanvasLayer_GUI/DeadGUI/PanelPrincipal/Label2").text = str("Unfortunately you died of hunger.")


func _on_Mobile_Inventory_pressed():
	if VarGlobales.inGUI == 0:
		if VarGlobales.WorldMode == 0:
			VarGlobales.inGUI += 1
			get_node("../CanvasLayer_GUI/SoftCraftGUI").visible = true
		elif VarGlobales.WorldMode == 1:
			VarGlobales.inGUI += 1
			get_node("../CanvasLayer_GUI/CheatGUI").visible = true


func _on_Mobile_Inventory2_pressed():
	if VarGlobales.inGUI == 0:
		VarGlobales.inGUI += 1
		get_node("../CanvasLayer_GUI/PauseGUI").visible = true

