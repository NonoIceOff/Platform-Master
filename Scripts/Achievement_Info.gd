extends ColorRect

var new_achievement = 0
var launch = 0
var ticks = 500
var pos = -500


func easeInCubic(x):
	return lerpf(x, pos+516, 0.05)
	
func easeOutCubic(x):
	return lerpf(x, pos-200, 0.05)


func _process(delta):
	if new_achievement == 1:
		launch = 1
		new_achievement = 0
		MusicController.play_achievement_music()
		
	if launch == 0:
		position.x = easeOutCubic(position.x)
	else:
		position.x = easeInCubic(position.x)
		ticks -= 1
		if ticks == 0:
			launch = 0
			ticks = 500
