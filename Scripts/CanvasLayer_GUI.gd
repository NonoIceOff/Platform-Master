extends CanvasLayer

var item = 0

var item_recipes
var craft_button = 0

var stats_visible = 0
var chest_ready = 0

var transi_time = 0

var chat_hover = 0
var chat_focus = 0

var onsign = 0

func check_block():
	var compt = 0
	for i in VarGlobales.collection.keys():
		if VarGlobales.collection[i][4] == 0:
			compt += 1
	return compt

func check_items():
	var compt = 0
	for i in VarGlobales.collection.keys():
		if VarGlobales.collection[i][4] == 1:
			compt += 1
	return compt
	
func get_items():
	var array = []
	for i in VarGlobales.collection.keys():
		if VarGlobales.collection[i][4] == 1:
			array.append(i)
	return array
	
func get_blocks():
	var array = []
	for i in VarGlobales.collection.keys():
		if VarGlobales.collection[i][4] == 0:
			array.append(i)
	return array


	
func check_all():
	var compt = 0
	for i in VarGlobales.collection.keys():
		compt += 1
	return compt
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() == "Android":
		get_node("CheatGUI/Mobile_Inventory").visible = true
		get_node("SoftCraftGUI/Mobile_Inventory").visible = true
		offset.x = -640
		scale = Vector2(2,2)
	else:
		get_node("CheatGUI/Mobile_Inventory").visible = false
		get_node("SoftCraftGUI/Mobile_Inventory").visible = false
		offset.x = 0
		scale = Vector2(1,1)
		
	get_node("PauseGUI/Quit_But").disabled = false
	
	all_blocks()
	all_items()
	all_all()
	show_recipes()
	show_soft_recipes()
	show_furnace_recipes()
	show_anvil_recipes()
	unshow_chisel_recipes()
	show_cauldron_recipes()
	show_chest_slots()
	pass # Replace with function body.

func show_recipes():
	item_recipes = 0
	var scroll = get_node("CraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer")
	for i in 10:
		for j in 10:
			if item_recipes < VarGlobales.recipes.size():
				var imageslot = Sprite2D.new()
				imageslot.name = "Slot"+str(item_recipes)
				imageslot.scale = Vector2(2,2)
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot_selected.png")
				scroll.add_child(imageslot)
				var image = Sprite2D.new()
				image.name = "Image"
				image.scale = Vector2(0.75,0.75)/2
				image.texture = load(VarGlobales.collection[str(VarGlobales.recipes[item_recipes][0])][0])
				imageslot.add_child(image)
				var imagebut = Button.new()
				imagebut.flat = true
				imagebut.focus_mode = Control.FOCUS_NONE
				imagebut.name = "ImageBut"
				imagebut.custom_minimum_size = Vector2(38,38)
				imagebut.set_position(Vector2(-20,-20))
				image.add_child(imagebut)
				item_recipes += 1
			else:
				var imageslot = Sprite2D.new()
				imageslot.name = "NoneSlot"
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot.png")
				scroll.add_child(imageslot)
		if item_recipes%10 == 0:
			get_node("CraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Label").text = str("\n").repeat(16)
		
func show_soft_recipes():
	item_recipes = 0
	var scroll = get_node("SoftCraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer")
	for i in 10:
		for j in 10:
			if item_recipes < VarGlobales.softrecipes.size():
				var imageslot = Sprite2D.new()
				imageslot.name = "Slot"+str(item_recipes)
				imageslot.scale = Vector2(2,2)
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot_selected.png")
				scroll.add_child(imageslot)
				var image = Sprite2D.new()
				image.name = "Image"
				image.scale = Vector2(0.75,0.75)/2
				image.texture = load(VarGlobales.collection[str(VarGlobales.softrecipes[item_recipes][0])][0])
				imageslot.add_child(image)
				var imagebut = Button.new()
				imagebut.flat = true
				imagebut.focus_mode = Control.FOCUS_NONE
				imagebut.name = "ImageBut"
				imagebut.custom_minimum_size = Vector2(38,38)
				imagebut.set_position(Vector2(-20,-20))
				image.add_child(imagebut)
				item_recipes += 1
			else:
				var imageslot = Sprite2D.new()
				imageslot.name = "NoneSlot"
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot.png")
				scroll.add_child(imageslot)
		if item_recipes%10 == 0:
			get_node("SoftCraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Label").text = str("\n").repeat(16)
		
func show_furnace_recipes():
	item_recipes = 0
	var scroll = get_node("FurnaceGUI/PanelPrincipal/ScrollContainer/VBoxContainer")
	for i in 10:
		for j in 10:
			if item_recipes < VarGlobales.furnace_recipes.size():
				var imageslot = Sprite2D.new()
				imageslot.name = "Slot"+str(item_recipes)
				imageslot.scale = Vector2(2,2)
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot_selected.png")
				scroll.add_child(imageslot)
				var image = Sprite2D.new()
				image.name = "Image"
				image.scale = Vector2(0.75,0.75)/2
				image.texture = load(VarGlobales.collection[str(VarGlobales.furnace_recipes[item_recipes][0])][0])
				imageslot.add_child(image)
				var imagebut = Button.new()
				imagebut.flat = true
				imagebut.focus_mode = Control.FOCUS_NONE
				imagebut.name = "ImageBut"
				imagebut.custom_minimum_size = Vector2(38,38)
				imagebut.set_position(Vector2(-20,-20))
				image.add_child(imagebut)
				item_recipes += 1
			else:
				var imageslot = Sprite2D.new()
				imageslot.name = "NoneSlot"
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot.png")
				scroll.add_child(imageslot)
		if item_recipes%10 == 0:
			get_node("FurnaceGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Label").text = str("\n").repeat(16)

func show_anvil_recipes():
	item_recipes = 0
	var scroll = get_node("AnvilGUI/PanelPrincipal/ScrollContainer/VBoxContainer")
	for i in 10:
		for j in 10:
			if item_recipes < VarGlobales.anvil_recipes.size():
				var imageslot = Sprite2D.new()
				imageslot.name = "Slot"+str(item_recipes)
				imageslot.scale = Vector2(2,2)
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot_selected.png")
				scroll.add_child(imageslot)
				var image = Sprite2D.new()
				image.name = "Image"
				image.scale = Vector2(0.75,0.75)/2
				image.texture = load(VarGlobales.collection[str(VarGlobales.anvil_recipes[item_recipes][0])][0])
				imageslot.add_child(image)
				var imagebut = Button.new()
				imagebut.flat = true
				imagebut.focus_mode = Control.FOCUS_NONE
				imagebut.name = "ImageBut"
				imagebut.custom_minimum_size = Vector2(38,38)
				imagebut.set_position(Vector2(-20,-20))
				image.add_child(imagebut)
				item_recipes += 1
			else:
				var imageslot = Sprite2D.new()
				imageslot.name = "NoneSlot"
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot.png")
				scroll.add_child(imageslot)
		if item_recipes%10 == 0:
			get_node("AnvilGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Label").text = str("\n").repeat(16)

func show_chisel_recipes(index):
	var array_nodes = get_node("ChiselGUI/PanelPrincipal/ScrollContainer/VBoxContainer").get_children()
	for i in array_nodes.size():
		array_nodes[i].queue_free()
	item_recipes = 0
	var scroll = get_node("ChiselGUI/PanelPrincipal/ScrollContainer/VBoxContainer")
	for i in 3:
		for j in 10:
			if item_recipes < VarGlobales.chisel_recipes[check_inv_chisel_recipes(index)].size():
				var imageslot = Sprite2D.new()
				imageslot.name = "Slot"+str(item_recipes)
				imageslot.scale = Vector2(2,2)
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot_selected.png")
				scroll.add_child(imageslot)
				var image = Sprite2D.new()
				image.name = "Image"
				image.scale = Vector2(0.75,0.75)/2
				image.texture = load(VarGlobales.collection[str(VarGlobales.chisel_recipes[check_inv_chisel_recipes(index)][item_recipes])][0])
				imageslot.add_child(image)
				var imagebut = Button.new()
				imagebut.flat = true
				imagebut.focus_mode = Control.FOCUS_NONE
				imagebut.name = "ImageBut"
				imagebut.custom_minimum_size = Vector2(38,38)
				imagebut.set_position(Vector2(-20,-20))
				image.add_child(imagebut)
				item_recipes += 1
			else:
				var imageslot = Sprite2D.new()
				imageslot.name = "NoneSlot"
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot.png")
				scroll.add_child(imageslot)

func unshow_chisel_recipes():
	var array_nodes = get_node("ChiselGUI/PanelPrincipal/ScrollContainer/VBoxContainer").get_children()
	for i in array_nodes.size():
		array_nodes[i].queue_free()
		#yield(get_tree(),"idle_frame")
	var scroll = get_node("ChiselGUI/PanelPrincipal/ScrollContainer/VBoxContainer")
	for i in 3:
		for j in 10:
			var imageslot = Sprite2D.new()
			imageslot.name = "NoneSlot"
			imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
			imageslot.texture = load("res://Textures/inv_slot.png")
			scroll.add_child(imageslot)

func show_cauldron_recipes():
	item_recipes = 0
	var scroll = get_node("CauldronGUI/PanelPrincipal/ScrollContainer/VBoxContainer")
	for i in 10:
		for j in 10:
			if item_recipes < VarGlobales.cauldron_recipes.size():
				var imageslot = Sprite2D.new()
				imageslot.name = "Slot"+str(item_recipes)
				imageslot.scale = Vector2(2,2)
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot_selected.png")
				scroll.add_child(imageslot)
				var image = Sprite2D.new()
				image.name = "Image"
				image.scale = Vector2(0.75,0.75)/2
				image.texture = load(VarGlobales.collection[str(VarGlobales.cauldron_recipes[item_recipes][0])][0])
				imageslot.add_child(image)
				var imagebut = Button.new()
				imagebut.flat = true
				imagebut.focus_mode = Control.FOCUS_NONE
				imagebut.name = "ImageBut"
				imagebut.custom_minimum_size = Vector2(38,38)
				imagebut.set_position(Vector2(-20,-20))
				image.add_child(imagebut)
				item_recipes += 1
			else:
				var imageslot = Sprite2D.new()
				imageslot.name = "NoneSlot"
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot.png")
				scroll.add_child(imageslot)
		if item_recipes%10 == 0:
			get_node("CauldronGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Label").text = str("\n").repeat(16)

func all_blocks():
	item = 0
	var scroll = get_node("CheatGUI/PanelPrincipal/Blocks/VBoxContainer")
	for i in VarGlobales.cat_blocks.size()/10+1:
		for j in 10:
			if item < check_block():
				var id = VarGlobales.cat_blocks[item]
				var imageslot = Sprite2D.new()
				imageslot.name = "Slot"+str(item)
				imageslot.scale = Vector2(2,2)
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot_selected.png")
				scroll.add_child(imageslot)
				
				var image = Sprite2D.new()
				image.name = "Image"
				image.scale = Vector2(0.75,0.75)/2
				image.texture = load(VarGlobales.collection[str(id)][0])
				imageslot.add_child(image)
				
				var imagebut = Button.new()
				imagebut.flat = true
				imagebut.focus_mode = Control.FOCUS_NONE
				imagebut.name = "ImageBut"
				imagebut.custom_minimum_size = Vector2(32,32)
				imagebut.set_position(Vector2(-16,-16))
				image.add_child(imagebut)
			
				item += 1
				
			else:
				var imageslot = Sprite2D.new()
				imageslot.name = "NoneSlot"
				imageslot.scale = Vector2(2,2)
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot.png")
				scroll.add_child(imageslot)
			get_node("CheatGUI/PanelPrincipal/Blocks/VBoxContainer/Label").text = str("\n").repeat(floor(item)*1.5)
		
func all_items():
	item = 0
	var array = get_items()
	var scroll = get_node("CheatGUI/PanelPrincipal/Items/VBoxContainer")
	for i in VarGlobales.cat_items.size()/10+1:
		for j in 10:
			if item < check_items():
				var id = VarGlobales.cat_items[item]
				var imageslot = Sprite2D.new()
				imageslot.name = "Slot"+str(item)
				imageslot.scale = Vector2(2,2)
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot_selected.png")
				scroll.add_child(imageslot)
				
				var image = Sprite2D.new()
				image.name = "Image"
				image.scale = Vector2(0.75,0.75)/2
				image.texture = load(VarGlobales.collection[str(id)][0])
				imageslot.add_child(image)
				
				var imagebut = Button.new()
				imagebut.flat = true
				imagebut.focus_mode = Control.FOCUS_NONE
				imagebut.name = "ImageBut"
				imagebut.custom_minimum_size = Vector2(32,32)
				imagebut.set_position(Vector2(-16,-16))
				image.add_child(imagebut)
			
				item += 1
				
			else:
				var imageslot = Sprite2D.new()
				imageslot.name = "NoneSlot"
				imageslot.scale = Vector2(2,2)
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot.png")
				scroll.add_child(imageslot)
			get_node("CheatGUI/PanelPrincipal/Items/VBoxContainer/Label").text = str("\n").repeat(floor(item)*1.5)
				
func all_all():
	item = 0
	var scroll = get_node("CheatGUI/PanelPrincipal/All/VBoxContainer")
	for i in VarGlobales.cat_all.size()/10+1:
		for j in 10:
			if item < VarGlobales.cat_all.size():
				var id = VarGlobales.cat_all[item]
				
				var imageslot = Sprite2D.new()
				imageslot.name = "Slot"+str(item)
				imageslot.scale = Vector2(2,2)
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.texture = load("res://Textures/inv_slot_selected.png")
				scroll.add_child(imageslot)
				
				var image = Sprite2D.new()
				image.name = "Image"
				image.scale = Vector2(0.75,0.75)/2
				image.texture = load(VarGlobales.collection[str(id)][0])
				imageslot.add_child(image)
				
				var imagebut = Button.new()
				imagebut.flat = true
				imagebut.focus_mode = Control.FOCUS_NONE
				imagebut.name = "ImageBut"
				imagebut.custom_minimum_size = Vector2(32,32)
				imagebut.set_position(Vector2(-16,-16))
				image.add_child(imagebut)
			
				item += 1
				
			else:
				var imageslot = Sprite2D.new()
				imageslot.name = "NoneSlot"
				imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
				imageslot.scale = Vector2(2,2)
				imageslot.texture = load("res://Textures/inv_slot.png")
				scroll.add_child(imageslot)
			get_node("CheatGUI/PanelPrincipal/All/VBoxContainer/Label").text = str("\n").repeat(floor(item)*1.5)
		
				
func show_chest_slots():
	chest_ready = 0
	for n in get_node("ChestGUI/test/Blocks/VBoxContainer").get_children():
		get_node("ChestGUI/test/Blocks/VBoxContainer").remove_child(n)
		n.queue_free()
	
	item = 0
	var scroll = get_node("ChestGUI/test/Blocks/VBoxContainer")
	for i in 2:
		for j in 10:
			
			var imageslot = Sprite2D.new()
			imageslot.name = "Slot"+str(item)
			imageslot.scale = Vector2(2,2)
			imageslot.set_position(Vector2(42*(j+1)-25,42*(i+1)-25))
			if VarGlobales.block_in in VarGlobales.blocks_nbt:
				var nbt_slot = VarGlobales.blocks_nbt[VarGlobales.block_in][1][item]
				if nbt_slot.size() > 0 and nbt_slot != []:
					imageslot.texture = load("res://Textures/inv_slot_selected.png")
				else:
					imageslot.texture = load("res://Textures/inv_slot.png")
			else:
				imageslot.texture = load("res://Textures/inv_slot.png")
			scroll.add_child(imageslot)
			
			var image = Sprite2D.new()
			image.name = "Image"
			image.scale = Vector2(0.75,0.75)/2
			if VarGlobales.block_in in VarGlobales.blocks_nbt:
				var nbt_slot = VarGlobales.blocks_nbt[VarGlobales.block_in][1][item]
				if nbt_slot.size() > 0 and nbt_slot != []:
					image.texture = load(VarGlobales.collection[str(nbt_slot[0])][0])
					var nbrslot = Label.new()
					nbrslot.name = "NumberSlot"
					nbrslot.text = str(nbt_slot[1])
					nbrslot.position = Vector2(-16,-4)
					nbrslot.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
					image.add_child(nbrslot)
				else:
					image.texture = null
			else:
				image.texture = null
			imageslot.add_child(image)
			
			var imagebut = Button.new()
			imagebut.flat = true
			imagebut.focus_mode = Control.FOCUS_NONE
			imagebut.name = "ImageBut"
			imagebut.custom_minimum_size = Vector2(32,32)
			imagebut.set_position(Vector2(-16,-16))
			image.add_child(imagebut)
		
			item += 1
	chest_ready = 1

func easeInCubic(x):
	if OS.get_name() == "Android":
		return lerpf(x, -346, 0.1)
	else:
		return lerpf(x, 0, 0.1)
	
func easeOutCubic(x):
	if OS.get_name() == "Android":
		return lerpf(x, 300, 0.1)
	else:
		return lerpf(x, 100, 0.1)

func _process(_delta):
	get_node("../CanvasLayer/Slot_Info").position = get_viewport().get_mouse_position()
	get_node("../CanvasLayer/Slot_Info/Name").position.x = 8
	get_node("../CanvasLayer/Slot_Info/Name").size.x = 1
	get_node("../CanvasLayer/Slot_Info/Tag/Name").position.x = 0
	get_node("../CanvasLayer/Slot_Info/Tag/Name").size.x = 0
	get_node("../CanvasLayer/Slot_Info").size.x = get_node("../CanvasLayer/Slot_Info/Name").size.x*1.4+16
	get_node("../CanvasLayer/Slot_Info").visible = false
	get_node("../CanvasLayer/Slot_Info/Tag").visible = false
	get_node("../CanvasLayer/Slot_Info/Tag/Name").text = ""
	
	if get_node("../CanvasLayer/Slot_Info").position.x > 1280-get_node("../CanvasLayer/Slot_Info").size.x:
		get_node("../CanvasLayer/Slot_Info").position.x -= get_node("../CanvasLayer/Slot_Info").size.x
	
	if stats_visible == 0:
		if VarGlobales.inGUI >= 1:
			offset.y = easeInCubic(offset.y)
		else:
			offset.y = easeOutCubic(offset.y)
	else:
		offset.y = 0
		
	if Input.is_action_pressed("mouse_breakblock"):
		if chat_hover == 0:
			get_node("Chat").release_focus()
	
	if chat_focus == 0:
		if Input.is_action_just_pressed("ui_chat"):
				VarGlobales.inGUI += 1
				get_node("Chat").visible = true
				
		if Input.is_action_just_pressed("ui_e") or Input.is_action_just_pressed("ui_cancel"):
			get_node("Chat").visible = false
			
	if VarGlobales.inGUI > 1:
		VarGlobales.inGUI = 0
		
	if VarGlobales.inv_slot[VarGlobales.slot_selected-1] == 77:
		for slot in 8:
			var path = "BackPackGUI/test/backpack"+str(slot+1)+"/Button"+str(slot+1)+"_backpack"
			#print(VarGlobales.backpack_slots[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][slot])
			if get_node(path).is_hovered() and VarGlobales.backpack_slots[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][slot] != -1:
				get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.collection[str(VarGlobales.backpack_slots[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][slot])][1]
				get_node("../CanvasLayer/Slot_Info").visible = true
				
		
		
	for slot in 20:
		if get_node_or_null("ChestGUI/test/Blocks/VBoxContainer/Slot"+str(slot)+"/Image/ImageBut") != null:
			if get_node("ChestGUI/test/Blocks/VBoxContainer/Slot"+str(slot)+"/Image/ImageBut").is_hovered() == true:
				get_node("../CanvasLayer/Slot_Info/Name").text = ""
				var nbt_slot = VarGlobales.blocks_nbt[VarGlobales.block_in][1][slot]
				if nbt_slot != []:
					get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.collection[str(nbt_slot[0])][1]
					get_node("../CanvasLayer/Slot_Info").visible = true
					
	if get_node("SignGUI").visible == true:
		if onsign == 0:
			get_node("SignGUI/TextEdit").text = VarGlobales.blocks_nbt[VarGlobales.block_in][1]
			if VarGlobales.blocks_nbt[VarGlobales.block_in][1] == "":
				get_node("SignGUI/TextEdit").editable = true
			else:
				get_node("SignGUI/TextEdit").editable = false
		onsign = 1
	else:
		onsign = 0
			
		
	if get_node("ChestGUI").visible == true:
		if VarGlobales.block_in in VarGlobales.blocks_nbt:
			if chest_ready == 1:
				if get_node("../CanvasLayer").click_inv == 1:
					for slot in 20:
						if get_node("ChestGUI/test/Blocks/VBoxContainer/Slot"+str(slot)+"/Image/ImageBut").disabled == false:
							
							if get_node("ChestGUI/test/Blocks/VBoxContainer/Slot"+str(slot)+"/Image/ImageBut").button_pressed == true:
								var nbt_slot = VarGlobales.blocks_nbt[VarGlobales.block_in][1][slot]
								
								VarGlobales.blocks_nbt[VarGlobales.block_in][1][slot] = [get_node("../CanvasLayer").selected_inv,get_node("../CanvasLayer").selected_count,get_node("../CanvasLayer").selected_tag]
								
								if nbt_slot != []:
									get_node("../CanvasLayer").selected_inv = nbt_slot[0]
									get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(nbt_slot[0])][0])
									get_node("../CanvasLayer").selected_count = nbt_slot[1]
									get_node("../CanvasLayer/cursor_slot/Label").text = str(nbt_slot[1])
									get_node("../CanvasLayer").selected_tag = nbt_slot[2]
									show_chest_slots()
								else:
									get_node("../CanvasLayer").selected_inv = -1
									get_node("../CanvasLayer").selected_count = 0
									get_node("../CanvasLayer").selected_tag = -1
									show_chest_slots()
									get_node("../CanvasLayer").click_inv = 2
									get_node("../CanvasLayer/cursor_slot/item").texture = null
									get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0
									get_node("../CanvasLayer/cursor_slot/Label").text = ""
				
				if get_node("../CanvasLayer").click_inv == 0:
					for slot in 20:
						if get_node("ChestGUI/test/Blocks/VBoxContainer/Slot"+str(slot)+"/Image/ImageBut").disabled == false:
							if get_node("ChestGUI/test/Blocks/VBoxContainer/Slot"+str(slot)+"/Image/ImageBut").button_pressed == true:
								var nbt_slot = VarGlobales.blocks_nbt[VarGlobales.block_in][1][slot]
								if nbt_slot != []:
									get_node("../CanvasLayer").selected_inv = nbt_slot[0]
									get_node("../CanvasLayer").selected_count += nbt_slot[1]
									get_node("../CanvasLayer").selected_tag = nbt_slot[2]
									
									VarGlobales.blocks_nbt[VarGlobales.block_in][1][slot] = []
									show_chest_slots()
									
									get_node("../CanvasLayer").click_inv = 1
									get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
									get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
									if get_node("../CanvasLayer").selected_count > 1:
										get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
									else:
										get_node("../CanvasLayer/cursor_slot/Label").text = ""
									get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
						
						
					
		if get_node("../CanvasLayer").click_inv == 2:
			for slot2 in 20:
				get_node("ChestGUI/test/Blocks/VBoxContainer/Slot"+str(slot2)+"/Image/ImageBut").disabled = false
	
	if get_node("PauseGUI").visible == false:
		get_node("PauseGUI/Continue_But").position = Vector2(416,489)
		get_node("PauseGUI/Continue_But").hover = 0
		get_node("PauseGUI/Stats_But").position = Vector2(416,552)
		get_node("PauseGUI/Stats_But").hover = 0
		get_node("PauseGUI/Save_But").position = Vector2(416,617)
		get_node("PauseGUI/Save_But").hover = 0
		get_node("PauseGUI/Quit_But").position = Vector2(416,681)
		get_node("PauseGUI/Quit_But").hover = 0
	
	if stats_visible == 0:
		if get_node("StatsGUI").visible == true:
			for i in range(0,VarGlobales.stats_name.size()):
				var stat_title = Label.new()
				stat_title.text = str(VarGlobales.stats_name[i])
				get_node("StatsGUI/ScrollContainer/VBoxContainer").add_child(stat_title)
				var stat_title2 = Label.new()
				stat_title2.text = str(VarGlobales.stats_value[i])
				stat_title2.self_modulate = Color(0.5,0.5,0.5)
				#stat_title2.text = str(VarGlobales.stats_name[i])
				get_node("StatsGUI/ScrollContainer/VBoxContainer").add_child(stat_title2)
			stats_visible = 1
			
	
	
	if get_node("../CanvasLayer/Slot_Info").visible == true:
		get_node("../CanvasLayer/Slot_Info/Description").size.x = get_node("../CanvasLayer/Slot_Info").size.x
	get_node("../CanvasLayer/Slot_Info/Description").visible = false

	
	for i in check_block():
		if get_node("CheatGUI/PanelPrincipal/Blocks/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").is_hovered():
			#get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.inv_name[VarGlobales.inv_category_blocks[i]]
			get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.collection[str(VarGlobales.cat_blocks[i])][1]
			get_node("../CanvasLayer/Slot_Info").visible = true
	for i in check_items():
		if get_node("CheatGUI/PanelPrincipal/Items/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").is_hovered():
			#get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.inv_name[VarGlobales.inv_category_item[i]]
			get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.collection[str(VarGlobales.cat_items[i])][1]
			get_node("../CanvasLayer/Slot_Info").visible = true
	for i in VarGlobales.cat_all.size():
		if get_node("CheatGUI/PanelPrincipal/All/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").is_hovered():
			#get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.inv_name[i]
			get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.collection[str(VarGlobales.cat_all[i])][1]
			get_node("../CanvasLayer/Slot_Info").visible = true
	for i in VarGlobales.softrecipes.size():
		if get_node("SoftCraftGUI").visible == true:
			
			##glowing gray slots
			if VarGlobales.check_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3]) == false:
				get_node("SoftCraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1.15,1.15,1.15)
			else:
				get_node("SoftCraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
			if not VarGlobales.softrecipes[i][5] == 0:
				if VarGlobales.check_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3]) == false or VarGlobales.check_inv(VarGlobales.softrecipes[i][4],VarGlobales.softrecipes[i][5]) == false:
					get_node("SoftCraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1.15,1.15,1.15)
				else:
					get_node("SoftCraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
				if not VarGlobales.softrecipes[i][7] == 0:
					if VarGlobales.check_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3]) == false or VarGlobales.check_inv(VarGlobales.softrecipes[i][4],VarGlobales.softrecipes[i][5]) == false or VarGlobales.check_inv(VarGlobales.softrecipes[i][6],VarGlobales.softrecipes[i][7]) == false:
						get_node("SoftCraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1.15,1.15,1.15)
					else:
						get_node("SoftCraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
					if not VarGlobales.softrecipes[i][9] == 0:
						if VarGlobales.check_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3]) == false or VarGlobales.check_inv(VarGlobales.softrecipes[i][4],VarGlobales.softrecipes[i][5]) == false or VarGlobales.check_inv(VarGlobales.softrecipes[i][6],VarGlobales.softrecipes[i][7]) == false or VarGlobales.check_inv(VarGlobales.softrecipes[i][8],VarGlobales.softrecipes[i][9]) == false:
							get_node("SoftCraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1.15,1.15,1.15)
						else:
							get_node("SoftCraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
						
			#hover craft
			if get_node("SoftCraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").is_hovered():
				get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.collection[str(VarGlobales.softrecipes[i][0])][1]
				get_node("../CanvasLayer/Slot_Info").visible = true
				get_node("../CanvasLayer/Slot_Info/Description").visible = true
				if VarGlobales.check_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3]) == false:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").self_modulate = Color(1,0,0)
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").self_modulate = Color(1,1,1)
				if typeof(VarGlobales.softrecipes[i][2]) == TYPE_INT:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1").texture = load(VarGlobales.collection[str(VarGlobales.softrecipes[i][2])][0])
				if typeof(VarGlobales.softrecipes[i][2]) == TYPE_STRING:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1").texture = load(VarGlobales.tag_texture[VarGlobales.softrecipes[i][2]])
				get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").text = str(VarGlobales.softrecipes[i][3])
				if not VarGlobales.softrecipes[i][5] == 0:
					if VarGlobales.check_inv(VarGlobales.softrecipes[i][4],VarGlobales.softrecipes[i][5]) == false:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").self_modulate = Color(1,0,0)
					else:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").self_modulate = Color(1,1,1)
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2").visible = true
					if typeof(VarGlobales.softrecipes[i][4]) == TYPE_INT:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement2").texture = load(VarGlobales.collection[str(VarGlobales.softrecipes[i][4])][0])
					if typeof(VarGlobales.softrecipes[i][4]) == TYPE_STRING:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement2").texture = load(VarGlobales.tag_texture[VarGlobales.softrecipes[i][4]])
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").text = str(VarGlobales.softrecipes[i][5])
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2").visible = false	
				if not VarGlobales.softrecipes[i][7] == 0:
					if VarGlobales.check_inv(VarGlobales.softrecipes[i][6],VarGlobales.softrecipes[i][7]) == false:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement3/Number").self_modulate = Color(1,0,0)
					else:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement3/Number").self_modulate = Color(1,1,1)
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3").visible = true
					if typeof(VarGlobales.softrecipes[i][6]) == TYPE_INT:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement3").texture = load(VarGlobales.collection[str(VarGlobales.softrecipes[i][6])][0])
					if typeof(VarGlobales.softrecipes[i][6]) == TYPE_STRING:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement3").texture = load(VarGlobales.tag_texture[VarGlobales.softrecipes[i][6]])
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3/Number").text = str(VarGlobales.softrecipes[i][7])
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3").visible = false
				if not VarGlobales.softrecipes[i][9] == 0:
					if VarGlobales.check_inv(VarGlobales.softrecipes[i][8],VarGlobales.softrecipes[i][9]) == false:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement4/Number").self_modulate = Color(1,0,0)
					else:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement4/Number").self_modulate = Color(1,1,1)
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4").visible = true
					if typeof(VarGlobales.softrecipes[i][8]) == TYPE_INT:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement4").texture = load(VarGlobales.collection[str(VarGlobales.softrecipes[i][8])][0])
					if typeof(VarGlobales.softrecipes[i][8]) == TYPE_STRING:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement4").texture = load(VarGlobales.inv_texture[VarGlobales.softrecipes[i][8]])
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4/Number").text = str(VarGlobales.softrecipes[i][9])
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4").visible = false
			
			#click craft
			if get_node("../CanvasLayer").click_inv == 0 or get_node("../CanvasLayer").click_inv == 1:
				if get_node("SoftCraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").button_pressed == true:
					craft_button += 1
					if craft_button == 20:
						var softrecipes_slots = 1
						var softrecipes_slots_ok = 0
						if VarGlobales.check_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3]) == true:
							print("Slot1 ok")
							softrecipes_slots_ok = 1
							if not VarGlobales.softrecipes[i][5] == 0:
								softrecipes_slots = 2
								if VarGlobales.check_inv(VarGlobales.softrecipes[i][4],VarGlobales.softrecipes[i][5]) == true:
									print("Slot2 ok")
									softrecipes_slots_ok = 2
								if not VarGlobales.softrecipes[i][7] == 0:
									softrecipes_slots = 3
									if VarGlobales.check_inv(VarGlobales.softrecipes[i][6],VarGlobales.softrecipes[i][7]) == true:
										print("Slot3 ok")
										softrecipes_slots_ok = 3
									if not VarGlobales.softrecipes[i][9] == 0:
										softrecipes_slots = 4
										if VarGlobales.check_inv(VarGlobales.softrecipes[i][8],VarGlobales.softrecipes[i][9]) == true:
											print("Slot4 ok")
											softrecipes_slots_ok = 4
						if softrecipes_slots_ok == softrecipes_slots:
							if softrecipes_slots_ok == 1:
								if VarGlobales.check_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3]) == true:
									VarGlobales.remove_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3])
									print("craft complete1")
									get_node("../CanvasLayer").selected_inv = VarGlobales.softrecipes[i][0]
									get_node("../CanvasLayer").selected_count += VarGlobales.softrecipes[i][1]
									get_node("../CanvasLayer").click_inv = 1
									get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
									get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
									if get_node("../CanvasLayer").selected_count > 1:
										get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
									else:
										get_node("../CanvasLayer/cursor_slot/Label").text = ""
									get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
									
									
											
							if softrecipes_slots_ok == 2:
								if VarGlobales.check_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3]) == true:
									if VarGlobales.check_inv(VarGlobales.softrecipes[i][4],VarGlobales.softrecipes[i][5]) == true:
										VarGlobales.remove_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3])
										VarGlobales.remove_inv(VarGlobales.softrecipes[i][4],VarGlobales.softrecipes[i][5])
										print("craft complete2")
										get_node("../CanvasLayer").selected_inv = VarGlobales.softrecipes[i][0]
										get_node("../CanvasLayer").selected_count += VarGlobales.softrecipes[i][1]
									
										get_node("../CanvasLayer").click_inv = 1
										get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
										get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
										if get_node("../CanvasLayer").selected_count > 1:
											get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
										else:
											get_node("../CanvasLayer/cursor_slot/Label").text = ""
										get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
							if softrecipes_slots_ok == 3:
								if VarGlobales.check_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3]) == true:
									if VarGlobales.check_inv(VarGlobales.softrecipes[i][4],VarGlobales.softrecipes[i][5]) == true:
										if VarGlobales.check_inv(VarGlobales.softrecipes[i][6],VarGlobales.softrecipes[i][7]) == true:
											VarGlobales.remove_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3])
											VarGlobales.remove_inv(VarGlobales.softrecipes[i][4],VarGlobales.softrecipes[i][5])
											VarGlobales.remove_inv(VarGlobales.softrecipes[i][6],VarGlobales.softrecipes[i][7])
											print("craft complete3")
											get_node("../CanvasLayer").selected_inv = VarGlobales.softrecipes[i][0]
											get_node("../CanvasLayer").selected_count += VarGlobales.softrecipes[i][1]
										
											get_node("../CanvasLayer").click_inv = 1
											get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
											get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
											if get_node("../CanvasLayer").selected_count > 1:
												get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
											else:
												get_node("../CanvasLayer/cursor_slot/Label").text = ""
											get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
											
							if softrecipes_slots_ok == 4:
								if VarGlobales.check_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3]) == true:
									if VarGlobales.check_inv(VarGlobales.softrecipes[i][4],VarGlobales.softrecipes[i][5]) == true:
										if VarGlobales.check_inv(VarGlobales.softrecipes[i][6],VarGlobales.softrecipes[i][7]) == true:
											if VarGlobales.check_inv(VarGlobales.softrecipes[i][8],VarGlobales.softrecipes[i][9]) == true:
												VarGlobales.remove_inv(VarGlobales.softrecipes[i][2],VarGlobales.softrecipes[i][3])
												VarGlobales.remove_inv(VarGlobales.softrecipes[i][4],VarGlobales.softrecipes[i][5])
												VarGlobales.remove_inv(VarGlobales.softrecipes[i][6],VarGlobales.softrecipes[i][7])
												VarGlobales.remove_inv(VarGlobales.softrecipes[i][8],VarGlobales.softrecipes[i][9])
												print("craft complete4")
												get_node("../CanvasLayer").selected_inv = VarGlobales.softrecipes[i][0]
												get_node("../CanvasLayer").selected_count += VarGlobales.softrecipes[i][1]
										
												get_node("../CanvasLayer").click_inv = 1
												get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
												get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
												if get_node("../CanvasLayer").selected_count > 1:
													get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
												else:
													get_node("../CanvasLayer/cursor_slot/Label").text = ""
												get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
											
											
						craft_button = 0
				
	for i in VarGlobales.recipes.size():
		if get_node("CraftGUI").visible == true:
			
		##glowing gray slots
			if VarGlobales.check_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3]) == false:
				get_node("CraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(0.15,0.15,0.15)
			else:
				get_node("CraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
			if not VarGlobales.recipes[i][5] == 0:
				if VarGlobales.check_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3]) == false or VarGlobales.check_inv(VarGlobales.recipes[i][4],VarGlobales.recipes[i][5]) == false:
					get_node("CraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(0.15,0.15,0.15)
				else:
					get_node("CraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
				if not VarGlobales.recipes[i][7] == 0:
					if VarGlobales.check_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3]) == false or VarGlobales.check_inv(VarGlobales.recipes[i][4],VarGlobales.recipes[i][5]) == false or VarGlobales.check_inv(VarGlobales.recipes[i][6],VarGlobales.recipes[i][7]) == false:
						get_node("CraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(0.15,0.15,0.15)
					else:
						get_node("CraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
					if not VarGlobales.recipes[i][9] == 0:
						if VarGlobales.check_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3]) == false or VarGlobales.check_inv(VarGlobales.recipes[i][4],VarGlobales.recipes[i][5]) == false or VarGlobales.check_inv(VarGlobales.recipes[i][6],VarGlobales.recipes[i][7]) == false or VarGlobales.check_inv(VarGlobales.recipes[i][8],VarGlobales.recipes[i][9]) == false:
							get_node("CraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(0.15,0.15,0.15)
						else:
							get_node("CraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
						
			#hover craft
			if get_node("CraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").is_hovered():
				get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.collection[str(VarGlobales.recipes[i][0])][1]
				get_node("../CanvasLayer/Slot_Info").visible = true
				get_node("../CanvasLayer/Slot_Info/Description").visible = true
				if VarGlobales.check_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3]) == false:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").self_modulate = Color(1,0,0)
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").self_modulate = Color(1,1,1)
				if typeof(VarGlobales.recipes[i][2]) == TYPE_INT:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1").texture = load(VarGlobales.collection[str(VarGlobales.recipes[i][2])][0])
				if typeof(VarGlobales.recipes[i][2]) == TYPE_STRING:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1").texture = load(VarGlobales.tag_texture[VarGlobales.recipes[i][2]])
				get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").text = str(VarGlobales.recipes[i][3])
				if not VarGlobales.recipes[i][5] == 0:
					if VarGlobales.check_inv(VarGlobales.recipes[i][4],VarGlobales.recipes[i][5]) == false:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").self_modulate = Color(1,0,0)
					else:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").self_modulate = Color(1,1,1)
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2").visible = true
					if typeof(VarGlobales.recipes[i][4]) == TYPE_INT:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement2").texture = load(VarGlobales.collection[str(VarGlobales.recipes[i][4])][0])
					if typeof(VarGlobales.recipes[i][4]) == TYPE_STRING:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement2").texture = load(VarGlobales.tag_texture[VarGlobales.recipes[i][4]])
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").text = str(VarGlobales.recipes[i][5])
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2").visible = false	
				if not VarGlobales.recipes[i][7] == 0:
					if VarGlobales.check_inv(VarGlobales.recipes[i][6],VarGlobales.recipes[i][7]) == false:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement3/Number").self_modulate = Color(1,0,0)
					else:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement3/Number").self_modulate = Color(1,1,1)
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3").visible = true
					if typeof(VarGlobales.recipes[i][6]) == TYPE_INT:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement3").texture = load(VarGlobales.collection[str(VarGlobales.recipes[i][6])][0])
					if typeof(VarGlobales.recipes[i][6]) == TYPE_STRING:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement3").texture = load(VarGlobales.tag_texture[VarGlobales.recipes[i][6]])
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3/Number").text = str(VarGlobales.recipes[i][7])
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3").visible = false
				if not VarGlobales.recipes[i][9] == 0:
					if VarGlobales.check_inv(VarGlobales.recipes[i][8],VarGlobales.recipes[i][9]) == false:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement4/Number").self_modulate = Color(1,0,0)
					else:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement4/Number").self_modulate = Color(1,1,1)
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4").visible = true
					if typeof(VarGlobales.recipes[i][8]) == TYPE_INT:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement4").texture = load(VarGlobales.collection[str(VarGlobales.recipes[i][8])][0])
					if typeof(VarGlobales.recipes[i][8]) == TYPE_STRING:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement4").texture = load(VarGlobales.tag_texture[VarGlobales.recipes[i][8]])
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4/Number").text = str(VarGlobales.recipes[i][9])
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4").visible = false
			
			#click craft
			if get_node("../CanvasLayer").click_inv == 0 or get_node("../CanvasLayer").click_inv == 1:
				if get_node("CraftGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").button_pressed == true:
					craft_button += 1
					if craft_button == 20:
						var recipes_slots = 1
						var recipes_slots_ok = 0
						if VarGlobales.check_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3]) == true:
							print("Slot1 ok")
							recipes_slots_ok = 1
							if not VarGlobales.recipes[i][5] == 0:
								recipes_slots = 2
								if VarGlobales.check_inv(VarGlobales.recipes[i][4],VarGlobales.recipes[i][5]) == true:
									print("Slot2 ok")
									recipes_slots_ok = 2
								if not VarGlobales.recipes[i][7] == 0:
									recipes_slots = 3
									if VarGlobales.check_inv(VarGlobales.recipes[i][6],VarGlobales.recipes[i][7]) == true:
										print("Slot3 ok")
										recipes_slots_ok = 3
									if not VarGlobales.recipes[i][9] == 0:
										recipes_slots = 4
										if VarGlobales.check_inv(VarGlobales.recipes[i][8],VarGlobales.recipes[i][9]) == true:
											print("Slot4 ok")
											recipes_slots_ok = 4
						if recipes_slots_ok == recipes_slots:
							if recipes_slots_ok == 1:
								if VarGlobales.check_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3]) == true:
									VarGlobales.remove_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3])
									print("craft complete1")
									get_node("../CanvasLayer").selected_inv = VarGlobales.recipes[i][0]
									get_node("../CanvasLayer").selected_count += VarGlobales.recipes[i][1]
									get_node("../CanvasLayer").click_inv = 1
									get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
									get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
									if get_node("../CanvasLayer").selected_count > 1:
										get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
									else:
										get_node("../CanvasLayer/cursor_slot/Label").text = ""
									get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
									
									## Assembler 25 blocs de charbon
									if VarGlobales.recipes[i][0] == 61:
										if VarGlobales.achievements_completed[3] == 0:
											VarGlobales.achivements_value[3] += 1
									## Assembler 25 blocs de fer
									if VarGlobales.recipes[i][0] == 62:
										if VarGlobales.achievements_completed[4] == 0:
											VarGlobales.achivements_value[4] += 1
									## Assembler 25 blocs de rubis
									if VarGlobales.recipes[i][0] == 63:
										if VarGlobales.achievements_completed[5] == 0:
											VarGlobales.achivements_value[5] += 1
									## Assembler 25 blocs de saphir
									if VarGlobales.recipes[i][0] == 64:
										if VarGlobales.achievements_completed[6] == 0:
											VarGlobales.achivements_value[6] += 1
									## Assembler 25 blocs d'émeraude
									if VarGlobales.recipes[i][0] == 65:
										if VarGlobales.achievements_completed[7] == 0:
											VarGlobales.achivements_value[7] += 1
									
									
											
							if recipes_slots_ok == 2:
								if VarGlobales.check_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3]) == true:
									if VarGlobales.check_inv(VarGlobales.recipes[i][4],VarGlobales.recipes[i][5]) == true:
										VarGlobales.remove_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3])
										VarGlobales.remove_inv(VarGlobales.recipes[i][4],VarGlobales.recipes[i][5])
										print("craft complete2")
										get_node("../CanvasLayer").selected_inv = VarGlobales.recipes[i][0]
										get_node("../CanvasLayer").selected_count += VarGlobales.recipes[i][1]
									
										get_node("../CanvasLayer").click_inv = 1
										get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
										get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
										if get_node("../CanvasLayer").selected_count > 1:
											get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
										else:
											get_node("../CanvasLayer/cursor_slot/Label").text = ""
										get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
										
										## Assembler pioche en émeraude
										if VarGlobales.recipes[i][0] == 26:
											if VarGlobales.achievements_completed[9] == 0:
												VarGlobales.achivements_value[9] += 1
										## Assembler pelle en émeraude
										if VarGlobales.recipes[i][0] == 32:
											if VarGlobales.achievements_completed[10] == 0:
												VarGlobales.achivements_value[10] += 1
										## Assembler hache en émeraude
										if VarGlobales.recipes[i][0] == 38:
											if VarGlobales.achievements_completed[11] == 0:
												VarGlobales.achivements_value[11] += 1
							if recipes_slots_ok == 3:
								if VarGlobales.check_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3]) == true:
									if VarGlobales.check_inv(VarGlobales.recipes[i][4],VarGlobales.recipes[i][5]) == true:
										if VarGlobales.check_inv(VarGlobales.recipes[i][6],VarGlobales.recipes[i][7]) == true:
											VarGlobales.remove_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3])
											VarGlobales.remove_inv(VarGlobales.recipes[i][4],VarGlobales.recipes[i][5])
											VarGlobales.remove_inv(VarGlobales.recipes[i][6],VarGlobales.recipes[i][7])
											print("craft complete3")
											get_node("../CanvasLayer").selected_inv = VarGlobales.recipes[i][0]
											get_node("../CanvasLayer").selected_count += VarGlobales.recipes[i][1]
										
											get_node("../CanvasLayer").click_inv = 1
											get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
											get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
											if get_node("../CanvasLayer").selected_count > 1:
												get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
											else:
												get_node("../CanvasLayer/cursor_slot/Label").text = ""
											get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
											
							if recipes_slots_ok == 4:
								if VarGlobales.check_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3]) == true:
									if VarGlobales.check_inv(VarGlobales.recipes[i][4],VarGlobales.recipes[i][5]) == true:
										if VarGlobales.check_inv(VarGlobales.recipes[i][6],VarGlobales.recipes[i][7]) == true:
											if VarGlobales.check_inv(VarGlobales.recipes[i][8],VarGlobales.recipes[i][9]) == true:
												VarGlobales.remove_inv(VarGlobales.recipes[i][2],VarGlobales.recipes[i][3])
												VarGlobales.remove_inv(VarGlobales.recipes[i][4],VarGlobales.recipes[i][5])
												VarGlobales.remove_inv(VarGlobales.recipes[i][6],VarGlobales.recipes[i][7])
												VarGlobales.remove_inv(VarGlobales.recipes[i][8],VarGlobales.recipes[i][9])
												print("craft complete4")
												get_node("../CanvasLayer").selected_inv = VarGlobales.recipes[i][0]
												get_node("../CanvasLayer").selected_count += VarGlobales.recipes[i][1]
										
												get_node("../CanvasLayer").click_inv = 1
												get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
												get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
												if get_node("../CanvasLayer").selected_count > 1:
													get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
												else:
													get_node("../CanvasLayer/cursor_slot/Label").text = ""
												get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
												
												## Assembler pioche en émeraude
												if VarGlobales.recipes[i][0] == 72:
													if VarGlobales.achievements_completed[8] == 0:
														VarGlobales.achivements_value[8] += 1
											
											
						craft_button = 0

	for i in VarGlobales.cauldron_recipes.size():
		if get_node("CauldronGUI").visible == true:
			
		##glowing red slots
			if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][2],VarGlobales.cauldron_recipes[i][3]) == false:
				get_node("CauldronGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,0,0)
			else:
				get_node("CauldronGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
			if not VarGlobales.cauldron_recipes[i][4] == 0:
				if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][4],VarGlobales.cauldron_recipes[i][5]) == false:
					get_node("CauldronGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,0,0)
				else:
					get_node("CauldronGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
				if not VarGlobales.cauldron_recipes[i][6] == 0:
					if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][6],VarGlobales.cauldron_recipes[i][7]) == false:
						get_node("CauldronGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,0,0)
					else:
						get_node("CauldronGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
					if not VarGlobales.cauldron_recipes[i][8] == 0:
						if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][8],VarGlobales.cauldron_recipes[i][9]) == false:
							get_node("CauldronGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,0,0)
						else:
							get_node("CauldronGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
						
			#hover craft
			if get_node("CauldronGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").is_hovered():
				get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.collection[str(VarGlobales.cauldron_recipes[i][0])][1]
				get_node("../CanvasLayer/Slot_Info").visible = true
				get_node("../CanvasLayer/Slot_Info/Description").visible = true
				if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][2],VarGlobales.cauldron_recipes[i][3]) == false:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").self_modulate = Color(1,0,0)
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").self_modulate = Color(1,1,1)
				get_node("../CanvasLayer/Slot_Info/Description/Requirement1").texture = load(VarGlobales.collection[str(VarGlobales.cauldron_recipes[i][2])][0])
				get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").text = str(VarGlobales.cauldron_recipes[i][3])
				if not VarGlobales.cauldron_recipes[i][4] == 0:
					if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][4],VarGlobales.cauldron_recipes[i][5]) == false:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").self_modulate = Color(1,0,0)
					else:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").self_modulate = Color(1,1,1)
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2").visible = true
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2").texture = load(VarGlobales.collection[str(VarGlobales.cauldron_recipes[i][4])][0])
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").text = str(VarGlobales.cauldron_recipes[i][5])
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2").visible = false	
				if not VarGlobales.cauldron_recipes[i][6] == 0:
					if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][6],VarGlobales.cauldron_recipes[i][7]) == false:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement3/Number").self_modulate = Color(1,0,0)
					else:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement3/Number").self_modulate = Color(1,1,1)
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3").visible = true
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3").texture = load(VarGlobales.collection[str(VarGlobales.cauldron_recipes[i][6])][0])
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3/Number").text = str(VarGlobales.cauldron_recipes[i][7])
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3").visible = false
				if not VarGlobales.cauldron_recipes[i][8] == 0:
					if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][8],VarGlobales.cauldron_recipes[i][9]) == false:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement4/Number").self_modulate = Color(1,0,0)
					else:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement4/Number").self_modulate = Color(1,1,1)
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4").visible = true
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4").texture = load(VarGlobales.collection[str(VarGlobales.cauldron_recipes[i][8])][0])
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4/Number").text = str(VarGlobales.cauldron_recipes[i][9])
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4").visible = false
			
			#click craft
			if get_node("../CanvasLayer").click_inv == 0 or get_node("../CanvasLayer").click_inv == 1:
				if get_node("CauldronGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").button_pressed == true:
					craft_button += 1
					if craft_button == 20:
						var cauldron_recipes_slots = 1
						var cauldron_recipes_slots_ok = 0
						if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][2],VarGlobales.cauldron_recipes[i][3]) == true:
							print("Slot1 ok")
							cauldron_recipes_slots_ok = 1
							if not VarGlobales.cauldron_recipes[i][4] == 0:
								cauldron_recipes_slots = 2
								if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][4],VarGlobales.cauldron_recipes[i][5]) == true:
									print("Slot2 ok")
									cauldron_recipes_slots_ok = 2
								if not VarGlobales.cauldron_recipes[i][6] == 0:
									cauldron_recipes_slots = 3
									if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][6],VarGlobales.cauldron_recipes[i][7]) == true:
										print("Slot3 ok")
										cauldron_recipes_slots_ok = 3
									if not VarGlobales.cauldron_recipes[i][8] == 0:
										cauldron_recipes_slots = 4
										if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][8],VarGlobales.cauldron_recipes[i][9]) == true:
											print("Slot4 ok")
											cauldron_recipes_slots_ok = 4
						if cauldron_recipes_slots_ok == cauldron_recipes_slots:
							if cauldron_recipes_slots_ok == 1:
								if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][2],VarGlobales.cauldron_recipes[i][3]) == true:
									VarGlobales.remove_inv(VarGlobales.cauldron_recipes[i][2],VarGlobales.cauldron_recipes[i][3])
									print("craft complete1")
									get_node("../CanvasLayer").selected_inv = VarGlobales.cauldron_recipes[i][0]
									get_node("../CanvasLayer").selected_count += VarGlobales.cauldron_recipes[i][1]
									get_node("../CanvasLayer").click_inv = 1
									get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
									get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
									if get_node("../CanvasLayer").selected_count > 1:
										get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
									else:
										get_node("../CanvasLayer/cursor_slot/Label").text = ""
									get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
									
							if cauldron_recipes_slots_ok == 2:
								if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][2],VarGlobales.cauldron_recipes[i][3]) == true:
									if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][4],VarGlobales.cauldron_recipes[i][5]) == true:
										VarGlobales.remove_inv(VarGlobales.cauldron_recipes[i][2],VarGlobales.cauldron_recipes[i][3])
										VarGlobales.remove_inv(VarGlobales.cauldron_recipes[i][4],VarGlobales.cauldron_recipes[i][5])
										print("craft complete2")
										get_node("../CanvasLayer").selected_inv = VarGlobales.cauldron_recipes[i][0]
										get_node("../CanvasLayer").selected_count += VarGlobales.cauldron_recipes[i][1]
									
										get_node("../CanvasLayer").click_inv = 1
										get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
										get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
										if get_node("../CanvasLayer").selected_count > 1:
											get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
										else:
											get_node("../CanvasLayer/cursor_slot/Label").text = ""
										get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
										
							if cauldron_recipes_slots_ok == 3:
								if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][2],VarGlobales.cauldron_recipes[i][3]) == true:
									if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][4],VarGlobales.cauldron_recipes[i][5]) == true:
										if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][6],VarGlobales.cauldron_recipes[i][7]) == true:
											VarGlobales.remove_inv(VarGlobales.cauldron_recipes[i][2],VarGlobales.cauldron_recipes[i][3])
											VarGlobales.remove_inv(VarGlobales.cauldron_recipes[i][4],VarGlobales.cauldron_recipes[i][5])
											VarGlobales.remove_inv(VarGlobales.cauldron_recipes[i][6],VarGlobales.cauldron_recipes[i][7])
											print("craft complete3")
											get_node("../CanvasLayer").selected_inv = VarGlobales.cauldron_recipes[i][0]
											get_node("../CanvasLayer").selected_count += VarGlobales.cauldron_recipes[i][1]
										
											get_node("../CanvasLayer").click_inv = 1
											get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
											get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
											if get_node("../CanvasLayer").selected_count > 1:
												get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
											else:
												get_node("../CanvasLayer/cursor_slot/Label").text = ""
											get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
											
							if cauldron_recipes_slots_ok == 4:
								if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][2],VarGlobales.cauldron_recipes[i][3]) == true:
									if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][4],VarGlobales.cauldron_recipes[i][5]) == true:
										if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][6],VarGlobales.cauldron_recipes[i][7]) == true:
											if VarGlobales.check_inv(VarGlobales.cauldron_recipes[i][8],VarGlobales.cauldron_recipes[i][9]) == true:
												VarGlobales.remove_inv(VarGlobales.cauldron_recipes[i][2],VarGlobales.cauldron_recipes[i][3])
												VarGlobales.remove_inv(VarGlobales.cauldron_recipes[i][4],VarGlobales.cauldron_recipes[i][5])
												VarGlobales.remove_inv(VarGlobales.cauldron_recipes[i][6],VarGlobales.cauldron_recipes[i][7])
												VarGlobales.remove_inv(VarGlobales.cauldron_recipes[i][8],VarGlobales.cauldron_recipes[i][9])
												print("craft complete4")
												get_node("../CanvasLayer").selected_inv = VarGlobales.cauldron_recipes[i][0]
												get_node("../CanvasLayer").selected_count += VarGlobales.cauldron_recipes[i][1]
										
												get_node("../CanvasLayer").click_inv = 1
												get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
												get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
												if get_node("../CanvasLayer").selected_count > 1:
													get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
												else:
													get_node("../CanvasLayer/cursor_slot/Label").text = ""
												get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
											
						craft_button = 0

	for i in VarGlobales.furnace_recipes.size():
		if get_node("FurnaceGUI").visible == true:
			
		##glowing red slots
			if VarGlobales.check_inv(55,VarGlobales.furnace_recipes[i][2]) == false:
				get_node("FurnaceGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,0,0)
			else:
				get_node("FurnaceGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
			if VarGlobales.check_inv(VarGlobales.furnace_recipes[i][3],VarGlobales.furnace_recipes[i][4]) == false:
				get_node("FurnaceGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,0,0)
			else:
				get_node("FurnaceGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
						
			#hover craft
			if get_node("FurnaceGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").is_hovered():
				get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.collection[str(VarGlobales.furnace_recipes[i][0])][1]
				get_node("../CanvasLayer/Slot_Info").visible = true
				get_node("../CanvasLayer/Slot_Info/Description").visible = true
				if VarGlobales.check_inv(55,VarGlobales.furnace_recipes[i][2]) == false:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").self_modulate = Color(1,0,0)
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").self_modulate = Color(1,1,1)
				get_node("../CanvasLayer/Slot_Info/Description/Requirement1").texture = load(VarGlobales.collection[str(55)][0])
				get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").text = str(VarGlobales.furnace_recipes[i][2])
				
				if VarGlobales.check_inv(VarGlobales.furnace_recipes[i][3],VarGlobales.furnace_recipes[i][4]) == false:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").self_modulate = Color(1,0,0)
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").self_modulate = Color(1,1,1)
				get_node("../CanvasLayer/Slot_Info/Description/Requirement2").visible = true
				get_node("../CanvasLayer/Slot_Info/Description/Requirement2").texture = load(VarGlobales.collection[str(VarGlobales.furnace_recipes[i][3])][0])
				get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").text = str(VarGlobales.furnace_recipes[i][4])
			
			#click craft
			if get_node("../CanvasLayer").click_inv == 0 or get_node("../CanvasLayer").click_inv == 1:
				if get_node("FurnaceGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").button_pressed == true:
					craft_button += 1
					if craft_button == 20:
						if VarGlobales.check_inv(55,VarGlobales.furnace_recipes[i][2]) == true:
							if VarGlobales.check_inv(VarGlobales.furnace_recipes[i][3],VarGlobales.furnace_recipes[i][4]) == true:
								VarGlobales.remove_inv(55,VarGlobales.furnace_recipes[i][2])
								VarGlobales.remove_inv(VarGlobales.furnace_recipes[i][3],VarGlobales.furnace_recipes[i][4])
								get_node("../CanvasLayer").selected_inv = VarGlobales.furnace_recipes[i][0]
								get_node("../CanvasLayer").selected_count += VarGlobales.furnace_recipes[i][1]
								get_node("../CanvasLayer").click_inv = 1
								get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
								get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
								if get_node("../CanvasLayer").selected_count > 1:
									get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
								else:
									get_node("../CanvasLayer/cursor_slot/Label").text = ""
								get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
						craft_button = 0
				
	for i in VarGlobales.anvil_recipes.size():
		if get_node("AnvilGUI").visible == true:
			
		##glowing red slots
			if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][2],VarGlobales.anvil_recipes[i][3]) == false:
				get_node("AnvilGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,0,0)
			else:
				get_node("AnvilGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
			if not VarGlobales.anvil_recipes[i][4] == 0:
				if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][4],VarGlobales.anvil_recipes[i][5]) == false:
					get_node("AnvilGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,0,0)
				else:
					get_node("AnvilGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
				if not VarGlobales.anvil_recipes[i][6] == 0:
					if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][6],VarGlobales.anvil_recipes[i][7]) == false:
						get_node("AnvilGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,0,0)
					else:
						get_node("AnvilGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
					if not VarGlobales.anvil_recipes[i][8] == 0:
						if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][8],VarGlobales.anvil_recipes[i][9]) == false:
							get_node("AnvilGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,0,0)
						else:
							get_node("AnvilGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)).self_modulate = Color(1,1,1)
						
			#hover craft
			if get_node("AnvilGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").is_hovered():
				get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.collection[str(VarGlobales.anvil_recipes[i][0])][1]
				get_node("../CanvasLayer/Slot_Info").visible = true
				get_node("../CanvasLayer/Slot_Info/Description").visible = true
				if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][2],VarGlobales.anvil_recipes[i][3]) == false:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").self_modulate = Color(1,0,0)
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").self_modulate = Color(1,1,1)
				get_node("../CanvasLayer/Slot_Info/Description/Requirement1").texture = load(VarGlobales.collection[str(VarGlobales.anvil_recipes[i][2])][0])
				get_node("../CanvasLayer/Slot_Info/Description/Requirement1/Number").text = str(VarGlobales.anvil_recipes[i][3])
				if not VarGlobales.anvil_recipes[i][4] == 0:
					if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][4],VarGlobales.anvil_recipes[i][5]) == false:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").self_modulate = Color(1,0,0)
					else:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").self_modulate = Color(1,1,1)
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2").visible = true
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2").texture = load(VarGlobales.collection[str(VarGlobales.anvil_recipes[i][4])][0])
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2/Number").text = str(VarGlobales.anvil_recipes[i][5])
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement2").visible = false	
				if not VarGlobales.anvil_recipes[i][6] == 0:
					if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][6],VarGlobales.anvil_recipes[i][7]) == false:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement3/Number").self_modulate = Color(1,0,0)
					else:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement3/Number").self_modulate = Color(1,1,1)
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3").visible = true
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3").texture = load(VarGlobales.collection[str(VarGlobales.anvil_recipes[i][6])][0])
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3/Number").text = str(VarGlobales.anvil_recipes[i][7])
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement3").visible = false
				if not VarGlobales.anvil_recipes[i][8] == 0:
					if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][8],VarGlobales.anvil_recipes[i][9]) == false:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement4/Number").self_modulate = Color(1,0,0)
					else:
						get_node("../CanvasLayer/Slot_Info/Description/Requirement4/Number").self_modulate = Color(1,1,1)
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4").visible = true
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4").texture = load(VarGlobales.collection[str(VarGlobales.anvil_recipes[i][8])][0])
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4/Number").text = str(VarGlobales.anvil_recipes[i][9])
				else:
					get_node("../CanvasLayer/Slot_Info/Description/Requirement4").visible = false
			
			#click craft
			if get_node("../CanvasLayer").click_inv == 0 or get_node("../CanvasLayer").click_inv == 1:
				if get_node("AnvilGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").button_pressed == true:
					craft_button += 1
					if craft_button == 20:
						var anvil_recipes_slots = 1
						var anvil_recipes_slots_ok = 0
						if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][2],VarGlobales.anvil_recipes[i][3]) == true:
							print("Slot1 ok")
							anvil_recipes_slots_ok = 1
							if not VarGlobales.anvil_recipes[i][4] == 0:
								anvil_recipes_slots = 2
								if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][4],VarGlobales.anvil_recipes[i][5]) == true:
									print("Slot2 ok")
									anvil_recipes_slots_ok = 2
								if not VarGlobales.anvil_recipes[i][6] == 0:
									anvil_recipes_slots = 3
									if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][6],VarGlobales.anvil_recipes[i][7]) == true:
										print("Slot3 ok")
										anvil_recipes_slots_ok = 3
									if not VarGlobales.anvil_recipes[i][8] == 0:
										anvil_recipes_slots = 4
										if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][8],VarGlobales.anvil_recipes[i][9]) == true:
											print("Slot4 ok")
											anvil_recipes_slots_ok = 4
						if anvil_recipes_slots_ok == anvil_recipes_slots:
							if anvil_recipes_slots_ok == 1:
								if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][2],VarGlobales.anvil_recipes[i][3]) == true:
									VarGlobales.remove_inv(VarGlobales.anvil_recipes[i][2],VarGlobales.anvil_recipes[i][3])
									print("craft complete1")
									get_node("../CanvasLayer").selected_inv = VarGlobales.anvil_recipes[i][0]
									get_node("../CanvasLayer").selected_count += VarGlobales.anvil_recipes[i][1]
									get_node("../CanvasLayer").click_inv = 1
									get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
									get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
									if get_node("../CanvasLayer").selected_count > 1:
										get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
									else:
										get_node("../CanvasLayer/cursor_slot/Label").text = ""
									get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
									
							if anvil_recipes_slots_ok == 2:
								if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][2],VarGlobales.anvil_recipes[i][3]) == true:
									if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][4],VarGlobales.anvil_recipes[i][5]) == true:
										VarGlobales.remove_inv(VarGlobales.anvil_recipes[i][2],VarGlobales.anvil_recipes[i][3])
										VarGlobales.remove_inv(VarGlobales.anvil_recipes[i][4],VarGlobales.anvil_recipes[i][5])
										print("craft complete2")
										get_node("../CanvasLayer").selected_inv = VarGlobales.anvil_recipes[i][0]
										get_node("../CanvasLayer").selected_count += VarGlobales.anvil_recipes[i][1]
									
										get_node("../CanvasLayer").click_inv = 1
										get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
										get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
										if get_node("../CanvasLayer").selected_count > 1:
											get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
										else:
											get_node("../CanvasLayer/cursor_slot/Label").text = ""
										get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
										
										## Assembler pioche en émeraude
										if VarGlobales.anvil_recipes[i][0] == 26:
											if VarGlobales.achievements_completed[9] == 0:
												VarGlobales.achivements_value[9] += 1
										## Assembler pelle en émeraude
										if VarGlobales.anvil_recipes[i][0] == 32:
											if VarGlobales.achievements_completed[10] == 0:
												VarGlobales.achivements_value[10] += 1
										## Assembler hache en émeraude
										if VarGlobales.anvil_recipes[i][0] == 38:
											if VarGlobales.achievements_completed[11] == 0:
												VarGlobales.achivements_value[11] += 1
							if anvil_recipes_slots_ok == 3:
								if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][2],VarGlobales.anvil_recipes[i][3]) == true:
									if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][4],VarGlobales.anvil_recipes[i][5]) == true:
										if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][6],VarGlobales.anvil_recipes[i][7]) == true:
											VarGlobales.remove_inv(VarGlobales.anvil_recipes[i][2],VarGlobales.anvil_recipes[i][3])
											VarGlobales.remove_inv(VarGlobales.anvil_recipes[i][4],VarGlobales.anvil_recipes[i][5])
											VarGlobales.remove_inv(VarGlobales.anvil_recipes[i][6],VarGlobales.anvil_recipes[i][7])
											print("craft complete3")
											get_node("../CanvasLayer").selected_inv = VarGlobales.anvil_recipes[i][0]
											get_node("../CanvasLayer").selected_count += VarGlobales.anvil_recipes[i][1]
										
											get_node("../CanvasLayer").click_inv = 1
											get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
											get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
											if get_node("../CanvasLayer").selected_count > 1:
												get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
											else:
												get_node("../CanvasLayer/cursor_slot/Label").text = ""
											get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
											
							if anvil_recipes_slots_ok == 4:
								if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][2],VarGlobales.anvil_recipes[i][3]) == true:
									if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][4],VarGlobales.anvil_recipes[i][5]) == true:
										if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][6],VarGlobales.anvil_recipes[i][7]) == true:
											if VarGlobales.check_inv(VarGlobales.anvil_recipes[i][8],VarGlobales.anvil_recipes[i][9]) == true:
												VarGlobales.remove_inv(VarGlobales.anvil_recipes[i][2],VarGlobales.anvil_recipes[i][3])
												VarGlobales.remove_inv(VarGlobales.anvil_recipes[i][4],VarGlobales.anvil_recipes[i][5])
												VarGlobales.remove_inv(VarGlobales.anvil_recipes[i][6],VarGlobales.anvil_recipes[i][7])
												VarGlobales.remove_inv(VarGlobales.anvil_recipes[i][8],VarGlobales.anvil_recipes[i][9])
												print("craft complete4")
												get_node("../CanvasLayer").selected_inv = VarGlobales.anvil_recipes[i][0]
												get_node("../CanvasLayer").selected_count += VarGlobales.anvil_recipes[i][1]
										
												get_node("../CanvasLayer").click_inv = 1
												get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
												get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
												if get_node("../CanvasLayer").selected_count > 1:
													get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
												else:
													get_node("../CanvasLayer/cursor_slot/Label").text = ""
												get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
												
												## Assembler pioche en émeraude
												if VarGlobales.anvil_recipes[i][0] == 72:
													if VarGlobales.achievements_completed[8] == 0:
														VarGlobales.achivements_value[8] += 1
						craft_button = 0
		
	if VarGlobales.chisel_slot >= 0:
		var array_size = VarGlobales.chisel_recipes[check_inv_chisel_recipes(VarGlobales.chisel_slot)]
		for i in array_size.size():
			if get_node("ChiselGUI").visible == true:
				#hover craft
				if get_node_or_null("ChiselGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut") != null:
					if get_node("ChiselGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").is_hovered():
						get_node("../CanvasLayer/Slot_Info/Name").text = VarGlobales.collection[str(VarGlobales.chisel_recipes[check_inv_chisel_recipes(VarGlobales.chisel_slot)][i])][1]
						get_node("../CanvasLayer/Slot_Info").visible = true
				#click craft
				if get_node("../CanvasLayer").click_inv == 0 or get_node("../CanvasLayer").click_inv == 1:
					if get_node_or_null("ChiselGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut") != null:
						if get_node("ChiselGUI/PanelPrincipal/ScrollContainer/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").button_pressed == true:
							craft_button += 1
							if craft_button == 20:
								#print(check_inv_chisel_recipes())
								get_node("../CanvasLayer").selected_inv = VarGlobales.chisel_recipes[check_inv_chisel_recipes(VarGlobales.chisel_slot)][i]
								get_node("../CanvasLayer").selected_count += 1
								VarGlobales.chisel_slot_count -= 1
								get_node("../CanvasLayer").click_inv = 1
								get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
								get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
								if get_node("../CanvasLayer").selected_count > 1:
									get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
								else:
									get_node("../CanvasLayer/cursor_slot/Label").text = ""
								get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
								craft_button = 0
								VarGlobales.achivements_value[21] += 1

	if get_node("Chat").visible == false and get_node("SignGUI").visible == false:
		if VarGlobales.inGUI >= 1:
				if Input.is_action_just_pressed("ui_e") or Input.is_action_just_pressed("ui_i"):
					VarGlobales.inGUI = 0
					stats_visible = 0
					get_node("CheatGUI").visible = false
					get_node("CraftGUI").visible = false
					get_node("SoftCraftGUI").visible = false
					get_node("InventoryGUI").visible = false
					get_node("PauseGUI").visible = false
					get_node("BackPackGUI").visible = false
					get_node("ChestGUI").visible = false
					get_node("FurnaceGUI").visible = false
					get_node("AnvilGUI").visible = false
					get_node("ChiselGUI").visible = false
					get_node("CauldronGUI").visible = false
					get_node("StatsGUI").visible = false
					get_node("SignGUI").visible = false
		else:
			if Input.is_action_just_pressed("ui_i"):
				if get_node("InventoryGUI").visible == false:
					get_node("InventoryGUI").visible = true
					VarGlobales.inGUI += 1
				
			if VarGlobales.WorldMode == 0:
				if Input.is_action_just_pressed("ui_e"):
					if chat_focus == 0:
						if get_node("SoftCraftGUI").visible == false:
							get_node("SoftCraftGUI").visible = true
							VarGlobales.inGUI += 1
						else:
							get_node("SoftCraftGUI").visible = false
							VarGlobales.inGUI -= 1
							
			if VarGlobales.WorldMode == 1:
				if Input.is_action_just_pressed("ui_e"):
					if chat_focus == 0:
						if get_node("CheatGUI").visible == false:
							get_node("CheatGUI").visible = true
							VarGlobales.inGUI += 1
						else:
							get_node("CheatGUI").visible = false
							VarGlobales.inGUI -= 1
						
		
				
					
	for i in check_block():
		if get_node("CheatGUI").visible == true:
			if not get_node("../CanvasLayer").click_inv == 1:
				if get_node("CheatGUI/PanelPrincipal/Blocks/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").button_pressed:
					print("a")
					get_node("../CanvasLayer").selected_inv = VarGlobales.cat_blocks[i]
					get_node("../CanvasLayer").selected_count = 1
					get_node("../CanvasLayer").click_inv = 1
					get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
					get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
					if get_node("../CanvasLayer").selected_count > 1:
						get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
					else:
						get_node("../CanvasLayer/cursor_slot/Label").text = ""
					get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
					i
	for i in check_items():
		if get_node("CheatGUI").visible == true:
			if not get_node("../CanvasLayer").click_inv == 1:
				if get_node("CheatGUI/PanelPrincipal/Items/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").button_pressed:
					get_node("../CanvasLayer").selected_inv = VarGlobales.cat_items[i]
					get_node("../CanvasLayer").selected_count = 1
					get_node("../CanvasLayer").click_inv = 1
					get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
					get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
					if get_node("../CanvasLayer").selected_count > 1:
						get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
					else:
						get_node("../CanvasLayer/cursor_slot/Label").text = ""
					get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
					
	for i in VarGlobales.cat_all.size():
		if get_node("CheatGUI").visible == true:
			if not get_node("../CanvasLayer").click_inv == 1:
				if get_node("CheatGUI/PanelPrincipal/All/VBoxContainer/Slot"+str(i)+"/Image/ImageBut").button_pressed:
					get_node("../CanvasLayer").selected_inv = VarGlobales.cat_all[i]
					get_node("../CanvasLayer").selected_count = 1
					get_node("../CanvasLayer").click_inv = 1
					get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(get_node("../CanvasLayer").selected_inv)][0])
					get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
					if get_node("../CanvasLayer").selected_count > 1:
						get_node("../CanvasLayer/cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
					else:
						get_node("../CanvasLayer/cursor_slot/Label").text = ""
					get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75

	if not VarGlobales.armor_slot[0] == -1:
		get_node("InventoryGUI/test/armor_jetpack/item").texture = load(VarGlobales.inv_texture[VarGlobales.armor_slot[0]])
	else:
		get_node("InventoryGUI/test/armor_jetpack/item").texture = null
	
	if get_node("BackPackGUI").visible == true:
		if VarGlobales.backpack_numbers >= 1:
			for i in range(1,9):
				if not VarGlobales.backpack_slots[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i-1] == -1:
					get_node("BackPackGUI/test/backpack"+str(i)+"/item").texture = load(VarGlobales.collection[str(VarGlobales.backpack_slots[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i-1])][0])
					get_node("BackPackGUI/test/backpack"+str(i)+"/Label").text = str(VarGlobales.backpack_slots_count[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i-1])
				else:
					get_node("BackPackGUI/test/backpack"+str(i)+"/item").texture = null
					get_node("BackPackGUI/test/backpack"+str(i)+"/Label").text = ""
					
	if get_node("ChiselGUI").visible == true:
		if VarGlobales.inGUI > 0:
			if VarGlobales.chisel_slot != -1:
				get_node("ChiselGUI/PanelPrincipal/chisel_slot/item").texture = load(VarGlobales.collection[str(VarGlobales.chisel_slot)][0])
				get_node("ChiselGUI/PanelPrincipal/chisel_slot/Label").text = str(VarGlobales.chisel_slot_count)
			else:
				get_node("ChiselGUI/PanelPrincipal/chisel_slot/item").texture = null
				get_node("ChiselGUI/PanelPrincipal/chisel_slot/Label").text = ""
			if VarGlobales.chisel_slot_count > 0:
				get_node("ChiselGUI/PanelPrincipal/chisel_slot/item").texture = load(VarGlobales.collection[str(VarGlobales.chisel_slot)][0])
				get_node("ChiselGUI/PanelPrincipal/chisel_slot/Label").text = str(VarGlobales.chisel_slot_count)
			else:
				get_node("ChiselGUI/PanelPrincipal/chisel_slot/item").texture = null
				get_node("ChiselGUI/PanelPrincipal/chisel_slot/Label").text = ""
				VarGlobales.chisel_slot = -1
				unshow_chisel_recipes()

func check_inv_chisel_recipes(id):
	for i in VarGlobales.chisel_recipes.size():
		if VarGlobales.chisel_recipes[i][0] == id:
			return i
	return -1

func _on_Respawn_pressed():
	print("Respawn pressed")
	VarGlobales.death = 0
	get_node("../CanvasLayer_GUI/DeadGUI").visible = false
	for i in range(1,9):
		get_node("../CanvasLayer/inv_slot"+str(i)).visible = true
		get_node("../CanvasLayer/NameItem").visible = true
		get_node("../CanvasLayer/InfoLabel").visible = true
		get_node("../StatsPlayer/HealthBar").visible = true
		get_node("../StatsPlayer/FoodBar").visible = true
		get_node("../StatsPlayer/SaturationBar").visible = true
	print(str(VarGlobales.health)+" / "+str(VarGlobales.food))
	get_node("../CharacterBody2D").position = VarGlobales.spawnpoint*32
	VarGlobales.inGUI = 0
	pass # Replace with function body.

func _on_Button_jetpack_pressed():
	if get_node("../CanvasLayer").selected_inv == 70:
		if get_node("../CanvasLayer").click_inv == 1:
			if VarGlobales.armor_slot[0] == get_node("../CanvasLayer").selected_inv:
				VarGlobales.armor_slot_count[0] = VarGlobales.armor_slot_count[7] + get_node("../CanvasLayer").selected_count
				get_node("../CanvasLayer").selected_count = 0
				get_node("../CanvasLayer/cursor_slot/item").texture = null
				get_node("../CanvasLayer/cursor_slot/Label").text = ""
				get_node("../CanvasLayer").click_inv = 2
			elif VarGlobales.armor_slot[0] == -1:
				VarGlobales.armor_slot[0] = get_node("../CanvasLayer").selected_inv
				VarGlobales.armor_slot_count[0] = get_node("../CanvasLayer").selected_count
				VarGlobales.armor_slot_tag[0] = get_node("../CanvasLayer").selected_tag
				get_node("../CanvasLayer").selected_count = 0
				get_node("../CanvasLayer/cursor_slot/item").texture = null
				get_node("../CanvasLayer/cursor_slot/Label").text = ""
				get_node("../CanvasLayer").click_inv = 2
				
		if get_node("../CanvasLayer").click_inv == 0:
			if get_node("../CanvasLayer/cursor_slot/Label").text != null and VarGlobales.armor_slot[0] != -1:
				get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(VarGlobales.armor_slot[0])][0])
				get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
				if VarGlobales.armor_slot_count[0] > 1:
					get_node("../CanvasLayer/cursor_slot/Label").text = str(VarGlobales.armor_slot_count[0])
				else:
					get_node("../CanvasLayer/cursor_slot/Label").text = ""
				get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
				get_node("../CanvasLayer").selected_inv = VarGlobales.armor_slot[0]
				get_node("../CanvasLayer").selected_count = VarGlobales.armor_slot_count[0]
				get_node("../CanvasLayer").selected_tag = VarGlobales.armor_slot_tag[0]
				VarGlobales.armor_slot[0] = -1
				VarGlobales.armor_slot_count[0] = 0
				VarGlobales.armor_slot_tag[0] = -1
				
				get_node("../CanvasLayer").click_inv = 1
	pass # Replace with function body.

func _on_Back_pressed():
	get_node("StatsGUI").visible = false
	var array_stats = get_node("StatsGUI/ScrollContainer/VBoxContainer").get_children()
	for i in array_stats.size():
		array_stats[i].queue_free()
	get_node("PauseGUI").visible = true
	stats_visible = 0
	pass # Replace with function body.

func _on_Stats_But_pressed():
	get_node("StatsGUI").visible = true
	get_node("PauseGUI").visible = false
	get_node("../CanvasLayer/CheckButton").visible = false
	stats_visible = 0

func _on_Button1_backpack_pressed():
	button_backpack(0)
	pass # Replace with function body.

func _on_Button2_backpack_pressed():
	button_backpack(1)
	pass # Replace with function body.

func _on_Button3_backpack_pressed():
	button_backpack(2)
	pass # Replace with function body.

func _on_Button4_backpack_pressed():
	button_backpack(3)
	pass # Replace with function body.

func _on_Button5_backpack_pressed():
	button_backpack(4)
	pass # Replace with function body.

func _on_Button6_backpack_pressed():
	button_backpack(5)
	pass # Replace with function body.

func _on_Button7_backpack_pressed():
	button_backpack(6)
	pass # Replace with function body.

func _on_Button8_backpack_pressed():
	button_backpack(7)
	pass # Replace with function body.

func button_backpack(i):
	if get_node("../CanvasLayer").click_inv == 1:
		if get_node("../CanvasLayer").selected_inv != 77:
			if VarGlobales.backpack_slots[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i] == get_node("../CanvasLayer").selected_inv:
				VarGlobales.backpack_slots_count[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i] = VarGlobales.backpack_slots_count[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i] + get_node("../CanvasLayer").selected_count
				VarGlobales.backpack_slots_tag[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i] = get_node("../CanvasLayer").selected_tag
				get_node("../CanvasLayer").selected_count = 0
				get_node("../CanvasLayer").selected_tag = -1
				get_node("../CanvasLayer/cursor_slot/item").texture = null
				get_node("../CanvasLayer/cursor_slot/Label").text = ""
				get_node("../CanvasLayer").click_inv = 2
			elif VarGlobales.backpack_slots[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i] == -1:
				VarGlobales.backpack_slots[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i] = get_node("../CanvasLayer").selected_inv
				VarGlobales.backpack_slots_count[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i] = get_node("../CanvasLayer").selected_count
				VarGlobales.backpack_slots_tag[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i] = get_node("../CanvasLayer").selected_tag
				get_node("../CanvasLayer").selected_count = 0
				get_node("../CanvasLayer").selected_tag = -1
				get_node("../CanvasLayer/cursor_slot/item").texture = null
				get_node("../CanvasLayer/cursor_slot/Label").text = ""
				get_node("../CanvasLayer").click_inv = 2
	if get_node("../CanvasLayer").click_inv == 0:
		if get_node("../CanvasLayer/cursor_slot/Label").text != null and VarGlobales.backpack_slots[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i]!= -1:
			get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.collection[str(VarGlobales.backpack_slots[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i])][0])
			get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
			if VarGlobales.backpack_slots_count[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i] > 1:
				get_node("../CanvasLayer/cursor_slot/Label").text = str(VarGlobales.backpack_slots_count[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i])
			else:
				get_node("../CanvasLayer/cursor_slot/Label").text = ""
			get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
			get_node("../CanvasLayer").selected_inv = VarGlobales.backpack_slots[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i]
			get_node("../CanvasLayer").selected_count = VarGlobales.backpack_slots_count[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i]
			get_node("../CanvasLayer").selected_tag = VarGlobales.backpack_slots_tag[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i]
			VarGlobales.backpack_slots[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i] = -1
			VarGlobales.backpack_slots_count[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i] = 0
			VarGlobales.backpack_slots_tag[int(str(VarGlobales.inv_slot_tag[VarGlobales.slot_selected-1]).replace("backpack",""))][i] = -1
			get_node("../CanvasLayer").click_inv = 1

func _on_Blocks_Button_pressed():
	get_node("CheatGUI/PanelPrincipal/All").visible = false
	get_node("CheatGUI/PanelPrincipal/Blocks").visible = true
	get_node("CheatGUI/PanelPrincipal/Items").visible = false

func _on_Items_Button_pressed():
	get_node("CheatGUI/PanelPrincipal/All").visible = false
	get_node("CheatGUI/PanelPrincipal/Blocks").visible = false
	get_node("CheatGUI/PanelPrincipal/Items").visible = true
	

func _on_Button_chisel_pressed():
	VarGlobales.click_slot = 0
	if get_node("../CanvasLayer").click_inv == 1:
		if check_inv_chisel_recipes(get_node("../CanvasLayer").selected_inv) >= 0:
			if VarGlobales.chisel_slot == get_node("../CanvasLayer").selected_inv:
				VarGlobales.chisel_slot_count = VarGlobales.chisel_slot_count + get_node("../CanvasLayer").selected_count
				unshow_chisel_recipes()
				show_chisel_recipes(get_node("../CanvasLayer").selected_inv)
				get_node("../CanvasLayer").click_inv = 2
				get_node("../CanvasLayer/cursor_slot/item").texture = null
				get_node("../CanvasLayer/cursor_slot/Label").text = ""
				get_node("../CanvasLayer").selected_count = 0
				get_node("../CanvasLayer").selected_inv = 0
				get_node("../CanvasLayer").selected_tag = -1
			elif VarGlobales.chisel_slot == -1:
				VarGlobales.chisel_slot = get_node("../CanvasLayer").selected_inv
				VarGlobales.chisel_slot_count = get_node("../CanvasLayer").selected_count
				VarGlobales.chisel_slot_tag = get_node("../CanvasLayer").selected_tag
				unshow_chisel_recipes()
				show_chisel_recipes(get_node("../CanvasLayer").selected_inv)
				get_node("../CanvasLayer").click_inv = 2
				get_node("../CanvasLayer/cursor_slot/item").texture = null
				get_node("../CanvasLayer/cursor_slot/Label").text = ""
				get_node("../CanvasLayer").selected_count = 0
				get_node("../CanvasLayer").selected_inv = 0
				get_node("../CanvasLayer").selected_tag = -1
			elif VarGlobales.chisel_slot != -1:
				var temp_slot = VarGlobales.chisel_slot
				var temp_count = VarGlobales.chisel_slot_count
				var temp_tag = VarGlobales.chisel_slot_tag
				VarGlobales.chisel_slot = get_node("../CanvasLayer").selected_inv
				VarGlobales.chisel_slot_count = get_node("../CanvasLayer").selected_count
				VarGlobales.chisel_slot_tag = get_node("../CanvasLayer").selected_tag
				unshow_chisel_recipes()
				show_chisel_recipes(VarGlobales.chisel_slot)
				get_node("../CanvasLayer").selected_count = temp_count
				get_node("../CanvasLayer").selected_inv = temp_slot
				get_node("../CanvasLayer").selected_tag = temp_tag
				get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.inv_texture[get_node("../CanvasLayer").selected_inv])
				get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
				if VarGlobales.chisel_slot_count > 1:
					get_node("cursor_slot/Label").text = str(get_node("../CanvasLayer").selected_count)
				else:
					get_node("../CanvasLayer/cursor_slot/Label").text = ""
				get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
				get_node("../CanvasLayer").click_inv = 1
		
	if get_node("../CanvasLayer").click_inv == 0:
		if get_node("../CanvasLayer_GUI/BackPackGUI").visible == true:
			if VarGlobales.chisel_slot != 77:
				if get_node("../CanvasLayer/cursor_slot/Label").text != null and VarGlobales.chisel_slot != -1:
					get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.inv_texture[VarGlobales.chisel_slot])
					get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
					if VarGlobales.chisel_slot_count > 1:
						get_node("../CanvasLayer/cursor_slot/Label").text = str(VarGlobales.chisel_slot_count)
					else:
						get_node("../CanvasLayer/cursor_slot/Label").text = ""
					get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
					get_node("../CanvasLayer").selected_inv = VarGlobales.chisel_slot
					get_node("../CanvasLayer").selected_count = VarGlobales.chisel_slot_count
					get_node("../CanvasLayer").selected_tag = VarGlobales.chisel_slot_tag
					VarGlobales.chisel_slot = -1
					VarGlobales.chisel_slot_count = 0
					VarGlobales.chisel_slot_tag = -1
					get_node("../CanvasLayer").click_inv = 1
		else:
			if get_node("../CanvasLayer/cursor_slot/Label").text != null and VarGlobales.chisel_slot != -1:
				get_node("../CanvasLayer/cursor_slot/item").texture = load(VarGlobales.inv_texture[VarGlobales.chisel_slot])
				get_node("../CanvasLayer/cursor_slot/item").modulate.a = 0.75
				unshow_chisel_recipes()
				if VarGlobales.chisel_slot_count > 1:
					get_node("../CanvasLayer/cursor_slot/Label").text = str(VarGlobales.chisel_slot_count)
				else:
					get_node("../CanvasLayer/cursor_slot/Label").text = ""
				get_node("../CanvasLayer/cursor_slot/Label").modulate.a = 0.75
				get_node("../CanvasLayer").selected_inv = VarGlobales.chisel_slot
				get_node("../CanvasLayer").selected_count = VarGlobales.chisel_slot_count
				get_node("../CanvasLayer").selected_tag = VarGlobales.chisel_slot_tag
				VarGlobales.chisel_slot = -1
				VarGlobales.chisel_slot_count = 0
				VarGlobales.chisel_slot_tag = -1
				get_node("../CanvasLayer").click_inv = 1
	pass # Replace with function body.


func _on_Continue_But_pressed():
	get_node("PauseGUI").visible = false
	VarGlobales.inGUI = 0
	for i in range(1,9):
		get_node("../CanvasLayer/inv_slot"+str(i)).visible = true
	get_node("../CanvasLayer/NameItem").visible = true
	MusicController.play_select_sound()

func _on_Save_But_pressed():
	VarGlobales.save()
	get_node("PauseGUI").visible = false
	VarGlobales.inGUI = 0
	MusicController.play_select_sound()
	for i in range(1,9):
		get_node("../CanvasLayer/inv_slot"+str(i)).visible = true
	get_node("../CanvasLayer/NameItem").visible = true

func _on_Quit_But_pressed():
	var childs = get_node("/root/PersistentNodes").get_children()
	for i in range(0,childs.size()):
		print(childs[i])
		childs[i].queue_free()
	get_tree().change_scene_to_file("res://Scènes/Menu.tscn")
	MusicController.play_select_sound()
	MusicController.play_title_music()
	


func _on_Chat_mouse_entered():
	chat_hover = 1
	pass # Replace with function body.


func _on_Chat_mouse_exited():
	chat_hover = 0
	pass # Replace with function body.


func _on_Chat_focus_entered():
	chat_focus = 1
	pass # Replace with function body.


func _on_Chat_focus_exited():
	chat_focus = 0
	pass # Replace with function body.


func _on_All_Button_pressed():
	get_node("CheatGUI/PanelPrincipal/All").visible = true
	get_node("CheatGUI/PanelPrincipal/Blocks").visible = false
	get_node("CheatGUI/PanelPrincipal/Items").visible = false
	get_node("CheatGUI/PanelPrincipal/Blocks").scroll_vertical = 0


func _on_Mobile_Inventory_pressed():
	if OS.get_name() == "Android":
		VarGlobales.inGUI += 1
		get_node("CheatGUI").visible = false
		get_node("SoftCraftGUI").visible = false
		get_node("CraftGUI").visible = false
		get_node("BackPackGUI").visible = false
		get_node("ChestGUI").visible = false
		get_node("FurnaceGUI").visible = false
		get_node("AnvilGUI").visible = false
		get_node("ChiselGUI").visible = false
		get_node("CauldronGUI").visible = false


func _on_TextEdit_text_changed():
	VarGlobales.blocks_nbt[VarGlobales.block_in][1] = get_node("SignGUI/TextEdit").text
	if get_node("SignGUI/TextEdit").text.length() > 7*30-1:
		var new_text = get_node("SignGUI/TextEdit").text
		new_text.erase(new_text.length() - 1 , 1)
		get_node("SignGUI/TextEdit").text = new_text
