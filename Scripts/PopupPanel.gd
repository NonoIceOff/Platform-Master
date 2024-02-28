extends Panel

var item = 0
var worldid = 0
var clicked = 0

func check_block():
	var compt = 0
	for i in VarGlobales.collection.keys():
		if VarGlobales.collection[i][4] == 0:
			compt += 1
	return compt

func _ready():
	self_modulate = Color(0.3, 0, 0.3)
	var scroll = get_node("ScrollContainer/VBoxContainer")
	for i in 20:
		for j in 10:
			if item < check_block():
				
				var image = Sprite2D.new()
				image.name = "Image"+str(item)
				image.set_position(Vector2(22+38*j,22+38*i))
				image.texture = load("res://Textures/inv_slot_selected.png")
				scroll.add_child(image)
				
				var image2 = Sprite2D.new()
				image2.name = "Image2"+str(item)
				image2.scale = Vector2(0.8,0.8)/2
				image2.texture = load(VarGlobales.collection[str(item)][0])
				image.add_child(image2)
				
				

				var imagebut = Button.new()
				imagebut.text = ""
				imagebut.flat = true
				imagebut.focus_mode = Control.FOCUS_NONE
				imagebut.name = "ImageBut"
				image.scale = Vector2(2,2)
				imagebut.custom_minimum_size = Vector2(32,32)
				imagebut.set_position(Vector2(-16,-16))
				image.add_child(imagebut)

				item += 1
			else:
				var image = Sprite2D.new()
				image.scale = Vector2(2,2)
				image.set_position(Vector2(22+38*j,22+38*i))
				image.texture = load("res://Textures/inv_slot.png")
				scroll.add_child(image)
		if item%10 == 0:
			get_node("ScrollContainer/VBoxContainer/Label").text = str("\n").repeat(floor(item/10)*4)
	pass


#func _process(_delta):
#	for id in VarGlobales.inv_category_blocks.size():
#		if get_node("ScrollContainer/VBoxContainer/Image"+str(id)+"/ImageBut").pressed:
#			VarGlobales.WorldThumbnail = id
#			clicked = 1
#			get_node("../ScrollContainer/VBoxContainer/Panel"+str(worldid)+"/Sprite2D"+str(worldid)).texture = load(VarGlobales.collection[str(id)][0])
