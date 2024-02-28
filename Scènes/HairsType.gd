extends Label

var shapes = 4

func _ready():
	for i in range(1,shapes+1):
		var ShapeButton = Button.new()
		ShapeButton.size = Vector2(24,24)
		ShapeButton.position = Vector2(32*(i-1),14)
		ShapeButton.name = "ShapeButton"+str(i)
		ShapeButton.expand_icon = true
		ShapeButton.icon = load("res://Textures/Personnage/Hairs/"+str(i)+"/0.png")
		ShapeButton.flat = true
		ShapeButton.focus_mode = Control.FOCUS_NONE
		add_child(ShapeButton)


func _process(delta):
	for i in range(1,shapes+1):
		if get_node_or_null("ShapeButton"+str(i)) != null:
			if get_node("ShapeButton"+str(i)).pressed:
				if Input.is_action_just_pressed("mouse_breakblock"):
					get_node("../Player/Hair").animation = "Hair"+str(i)
					VarGlobales.skin_hair_style = i
