extends Area2D

@export var powerup_name: String

func _ready() -> void:
	# Randomly choose powerup type
	var possible_powerups: Array[String] = ["speed", "power", "shield"]
	
	powerup_name = possible_powerups.pick_random()
	
	if powerup_name == "speed":
		$Sprite2D.texture = load("res://Scenes/Powerup/Speed.png")
	elif powerup_name == "shield":
		$Sprite2D.texture = load("res://Scenes/Powerup/Shield.png")
	elif powerup_name == "power":
		$Sprite2D.texture = load("res://Scenes/Powerup/Power.png")
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.5).from(Vector2(0.1, 0.1))

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.collect_powerup(powerup_name)
		queue_free()

func _on_lifetime_timeout() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.tween_property(self, "scale", Vector2.ZERO, 0.5).finished
	queue_free()
