extends Camera2D

var cam_speed = 10

func _ready():
	set_process(true)

func _process(_delta):
	offset = Vector2(-128,128)+Vector2(get_local_mouse_position().x,get_local_mouse_position().y)/75
	if VarGlobales.WorldMode == 2:
		if Input.is_action_pressed("ui_up"):
			translate(Vector2(0,-cam_speed))
		if Input.is_action_pressed("ui_down"):
			translate(Vector2(0,cam_speed))
		if Input.is_action_pressed("ui_right"):
			translate(Vector2(cam_speed,0))
		if Input.is_action_pressed("ui_left"):
			translate(Vector2(-cam_speed,0))
			
func _input(event):
	if VarGlobales.WorldMode == 2:
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				self.zoom /= Vector2(1.05,1.05)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				self.zoom *= Vector2(1.05,1.05)


func _on_SpinBox_value_changed(value):
	cam_speed = value
