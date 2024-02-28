extends Node

func _process(_delta):
	MusicController.get_node("Music").volume_db = VarGlobales.music_volume
	MusicController.get_node("Effects").volume_db = VarGlobales.effects_volume
	MusicController.get_node("Player").volume_db = VarGlobales.player_volume
	MusicController.get_node("Blocks").volume_db = VarGlobales.blocks_volume
	##Si le son est trop fort
	if $Music.volume_db > 0:
		$Music.volume_db = -10
	if $Effects.volume_db > 0:
		$Effects.volume_db = -10
	if $Player.volume_db > 0:
		$Player.volume_db = -10
	if $Blocks.volume_db > 0:
		$Blocks.volume_db = -10


func play_title_music():
	var sec_pos = $Music.get_playback_position()
	$Music.stream_paused = false
	$Music.stream = load("res://Sounds/TitleMusic.mp3")
	$Music.play(sec_pos)
	
func play_achievement_music():
	$Effects.stream_paused = false
	$Effects.stream = load("res://Sounds/powerUp.wav")
	$Effects.play()
	
func play_select_sound():
	$Effects.stream = load("res://Sounds/Select.mp3")
	$Effects.pitch_scale = randf_range(0.75,1.25)
	$Effects.play()
	
func play_select_up_sound():
	$Effects.stream = load("res://Sounds/up_music.mp3")
	$Effects.pitch_scale = randf_range(0.75,1.25)
	$Effects.play()
	
func play_select_down_sound():
	$Effects.stream = load("res://Sounds/down_music.mp3")
	$Effects.pitch_scale = randf_range(0.75,1.25)
	$Effects.play()
	
func play_init_sound():
	$Effects.stream = load("res://Sounds/Init.mp3")
	$Effects.pitch_scale = randf_range(0.75,1.25)
	$Effects.play()
	
func play_jump_sound():
	$Player.stream = load("res://Sounds/Jump.mp3")
	$Player.pitch_scale = randf_range(0.75,1.25)
	$Player.play()
	
func play_spawn_sound():
	$Player.stream = load("res://Sounds/Init.mp3")
	$Player.pitch_scale = randf_range(0.75,1.25)
	$Player.play()
	
func play_player_hit_sound():
	$Player.stream = load("res://Sounds/hit.mp3")
	$Player.pitch_scale = randf_range(0.75,1.25)
	$Player.play()
	
func play_player_dead_sound():
	$Player.stream = load("res://Sounds/dead.mp3")
	$Player.pitch_scale = randf_range(0.75,1.25)
	$Player.play()

func play_boss_spawn():
	$Player.stream = load("res://Sounds/spawn_boss.wav")
	$Player.pitch_scale = randf_range(0.75,1.25)
	$Player.play()
	
func play_block_breaking_sound():
	$Blocks.stream = load("res://Sounds/breaking.mp3")
	$Blocks.pitch_scale = randf_range(0.75,1.25)
	$Blocks.play()
	
func play_block_breaked_sound():
	$Blocks.stream = load("res://Sounds/breaked.mp3")
	$Blocks.pitch_scale = randf_range(0.75,1.25)
	$Blocks.play()
