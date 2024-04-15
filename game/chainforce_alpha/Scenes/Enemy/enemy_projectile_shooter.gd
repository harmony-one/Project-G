extends Node2D
class_name EnemyProjectileShooter

@export var projectile_scene: PackedScene

@onready var cooldown_timer: Timer = $Timer
@onready var shoot_sfx: AudioStreamPlayer2D = $ShootSFX
@onready var enemy_ship: PhysicsBody2D = get_parent()

@export var pitch_scale_min: float = 0.8
@export var pitch_scale_max: float = 1.0
@export var rotation_offset: float = 0

var can_shoot: bool # gets set to false when target is too far away

func shoot_projectile() -> void:
	if !can_shoot:
		return
	
	shoot_sfx.pitch_scale = randf_range(pitch_scale_min, pitch_scale_max)
	shoot_sfx.play()
	var projectile: ShipProjectile = projectile_scene.instantiate()
	projectile.global_rotation = global_rotation + rotation_offset
	projectile.global_position = global_position
	# Make the projectile "Evil"
	if get_parent().is_in_group("enemy"):
		projectile.modulate = Color.ORANGE_RED
		projectile.get_node("ProjectileTrail").modulate = Color.ORANGE_RED
		projectile.set_collision_layer_value(2, false)
		projectile.set_collision_layer_value(3, true)
		projectile.set_collision_mask_value(2, true)
		projectile.set_collision_mask_value(3, false)
	
	add_sibling(projectile)

func _on_timer_timeout() -> void:
	if enemy_ship.enemy_target != null:
		shoot_projectile()
