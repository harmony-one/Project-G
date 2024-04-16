extends Control

func _on_start_button_pressed() -> void:
	print("What the hell is going on")
	get_tree().change_scene_to_file("res://Scenes/MainScene/main_scene.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
