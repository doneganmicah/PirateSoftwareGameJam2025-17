extends Area2D

signal fire_clicked(fire: Node2D)

func _ready() -> void:
	input_pickable = true
	connect("input_event", _on_fire_click)

func _on_fire_click(viewport, event, shape_idx):
	if (event is InputEventMouseButton):
		var mouse_event = event as InputEventMouse
		if(mouse_event.is_pressed()):
			fire_clicked.emit(self)
			queue_free()
