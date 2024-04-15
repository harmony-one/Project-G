extends Line2D

var queue: Array[Vector2]
@export var max_length: int = 50

func _physics_process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_parent().global_position
	queue.push_front(mouse_pos)
	
	if queue.size() > max_length:
		queue.pop_back()
	
	clear_points()
	
	for point: Vector2 in queue:
		add_point(point)
