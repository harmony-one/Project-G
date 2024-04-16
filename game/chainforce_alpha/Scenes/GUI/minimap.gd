extends Panel

var map_sprite_scene: PackedScene = preload("res://Scenes/GUI/map_sprite.tscn")

## Key: The node I'm tracking, value: The equivalent sprite on the map
var tracking_dict: Dictionary

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_removed)

func _physics_process(delta: float) -> void:
	for node: Node2D in tracking_dict.keys():
		tracking_dict[node].global_position = node.global_position

func _on_node_added(node: Node) -> void:
	if node.is_in_group("enemy") or node.is_in_group("friendly"):
		var map_sprite: Sprite2D = map_sprite_scene.instantiate()
		map_sprite.global_position = node.global_position
		
		if node.is_in_group("enemy"):
			map_sprite.modulate = Color.RED
		elif node.is_in_group("friendly"):
			map_sprite.modulate = Color.BLUE
		
		if node is Tower:
			map_sprite.scale *= 1.75
		elif node is Player:
			map_sprite.modulate = Color.GREEN
		
		if node.is_in_group("minion"):
			map_sprite.scale /= 2
		
		%MapSubviewport.add_child(map_sprite)
		
		tracking_dict[node] = map_sprite

func _on_node_removed(node: Node) -> void:
	if node.is_in_group("enemy") or node.is_in_group("friendly"):
		tracking_dict[node].queue_free()
		tracking_dict.erase(node)
