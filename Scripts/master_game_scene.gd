################################################################################
## This is the master game controller than manages the scenes and ui.         ##
## Based off of StayAtHomeDev's implemintation of scene management.           ##
################################################################################ 
class_name GameController extends Node

# Instance of 2DScene control node
@onready var scene_2d: Node2D = $"2DScene"
# Instance of UIControl control node
@onready var gui: Control = $GUI
enum {
	SNEK,
	CAPTCHA,
	FIRE
}

enum {
	stSTARTUP,
	stDESKTOP,
	stBROWSER,
	stGAME,
	stCRASH,
	stEND_GAME
}

var current_game = SNEK
var current_state = stSTARTUP

var flag_startup_finished = false
var flag_crashed = false

func _ready() -> void:
	Globals.game_controller = self
	Signals.PLAY_PRESSED.connect(_on_play_pressed)
	Signals.SNEK_COMPLETE.connect(_on_snek_completed)
	
func fsm_run():
	match(current_state):
		stSTARTUP:
			pass
		stDESKTOP:
			pass
		stBROWSER:
			pass
		stGAME:
			pass
		stCRASH:
			pass
		stEND_GAME:
			pass
		_:
			pass

func fsm_step():
	match(current_state):
		stSTARTUP:
			if(flag_startup_finished): current_state = stDESKTOP
		stDESKTOP:
			pass
		stBROWSER:
			pass
		stGAME:
			pass
		stCRASH:
			pass
		stEND_GAME:
			pass
		_:
			pass

func _on_snek_completed():
	pass

func _on_play_pressed():
	pass
	
func _on_firewall_completed():
	pass

func _on_captcha_completed():
	pass
