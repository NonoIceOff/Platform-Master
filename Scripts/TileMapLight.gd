extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if VarGlobales.inGUI < 1:
		var player_pos = get_node("../CharacterBody2D").position/32
		for i in range(player_pos.x-20,player_pos.x+20):
			for j in range(player_pos.x-10,player_pos.x+10):
				self.set_cell(i,j,5)
				
	pass
