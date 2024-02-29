extends Sprite2D

## 0 = hotbar // 1 = backpack // 2 = chest // 
var id = 0
var number = 0

func _on_Button_pressed():
	if id == 0:
		if get_node_or_null("../../CanvasLayer") != null:
			get_node_or_null("../../CanvasLayer").button_inv(number)
