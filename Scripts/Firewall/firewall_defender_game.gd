extends Node2D

@onready var event_timer: Timer = $EventTimer
@onready var fire_spawner: Timer = $FireSpawner
@onready var rebooting: Control = $Rebooting
@onready var need_reboot: Control = $NeedReboot
@onready var reboot_complete: Control = $RebootComplete

@onready var loading_bar: ColorRect = $Rebooting/LoadingBar

@export var fire_strength: Curve
@export var fire_chance: Curve

const fire_obj = preload("res://Scenes/Games/Fire.tscn")

var fires: Array[Node2D] = []
var center: Vector2
var edge_spawn_chance := 0.18
var edge_margin := 32
var time = 0

func _ready() -> void:
	center = get_viewport_rect().size / 2
	rebooting.visible = false
	need_reboot.visible = true

func game_finished() -> void:
	for flame in fires:
		flame.queue_free()
	reboot_complete.visible = true
	rebooting.visible = false

func spawn_initial_fire() -> void:
	var fire = fire_obj.instantiate()
	fire.global_position = Vector2(randf_range(100,300), randf_range(100, 300))
	add_child(fire)
	fires.append(fire)
	fire.fire_clicked.connect(_on_fire_clicked)
	
func _on_fire_clicked(fire: Node2D):
	fires.erase(fire)
	
func _on_fire_spawner_timeout():
	fire_spawner.wait_time = fire_strength.sample(time)
	if randf() < edge_spawn_chance or fires.size() == 0:
		_spawn_fire_on_edge()
		return
	_spawn_fire_on_existing()
	


func _spawn_fire_on_existing():		
	# Pick a random fire to propogate from
	var source = fires[randi() % fires.size()]
	var dir_to_center = (center - source.global_position).normalized()
	
	# Reduce Spread Over Time
	var spawn_pos = source.global_position + (dir_to_center.rotated(randf_range(-PI / 4, PI / 4)) * randf_range(50.0, 50.0))
	
	# Spawn new fire
	var new_fire = fire_obj.instantiate()
	new_fire.global_position = spawn_pos
	add_child(new_fire)
	fires.append(new_fire)
	new_fire.fire_clicked.connect(_on_fire_clicked)
	
func _spawn_fire_on_edge():
	var screen_size = get_viewport_rect().size
	var fire = fire_obj.instantiate()

	match randi() % 4:
		0:  # Top edge
			fire.global_position = Vector2(randf_range(edge_margin, screen_size.x - edge_margin), edge_margin)
		1:  # Bottom edge
			fire.global_position = Vector2(randf_range(edge_margin, screen_size.x - edge_margin), screen_size.y - edge_margin)
		2:  # Left edge
			fire.global_position = Vector2(edge_margin, randf_range(edge_margin, screen_size.y - edge_margin))
		3:  # Right edge
			fire.global_position = Vector2(screen_size.x - edge_margin, randf_range(edge_margin, screen_size.y - edge_margin))

	add_child(fire)
	fires.append(fire)
	fire.fire_clicked.connect(_on_fire_clicked)


func _on_button_pressed() -> void:
	rebooting.visible = true
	need_reboot.visible = false
	fire_spawner.wait_time = 0.20
	fire_spawner.start()
	spawn_initial_fire()
	event_timer.start();


func _on_event_timer_timeout() -> void:
	time += 0.05
	if(time >= 30.0):
		event_timer.stop()
		fire_spawner.stop()
		game_finished()
		return
		
	var load_perc = lerp_map(time, 0.0, 30.0, 0.0, 1.0)
	var shader_mat = loading_bar.material as ShaderMaterial
	shader_mat.set_shader_parameter("progress", load_perc)
	edge_spawn_chance = fire_chance.sample(time)
	
func lerp_map(value: float, min_x: float, max_x: float, map_min: float, map_max: float) -> float:
	var t = (value - min_x) / (max_x - min_x)
	return lerp(map_min, map_max, t)


func _on_close_button_pressed() -> void:
	pass # Replace with function body.


func _on_fire_entered(area: Area2D) -> void:
	print("Fire Touched Box")
	# TODO FAILED
	event_timer.stop()
	fire_spawner.stop()
	return
