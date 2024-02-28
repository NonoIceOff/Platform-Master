extends RigidBody2D

var id = 0
var count = 1
var tag = -1

const speed = 1

func _ready():
	VarGlobales.items_number += 1
	get_node("Label").text = str(count)
	
func _process(_delta):
	if VarGlobales.Teleportation > 0:
		queue_free()
	
	if VarGlobales.inGUI >= 1:
		sleeping = true
	else:
		sleeping = false
	
	if VarGlobales.inGUI < 1:
		var chunk = floor(self.position.x/16/16)
		
		if VarGlobales.save_items == 1:
			if "Chunk"+str(chunk) in VarGlobales.items_saving: ## Ajouter le mob dans le dictionnaire index de son chunk
				VarGlobales.items_saving["Chunk"+str(chunk)].append([id,position.x,position.y,count,tag])
			else:
				VarGlobales.items_saving["Chunk"+str(chunk)] = [] ## La valeur du dictionnaire, une liste
				VarGlobales.items_saving["Chunk"+str(chunk)].append([id,position.x,position.y,count,tag]) ## Ajouter le mob (liste) dans la liste
			VarGlobales.number_save_items += 1
			if VarGlobales.number_save_items == VarGlobales.items_number:
				var file_mob = ConfigFile.new()
				file_mob.set_value("Items","Values",VarGlobales.items_saving)
				if VarGlobales.WorldDimension == 1:
					file_mob.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Earth/Items.txt")
				if VarGlobales.WorldDimension == 2:
					file_mob.save("user://Worlds/"+str(VarGlobales.WorldFile)+"/Shadow/Items.txt")
				VarGlobales.number_save_items = 0
				VarGlobales.save_items = 2

		if VarGlobales.save_items == 2:
			VarGlobales.save_items = 0
			VarGlobales.items_saving = {}
			
		## Dégats de void
		if position.y/16 >= get_node("/root/World").world_depth+10:
			queue_free()

func _physics_process(_delta):
	if VarGlobales.inGUI < 1:
		##CONVEYOR BELTS RIGHT
		if get_node("/root/World").get_cell(floor(self.get_position().x/16),floor(self.get_position().y/16),get_node("/root/World/TileMap")) == 66:
			if get_node("/root/World/TileMap").is_cell_x_flipped(floor(self.get_position().x/16),floor(self.get_position().y/16)) == true:
				position.x -= 5
			else:
				position.x += 5
			freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
		else:
			freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
