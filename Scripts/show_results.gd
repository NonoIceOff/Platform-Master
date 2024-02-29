extends Panel

var tick = 60
var secs = 0
var item_result = 0

func _ready():
	secs = int(get_node("Seconds").text)
	get_node("ProgressBar").max_value = secs
	

func _process(delta):
	secs = int(get_node("Seconds").text)
	tick -= 1
	if tick == 0:
		get_node("ProgressBar").value = secs
		tick = 60
		secs -= 1
		get_node("Seconds").text = str(secs)
	if secs == 0:
		var valeurASupprimer = VarGlobales.block_in
		if VarGlobales.blocks_nbt.has(valeurASupprimer):
			VarGlobales.blocks_nbt.erase(valeurASupprimer)

		VarGlobales.spawn_item(position,item_result,1)
		queue_free()
	
