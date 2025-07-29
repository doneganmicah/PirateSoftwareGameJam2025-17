extends Node2D

@onready var fire_spawner: Timer = $FireSpawner
const fire_obj = preload("res://Scenes/Games/Fire.tscn")

var fires: Array[Node2D] = []
var center: Vector2
var edge_spawn_chance := 0.18
var edge_margin := 32

func _ready() -> void:
	center = get_viewport_rect().size / 2
	fire_spawner.wait_time = 0.20
	fire_spawner.start()
	spawn_initial_fire()

func spawn_initial_fire() -> void:
	var fire = fire_obj.instantiate()
	fire.global_position = Vector2(randf_range(100,300), randf_range(100, 300))
	add_child(fire)
	fires.append(fire)
	fire.fire_clicked.connect(_on_fire_clicked)
	
func _on_fire_clicked(fire: Node2D):
	fires.erase(fire)
	
func _on_fire_spawner_timeout():
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
