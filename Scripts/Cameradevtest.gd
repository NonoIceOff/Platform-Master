extends Camera2D

var cam_speed = 100

func _ready():
	self.zoom = Vector2(.25,.25)
	self.position.y = 32*25

func _process(_delta):
	if Input.is_action_pressed("ui_up"):
		translate(Vector2(0,-cam_speed))
	if Input.is_action_pressed("ui_down"):
		translate(Vector2(0,cam_speed))
	if Input.is_action_pressed("ui_right"):
		translate(Vector2(cam_speed,0))
	if Input.is_action_pressed("ui_left"):
		translate(Vector2(-cam_speed,0))
			
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			self.zoom *= Vector2(1.05,1.05)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			self.zoom /= Vector2(1.05,1.05)


func _on_SpinBox_value_changed(value):
	cam_speed = value
