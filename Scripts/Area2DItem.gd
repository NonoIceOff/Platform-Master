extends Area2D

var player_id = 0

func get_id():
	for key in VarGlobales.collection:
		if VarGlobales.collection[str(key)][0] == get_node("../Sprite2D").texture.resource_path:
			return int(key)

func destroy_item(id):
	VarGlobales.inv_slot[id] = get_id()
	VarGlobales.inv_slot_count[id] += get_node("../").count
	if typeof(get_node("../").tag) == TYPE_INT:
		VarGlobales.inv_slot_tag[id] = get_node("../").tag
	else:
		VarGlobales.inv_slot_tag[id] = str(get_node("../").tag)
	VarGlobales.items_number -= get_node("../").count
	get_parent().queue_free()

func _on_Area2D_body_entered(body):
	if VarGlobales.WorldState == 2 and VarGlobales.death == 0:
		if body.is_in_group("Player") == true:
			if VarGlobales.inv_slot[0] == -1 or VarGlobales.inv_slot[0] == get_id():
				destroy_item(0)
			elif VarGlobales.inv_slot[1] == -1 or VarGlobales.inv_slot[1] == get_id():
				destroy_item(1)
			elif VarGlobales.inv_slot[2] == -1 or VarGlobales.inv_slot[2] == get_id():
				destroy_item(2)
			elif VarGlobales.inv_slot[3] == -1 or VarGlobales.inv_slot[3] == get_id():
				destroy_item(3)
			elif VarGlobales.inv_slot[4] == -1 or VarGlobales.inv_slot[4] == get_id():
				destroy_item(4)
			elif VarGlobales.inv_slot[5] == -1 or VarGlobales.inv_slot[5] == get_id():
				destroy_item(5)
			elif VarGlobales.inv_slot[6] == -1 or VarGlobales.inv_slot[6] == get_id():
				destroy_item(6)
			elif VarGlobales.inv_slot[7] == -1 or VarGlobales.inv_slot[7] == get_id():
				destroy_item(7)
			VarGlobales.stats_value[5] += 1
