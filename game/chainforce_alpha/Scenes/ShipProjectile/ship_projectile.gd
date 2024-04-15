extends Area2D
class_name ShipProjectile

@export var speed: float = 1000
@export var damage: int = 4

var active: bool = true

func _ready() -> void:
	$ProjectileTrail.default_color = modulate

func _physics_process(delta: float) -> void:
	if !active:
		return
	
	position += Vector2(0, -speed).rotated(rotation) * delta

func _on_lifetime_timer_timeout() -> void:
	destroy_projectile()

func destroy_projectile() -> void:
	active = false
	$Sprite2D.visible = false
	$ExplosionParticles.emitting = true
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(1).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	destroy_projectile()
	if body.is_in_group("enemy") or body.is_in_group("friendly"):
		body.hp -= damage
		if !(get_parent() is Player) and body.hp <= 0:
			get_parent().choose_next_target()
