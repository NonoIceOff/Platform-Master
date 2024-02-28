extends AudioStreamPlayer2D

func _process(_delta):
	volume_db = VarGlobales.player_volume

func play_mob_hit_sound():
	stream = load("res://Sounds/hit.mp3")
	pitch_scale = randf_range(0.75,1.25)
	play()
	
func play_mob_dead_sound():
	stream = load("res://Sounds/dead.mp3")
	pitch_scale = randf_range(0.75,1.25)
	play()
	
func play_boss_spawn():
	stream = load("res://Sounds/spawn_boss.wav")
	pitch_scale = randf_range(0.75,1.25)
	play()
