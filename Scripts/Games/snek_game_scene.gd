extends Control

@onready var timer: Timer = $Timer
@onready var tile_map: TileMapLayer = $ColorRect2/TileMapLayer
@export_range(0.01, 5.0, 0.01) var snek_speed : float
@onready var loading_bar: ColorRect = $LoadingBar
@onready var panel: Panel = $Panel

const MAX_SNEK_SIZE   = 128
const MAX_SNEK_SCORE  = 15.0
const SNEK_GRID_TILE  = Vector2i(0, 0)
const SNEK_BODY_TILE  = Vector2i(1, 0)
const SNEK_APPLE_TILE = Vector2i(2, 0)
const SNEK_CRASH_TILE = Vector2i(0, 1)
const SNEK_GRID_X = 33
const SNEK_GRID_Y = 17

#################################
## Globals
#################################
var _flag_timer : bool = false
var snek_body = []
var snek_size = 3
var snek_score = 0
var snek_direction : Vector2i = Vector2i(1,0)
var target_pos : Vector2i = Vector2i(0,0)
var apple_pos : Vector2i

#################################
## Functions
#################################
func _ready() -> void:
	snek_body.resize(MAX_SNEK_SIZE)
	snek_body[2] = Vector2i(0,0)
	snek_body[1] = Vector2i(1,0)
	snek_body[0] = Vector2i(2,0)
	seed(Time.get_ticks_usec())
	generate_apple()
	draw_snek_game()
	timer.wait_time = snek_speed
	timer.start()
	pass
	
func _physics_process(delta: float) -> void:
	# Get the input direction and prepare to move the direction
	var new_snek_direction = Input.get_vector("input_left","input_right","input_up","input_down") as Vector2i
	if(new_snek_direction != Vector2i(0,0) and snek_direction + new_snek_direction != Vector2i(0,0)):
		snek_direction = new_snek_direction
		
	# Game Tick
	if(_flag_timer):
		_flag_timer = false
		
		target_pos = snek_body[0] + snek_direction
		
		# Check if the desired location is valid
		if(tile_map.get_cell_atlas_coords(target_pos) == SNEK_BODY_TILE): # Ran into self
			tile_map.set_cell(snek_body[0], 0, SNEK_CRASH_TILE)
			timer.stop()
			await get_tree().create_timer(2).timeout
			reset_game()
			return
		elif(target_pos.x > SNEK_GRID_X or target_pos.x < 0 or target_pos.y > SNEK_GRID_Y or target_pos.y < 0): # Ran into wall
			# end game
			tile_map.set_cell(snek_body[0], 0, SNEK_CRASH_TILE)
			timer.stop()
			await get_tree().create_timer(2).timeout
			reset_game()
			return
		if(tile_map.get_cell_atlas_coords(target_pos) == SNEK_APPLE_TILE):
			snek_size  += 1
			snek_score += 1
			generate_apple()
		
		# Move the tail forward
		for i in range(snek_size - 1, 0, -1):
			snek_body[i] = snek_body[i-1]
		# Move head.
		snek_body[0] = target_pos
		
		draw_snek_game()
		var shader_mat = loading_bar.material as ShaderMaterial
		shader_mat.set_shader_parameter("progress", lerp_map(snek_score, 0.0, MAX_SNEK_SCORE, 0.0, 1.0))
		if(snek_score >= MAX_SNEK_SCORE):
			timer.stop()
			win_game()
	
func draw_snek_game() -> void:
	# Refill Grid
	for x in range(0, SNEK_GRID_X + 1):
		for y in range(0, SNEK_GRID_Y + 1): 
			tile_map.set_cell(Vector2i(x,y), 0, SNEK_GRID_TILE)
	# Draw Snek
	for i in range(0, snek_size):
		tile_map.set_cell(snek_body[i], 0, SNEK_BODY_TILE)
	# Draw Apple
	tile_map.set_cell(apple_pos, 0, SNEK_APPLE_TILE)

func win_game() -> void:
	panel.visible = true

func reset_game() -> void:
	snek_body.resize(MAX_SNEK_SIZE)
	snek_body[2] = Vector2i(0,0)
	snek_body[1] = Vector2i(1,0)
	snek_body[0] = Vector2i(2,0)
	snek_direction = Vector2i(1,0)
	snek_size = 3
	snek_score = 0
	generate_apple()
	draw_snek_game()
	timer.wait_time = 0.15
	timer.start()

func generate_apple() -> void:
	var found_apple = false
	while not found_apple:
		var x = randi_range(0, SNEK_GRID_X)
		var y = randi_range(0, SNEK_GRID_Y)
		if(tile_map.get_cell_atlas_coords(Vector2i(x,y)) == SNEK_GRID_TILE):
			apple_pos = Vector2i(x, y)
			found_apple = true
		
func lerp_map(value: float, min_x: float, max_x: float, map_min: float, map_max: float) -> float:
	var t = (value - min_x) / (max_x - min_x)
	return lerp(map_min, map_max, t)

func _on_timer_timeout() -> void:
	_flag_timer = true

func _on_button_pressed() -> void:
	Signals.SNEK_COMPLETE.emit()
