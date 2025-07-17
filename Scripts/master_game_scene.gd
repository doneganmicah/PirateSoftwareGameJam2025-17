################################################################################
## This is the master game controller than manages the scenes and ui.         ##
## Based off of StayAtHomeDev's implemintation of scene management.           ##
################################################################################ 
class_name GameController extends Node

# Instance of 2DScene control node
@onready var scene_2d: Node2D = $"2DScene"
# Instance of UIControl control node
@onready var gui: Control = $GUI

# The currently set scene in the manager
var current_2d_scene : Node2D
# The currently set gui in the manager
var current_gui_scene : Control

func _ready() -> void:
	Globals.game_controller = self
	
################################################################################
## Called when the GUI Control node needs to have its control changed.        ##
##                                                                            ##
##	Parameters:                                                               ##
##		new_scene (String)  - The path or name of the new GUI scene to load.  ##
##      delete    (bool)    - Whether to delete the current scene before      ##
##                            loading the new one.                            ##
##      keep_running (bool) - Whether to keep the current scene running in    ##
##                            the background.                                 ##
##                                                                            ##
##	Returns:                                                                  ##
##		void - No return value.                                               ##
##                                                                            ##
##	Example Usage:                                                            ##
##		game_controller.change_gui_scene(Scenes.opening_cutscene)             ##
################################################################################
func change_gui_scene(new_scene: String, delete: bool = true, keep_running = false) -> void:
	if(current_gui_scene != null):
		if delete:
			current_gui_scene.queue_free() # Remove the scene from memory
		elif keep_running: # really only used with pause screen probably
			current_gui_scene.visible = false # Keeps in memory and running
		else:
			gui.remove_child(current_gui_scene) # Keeps in memory, does not run
	var scene = load(new_scene) as PackedScene  # Load the new scene into memory
	var new = scene.instantiate()
	gui.add_child(new) # Add it to the running tree
	current_gui_scene = new 

################################################################################
## Called when the Scene node needs to have its scene changed.                ##
##                                                                            ##
##	Parameters:                                                               ##
##		new_scene (String)  - The path or name of the new 2D scene to load.   ##
##      delete    (bool)    - Whether to delete the current scene before      ##
##                            loading the new one.                            ##
##      keep_running (bool) - Whether to keep the current scene running in    ##
##                            the background.                                 ##
##                                                                            ##
##	Returns:                                                                  ##
##		void - No return value.                                               ##
##                                                                            ##
##	Example Usage:                                                            ##
##		game_controller.change_2d_scene(Scenes.level_one)                     ##
################################################################################
func change_2d_scene(new_scene: String, delete: bool = true, keep_running = false) -> void:
	if(current_2d_scene != null):
		if delete:
			current_2d_scene.queue_free() # Remove the scene from memory
		elif keep_running:
			current_2d_scene.visible = false # Keeps in memory and running
		else:
			scene_2d.remove_child(current_2d_scene) # Keeps in memory, does not run
	var scene = load(new_scene) as PackedScene  # Load the new scene into memory
	var new = scene.instantiate()
	scene_2d.add_child(new) # Add it to the running tree
	current_2d_scene = new 
