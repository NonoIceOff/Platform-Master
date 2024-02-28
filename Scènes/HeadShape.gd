extends Label

var shapes = 3

func _ready():
	for i in range(1,shapes+1):
		var ShapeButton = Button.new()
		ShapeButton.size = Vector2(24,24)
		ShapeButton.position = Vector2(32*(i-1),14)
		ShapeButton.name = "ShapeButton"+str(i)
		ShapeButton.expand_icon = true
		ShapeButton.icon = load("res://Textures/Personnage/Heads/"+str(i)+".png")
		ShapeButton.flat = true
		ShapeButton.focus_mode = Control.FOCUS_NONE
		add_child(ShapeButton)


func _process(delta):
	for i in range(1,shapes+1):
		if get_node_or_null("ShapeButton"+str(i)) != null:
			if get_node("ShapeButton"+str(i)).pressed:
				if Input.is_action_just_pressed("mouse_breakblock"):
					get_node("../Player/Head").texture = load("res://Textures/Personnage/Heads/"+str(i)+".png")
					VarGlobales.skin_head_shape = i
