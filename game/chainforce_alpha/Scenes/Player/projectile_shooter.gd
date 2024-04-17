extends Node2D
class_name ProjectileShooter

var projectile_scene: PackedScene = preload("res://Scenes/ShipProjectile/ship_projectile.tscn")

## Used in player's powerup damage increase
@export var level: int

@onready var cooldown_timer: Timer = $Timer
@onready var shoot_sfx: AudioStreamPlayer2D = $ShootSFX

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		cooldown_timer.one_shot = false
		if cooldown_timer.is_stopped():
			shoot_projectile()
			cooldown_timer.start()
	elif Input.is_action_just_released("shoot"):
		cooldown_timer.one_shot = true

func shoot_projectile() -> void:
	var projectile_count = level / 2 + 1
	
	var projectile: ShipProjectile = projectile_scene.instantiate()
	projectile.global_rotation = global_rotation
	projectile.global_position = global_position
	
	if level % 2 == 1:
		projectile.damage += 1
		projectile.scale *= 1.4
		projectile.get_node("ProjectileTrail").width *= 1.4
		projectile.get_node("ProjectileTrail").max_length *= 1.1
	
	if level == 2 or level == 3:
		var new_projectile: ShipProjectile = projectile.duplicate()
		projectile.rotation_degrees -= 5
		new_projectile.rotation_degrees += 5
		add_sibling(new_projectile)
	elif level >= 4:
		var new_projectile: ShipProjectile = projectile.duplicate()
		var new_projectile2: ShipProjectile = projectile.duplicate()
		projectile.rotation_degrees -= 10
		new_projectile.rotation_degrees += 10
		add_sibling(new_projectile)
		add_sibling(new_projectile2)
	
	add_sibling(projectile)
	
	shoot_sfx.pitch_scale = randf_range(0.8, 1)
	shoot_sfx.play()

func _on_timer_timeout() -> void:
	if Input.is_action_pressed("shoot"):
		shoot_projectile()
