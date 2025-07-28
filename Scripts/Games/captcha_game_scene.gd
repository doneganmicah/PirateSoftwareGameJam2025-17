extends Control

@onready var tile_map: TileMapLayer = $VBoxContainer/Grid/SelectionGrid
@onready var tex_prompt: TextureRect = $VBoxContainer/Grid/TextureRect
@onready var lbl_prompt: Label = $VBoxContainer/ColorRect2/Prompt
@onready var lbl_title: Label = $VBoxContainer/ColorRect2/Title
@onready var btn_prompt: Button = $VBoxContainer/Button/Button
@onready var bigger_prompt: Label = $VBoxContainer/ColorRect2/BiggerPrompt


const CAPTCHA_TILE_PROMPT_1 = preload("res://Assets/Captcha/captcha_tile_prompt1.jpg")
const CAPTCHA_TILE_PROMPT_2 = preload("res://Assets/Captcha/captcha_tile_prompt2.png")
const CAPTCHA_TILE_PROMPT_3 = preload("res://Assets/Captcha/captcha_tile_prompt3.png")
const CAPTCHA_TILE_PROMPT_4 = preload("res://Assets/Captcha/captcha_tile_prompt4.png")
const CAPTCHA_TILE_PROMPT_5 = preload("res://Assets/Captcha/captcha_tile_prompt5.png")
const CAPTCHA_TILE_PROMPT_6 = preload("res://Assets/Captcha/captcha_tile_prompt6.png")
const CAPTCHA_TILE_PROMPT_7 = preload("res://Assets/Captcha/captcha_tile_prompt7.png")
const CAPTCHA_TILE_PROMPT_8 = preload("res://Assets/Captcha/captcha_tile_prompt8.png")
const CAPTCHA_TILE_PROMPT_9 = preload("res://Assets/Captcha/captcha_tile_prompt9.png")
const CAPTCHA_TILE_IS_ROBOT = preload("res://Assets/Captcha/captcha_tile_is_robot.png")
const CAPTCHA_TILE_IS_HUMAN = preload("res://Assets/Captcha/captcha_tile_is_human.png")

const SELECTED   = 1
const UNSELECTED = 0
const GRID_WIDTH = 5
const GRID_HEIGHT = 5

enum PromptState {
	stPROMPT1,
	stPROMPT2,
	stPROMPT3,
	stPROMPT4,
	stPROMPT5,
	stPROMPT6,
	stPROMPT7,
	stPROMPT8,
	stPROMPT9,
	IS_HUMAN,
	IS_ROBOT,
	RESET
}
var current_state: PromptState
var current_bitmap := 0
var correct_prompts = 0
var listening = true

const txPROMPT1 = "a traffic light."
const txPROMPT2 = "a man on the beach."
const txPROMPT3 = "a person who forgot why they walked into the room."
const txPROMPT4 = "a person who always says I'm fine but never means it."
const txPROMPT5 = "a person who peaked in high school."
const txPROMPT6 = "a person who used to have potential."
const txPROMPT7 = "a person who keeps showing up, hoping something will change."
const txPROMPT8 = "a person who still dreams of a life that quietly slipped through their fingers. A person who lies awake some nights, not with regret exactly, but with the lingering ache of all the versions of themselves they never got to become. Among these faces, find the one who carries the weight of imagined paths and unopened doors, walking forward while glancing over their shoulder at a future that never arrived."
const txPROMPT9 = "a tricycle."

const bmPROMPT1 := 0b0000001100011000110000000
const bmPROMPT2 := 0b1110011100111001110011000
const bmPROMPT3 := 0b0001100011000000000000000
const bmPROMPT4 := 0b0000011000110000000000000
const bmPROMPT5 := 0b0111101111001110001100011
const bmPROMPT6 := 0b0000000000000110001100011
const bmPROMPT7 := 0b1100011000000000000000000
const bmPROMPT8 := 0b1111011110111100110000000
const bmPROMPT9 := 0b0011100111000110001100000


func _ready() -> void:
	current_state = PromptState.RESET
	fsm_step()
	
##############################################
## Reset the grids selections
##############################################
func reset_grid() -> void:
	current_bitmap = 0
	for x in range(0, GRID_WIDTH):
		for y in range(0, GRID_HEIGHT):
			tile_map.set_cell(Vector2i(x,y), UNSELECTED, Vector2i(x,y))

##############################################
## Run the current state operation
## Check if the selected inputs compared to  
##############################################
func fsm_run():
	match current_state:
		PromptState.stPROMPT1:
			print("Selected " + str(current_bitmap) + " == " + str(bmPROMPT1))
			if(current_bitmap == bmPROMPT1):
				correct_prompts += 1
				print("correct ")
			reset_grid()
		PromptState.stPROMPT2:
			print("Selected " + str(current_bitmap) + " == " + str(bmPROMPT2))
			if(current_bitmap == bmPROMPT2):
				correct_prompts += 1
				print("correct")
			reset_grid()
		PromptState.stPROMPT3:
			print("Selected " + str(current_bitmap) + " == " + str(bmPROMPT3))
			if(current_bitmap == bmPROMPT3):
				correct_prompts += 1
				print("correct")
			reset_grid()
		PromptState.stPROMPT4:
			print("Selected " + str(current_bitmap) + " == " + str(bmPROMPT4))
			if(current_bitmap == bmPROMPT4):
				correct_prompts += 1
				print("correct")
			reset_grid()
		PromptState.stPROMPT5:
			print("Selected " + str(current_bitmap) + " == " + str(bmPROMPT5))
			if(current_bitmap == bmPROMPT5):
				correct_prompts += 1
				print("correct")
			reset_grid()
		PromptState.stPROMPT6:
			print("Selected " + str(current_bitmap) + " == " + str(bmPROMPT6))
			if(current_bitmap == bmPROMPT6):
				correct_prompts += 1
				print("correct")
			reset_grid()
		PromptState.stPROMPT7:
			print("Selected " + str(current_bitmap) + " == " + str(bmPROMPT7))
			if(current_bitmap == bmPROMPT7):
				correct_prompts += 1
				print("correct")
			reset_grid()
		PromptState.stPROMPT8:
			print("Selected " + str(current_bitmap) + " == " + str(bmPROMPT8))
			if(current_bitmap == bmPROMPT8):
				correct_prompts += 1
				print("correct")
			reset_grid()
		PromptState.stPROMPT9:
			print("Selected " + str(current_bitmap) + " == " + str(bmPROMPT9))
			if(current_bitmap == bmPROMPT9):
				correct_prompts += 1
				print("correct")
			reset_grid()
		PromptState.IS_HUMAN:
			pass
		PromptState.IS_ROBOT:
			pass
	fsm_step()
	
##############################################
## Transistion through the state machine
##############################################
func fsm_step():
	match current_state:
		PromptState.RESET:
			lbl_prompt.text = txPROMPT1
			tex_prompt.texture = CAPTCHA_TILE_PROMPT_1
			lbl_prompt.size = Vector2(250, 51)
			lbl_prompt.add_theme_font_size_override("font_size",16)
			current_state = PromptState.stPROMPT1
		PromptState.stPROMPT1:
			lbl_prompt.text = txPROMPT2
			tex_prompt.texture = CAPTCHA_TILE_PROMPT_2
			current_state = PromptState.stPROMPT2
		PromptState.stPROMPT2:
			lbl_prompt.text = txPROMPT3
			tex_prompt.texture = CAPTCHA_TILE_PROMPT_3
			current_state = PromptState.stPROMPT3
		PromptState.stPROMPT3:
			lbl_prompt.text = txPROMPT4
			tex_prompt.texture = CAPTCHA_TILE_PROMPT_4
			current_state = PromptState.stPROMPT4
		PromptState.stPROMPT4:
			lbl_prompt.text = txPROMPT5
			tex_prompt.texture = CAPTCHA_TILE_PROMPT_5
			current_state = PromptState.stPROMPT5
		PromptState.stPROMPT5:
			lbl_prompt.text = txPROMPT6
			tex_prompt.texture = CAPTCHA_TILE_PROMPT_6
			current_state = PromptState.stPROMPT6
		PromptState.stPROMPT6:
			lbl_prompt.text = txPROMPT7
			tex_prompt.texture = CAPTCHA_TILE_PROMPT_7
			current_state = PromptState.stPROMPT7
		PromptState.stPROMPT7:
			bigger_prompt.text = txPROMPT8
			lbl_prompt.visible = false
			bigger_prompt.visible = true
			current_state = PromptState.stPROMPT8
		PromptState.stPROMPT8:
			lbl_prompt.text = txPROMPT9
			lbl_prompt.visible = true
			bigger_prompt.visible = false
			tex_prompt.texture = CAPTCHA_TILE_PROMPT_9
			current_state = PromptState.stPROMPT9
		PromptState.stPROMPT9:
			if(correct_prompts >= 9):
				tile_map.visible = false
				listening = false
				tex_prompt.texture = CAPTCHA_TILE_IS_HUMAN
				current_state = PromptState.IS_HUMAN
				lbl_title.text = "You Are Human!"
				lbl_prompt.text = "Now you can play the One and Only Best Game!"
				btn_prompt.text = "Finish"
				print("is human")
			else:
				tile_map.visible = false
				listening = false
				current_state = PromptState.IS_ROBOT
				tex_prompt.texture = CAPTCHA_TILE_IS_ROBOT
				lbl_title.text = "You Are Robot, Sorry!"
				lbl_prompt.text = "Thats okay! Robots can still play the One and Only Best Game!"
				btn_prompt.text = "Finish"
				print("is robot")
		_: #Default Case
			pass
			# Error
			
##############################################
## Manage the bitmap
##############################################
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

##############################################
## Handles the mouse input on the tile grid
##############################################
func _input(event: InputEvent) -> void:
	if(!listening): return
	if(event is InputEventMouseButton and event.is_action_pressed("mouse_left_press")):
		var mouse_event := event as InputEventMouseButton
		var click_pos = tile_map.to_local(mouse_event.position)
		var tile_cell = tile_map.local_to_map(click_pos)
		if(tile_cell.x in range(0,GRID_WIDTH) and tile_cell.y in range(0,GRID_HEIGHT)):
			if(tile_map.get_cell_source_id(tile_cell) == SELECTED):
				tile_map.set_cell(tile_cell, UNSELECTED, tile_cell)
				current_bitmap = clear_bit(current_bitmap, tile_cell)
			elif(tile_map.get_cell_source_id(tile_cell) == UNSELECTED):
				tile_map.set_cell(tile_cell, SELECTED, tile_cell)
				current_bitmap = set_bit(current_bitmap, tile_cell)

##############################################
## Handles when the Next button is pressed
##############################################
func _on_button_pressed() -> void:
	if(current_state == PromptState.IS_HUMAN or current_state == PromptState.IS_ROBOT):
		# CALL END OF GAME
		pass
	else:
		fsm_run()
	pass # Replace with function body.
