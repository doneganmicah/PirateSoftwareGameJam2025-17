extends Control

@onready var tile_map: TileMapLayer = $VBoxContainer/Grid/SelectionGrid
@onready var texture_rect: TextureRect = $VBoxContainer/Grid/TextureRect

const CAPTCHA_TILE_PROMPT_1 = preload("res://Assets/Captcha/captcha_tile_prompt1.jpg")
const CAPTCHA_TILE_PROMPT_2 = preload("res://Assets/Captcha/captcha_tile_prompt2.png")
const CAPTCHA_TILE_PROMPT_3 = preload("res://Assets/Captcha/captcha_tile_prompt3.png")
const CAPTCHA_TILE_PROMPT_4 = preload("res://Assets/Captcha/captcha_tile_prompt4.png")
const CAPTCHA_TILE_PROMPT_6 = preload("res://Assets/Captcha/captcha_tile_prompt6.png")
const CAPTCHA_TILE_PROMPT_7 = preload("res://Assets/Captcha/captcha_tile_prompt7.png")
const CAPTCHA_TILE_PROMPT_8 = preload("res://Assets/Captcha/captcha_tile_prompt8.png")
const CAPTCHA_TILE_PROMPT_9 = preload("res://Assets/Captcha/captcha_tile_prompt9.png")


const SELECTED   = 1
const UNSELECTED = 0

const GRID_WIDTH = 5
const GRID_HEIGHT = 5
var current_bitmap := 0
const prompt1_bitmap := 0b0000001100011000110000000
const prompt2_bitmap := 0b1110011100111001110011000
const prompt3_bitmap := 0b0001100011000000000000000
const prompt4_bitmap := 0b0000011000110000000000000
const prompt5_bitmap := 0b1100011000000000000000000
const prompt6_bitmap := 0b0000000000000110001100011
const prompt7_bitmap := 0b0111101111001110001100011
const prompt8_bitmap := 0b1111011110111100110000000
const prompt9_bitmap := 0b0011100111000110001100000

func init_game() -> void:
	pass

# Set a tile bit
func set_bit(bitmap: int, pos: Vector2i) -> int:
	if pos.x < 0 or pos.x >= GRID_WIDTH or pos.y < 0 or pos.y >= GRID_HEIGHT:
		return bitmap
	var bit_index = pos.y * GRID_WIDTH + pos.x
	return bitmap | (1 << bit_index)

# Clear a tile bit
func clear_bit(bitmap: int, pos: Vector2i) -> int:
	if pos.x < 0 or pos.x >= GRID_WIDTH or pos.y < 0 or pos.y >= GRID_HEIGHT:
		return bitmap
	var bit_index = pos.y * GRID_WIDTH + pos.x
	return bitmap & ~(1 << bit_index)

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseButton and event.is_action_pressed("mouse_left_press")):
		var mouse_event := event as InputEventMouseButton
		var click_pos = tile_map.to_local(mouse_event.position)
		var tile_cell = tile_map.local_to_map(click_pos)
		if(tile_cell.x in range(0,GRID_WIDTH) and tile_cell.y in range(0,GRID_HEIGHT)):
			if(tile_map.get_cell_source_id(tile_cell) == SELECTED):
				print("UnSelect")
				tile_map.set_cell(tile_cell, UNSELECTED, tile_cell)
				current_bitmap = clear_bit(current_bitmap, tile_cell)
			elif(tile_map.get_cell_source_id(tile_cell) == UNSELECTED):
				print("Select")
				tile_map.set_cell(tile_cell, SELECTED, tile_cell)
				current_bitmap = set_bit(current_bitmap, tile_cell)
		print("Current " + str(current_bitmap))
		print("Prompt " + str(prompt1_bitmap))

func _on_button_pressed() -> void:
	pass # Replace with function body.
