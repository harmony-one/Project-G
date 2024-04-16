extends StaticBody2D
class_name Tower

@export var rotation_speed: float = 5
@export var hp: int = 100 :
	set(val):
		hp = val
		var tween: Tween = create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate", Color.WHITE, 0.5).from(Color(1.3, 1.3, 1.3))
		if hp <= 0:
			die()

@export var minion_scene: PackedScene
@export var minion_spawn_count: int = 4
@export var minion_spawn_delay: float = 1

@onready var projectile_shooter: EnemyProjectileShooter = $ProjectileShooter
@onready var detection_area: Area2D = $DetectionArea

var enemy_target: Node2D
var is_dead: bool

func _ready() -> void:
	await get_tree().process_frame
	_on_minion_spawn_timeout()

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	shoot_enemy(delta)

func shoot_enemy(delta: float):
	if enemy_target == null or enemy_target.hp <= 0:
		choose_next_target()
		return
	
	var target_rotation: float = global_position.angle_to_point(enemy_target.global_position) #+ PI/2
	global_rotation = lerp_angle(global_rotation, target_rotation, rotation_speed * delta)

func die():
	is_dead = true
	$ExplosionParticles.emitting = true
	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$ProjectileShooter.process_mode = Node.PROCESS_MODE_DISABLED
	$ExplosionSFX.play()
	await get_tree().create_timer(3).timeout
	queue_free()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("friendly") or body.is_in_group("enemy"):
		enemy_target = body
		projectile_shooter.can_shoot = true

func choose_next_target():
	await get_tree().process_frame
	await get_tree().process_frame
	var next_target: Node2D
	for body: Node2D in detection_area.get_overlapping_bodies():
		if next_target == null or next_target.hp <= 0:
			next_target = body
		else:
			var distance_to_body: float = body.global_position.distance_squared_to(global_position)
			var distance_to_target: float = next_target.global_position.distance_squared_to(global_position)
			if distance_to_body < distance_to_target:
				next_target = body
	
	if next_target == null:
		enemy_target = null
		projectile_shooter.can_shoot = false
	else:
		enemy_target = next_target

func _on_minion_spawn_timeout() -> void:
	for i in range(minion_spawn_count):
		var minion: Node2D = minion_scene.instantiate()
		minion.global_position = global_position + Vector2(randi_range(-100, 100), randi_range(-100, 0))
		get_parent().add_sibling(minion)
		await get_tree().create_timer(minion_spawn_delay).timeout
