extends CharacterBody2D

var item = preload("res://Scènes/Item.tscn")
var mob = preload("res://Scènes/Mob.tscn")

var SPEED = 3
var PSPEED = 3
var GRAVITY = 9.8*2
var JUMP_POWER = -300
var FLOOR = Vector2(0,-1)
var on_ground = false
var rng = RandomNumberGenerator.new()
var blocs_reached = 0

var y_fall_start = 0
var y_fall_end = 0
var in_fall = false
var mouse = 0
var pos_x = get_position().x
var pos_y = get_position().y

var item_use = 0
var item_use_i = 0
var item_use_i_max = 0

func _ready():
	rng.randomize()

func get_cell(a,b,node):
	return get_node(node).get_cell_source_id(0,Vector2(a,b),false)
	
func _process(_delta):
	if get_node("../").position.x-position.x < 300 and get_node("../").position.x-position.x > 900:
		PSPEED = 5
	else:
		PSPEED = 10
		
	pos_x = abs(get_node("../BackgroundMap").position.x)-position.x
	pos_y = get_node("../BackgroundMap").position.y-position.y
	var pose_x = floor(get_global_mouse_position().x/32)
	var pose_y = floor(get_global_mouse_position().y/32)
	
	if on_ground == true:
		if get_cell(position.x/32+1,position.y/32+1,"../BackgroundMap") == -1:
			velocity.y = JUMP_POWER

func _physics_process(_delta):
	velocity.x = PSPEED
	get_node("../BackgroundMap").position.x -= SPEED
	get_node("../BackgroundMapLights").position.x -= SPEED
	velocity.y = velocity.y + GRAVITY
	set_velocity(velocity)
	set_up_direction(FLOOR)
	move_and_slide()
	velocity = velocity
		
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
