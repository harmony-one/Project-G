extends CharacterBody2D
class_name EnemyShip

@export var hp: int = 10 :
	set(val):
		hp = val
		if !is_inside_tree():
			return
		var tween: Tween = create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate", Color.WHITE, 0.5).from(Color(1.3, 1.3, 1.3))
		if hp <= 0:
			die()

@export var speed: float = 450
@export var rotation_speed: float = 5
@export var stop_distance: float = 500
@export var shoot_distance: float = 800

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var projectile_shooter: EnemyProjectileShooter = $ProjectileShooter
@onready var detection_area: Area2D = $DetectionArea

var powerup_scene: PackedScene = preload("res://Scenes/Powerup/powerup.tscn")

var enemy_target: Node2D
var is_dead: bool

var target_base: Base

func _ready() -> void:
	# Set target base
	for base: Base in get_tree().get_nodes_in_group("base"):
		var target_enemy: bool = base.is_in_group("enemy") and is_in_group("friendly")
		var target_friendly: bool = base.is_in_group("friendly") and is_in_group("enemy")
		if target_enemy or target_friendly:
			target_base = base
	
	# Spawn animation
	var start_scale: Vector2 = $Sprite2D.scale
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Sprite2D, "scale", start_scale, 1).from(Vector2(0.1, 0.1))

func _physics_process(delta: float):
	if is_dead:
		return
	
	chase_target(delta)
	
	nav_agent.velocity = velocity
	
	move_and_slide()

func chase_target(delta: float):
	if enemy_target == null or enemy_target.hp <= 0:
		# TODO check performance of this
		choose_next_target()
		return
	
	var target_rotation: float = global_position.angle_to_point(enemy_target.global_position) + PI/2
	global_rotation = lerp_angle(global_rotation, target_rotation, rotation_speed * delta)
	
	nav_agent.target_position = enemy_target.global_position
	
	if nav_agent.distance_to_target() > stop_distance:
		var direction: Vector2 = nav_agent.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction * speed * 5, delta)
		#velocity = velocity.move_toward(direction * speed, delta * 5)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * stop_distance)
	
	if nav_agent.distance_to_target() < shoot_distance:
		projectile_shooter.can_shoot = true
	else:
		projectile_shooter.can_shoot = false

func die():
	is_dead = true
	$ExplosionParticles.emitting = true
	$Sprite2D.visible = false
	$CollisionPolygon2D.set_deferred("disabled", true)
	$ProjectileShooter.process_mode = Node.PROCESS_MODE_DISABLED
	$ExplosionSFX.play()
	
	var spawn_powerup: bool = is_in_group("enemy") and randi_range(0, 10) == 10
	if spawn_powerup:
		var powerup: Node2D = powerup_scene.instantiate()
		powerup.global_position = global_position
		#add_sibling(powerup)
		call_deferred("add_sibling", powerup)
	
	await get_tree().create_timer(2).timeout
	queue_free()

func choose_next_target():
	if !detection_area.has_overlapping_bodies():
		enemy_target = target_base
		projectile_shooter.can_shoot = false
		return
	
	var next_target: Node2D
	for body: Node2D in detection_area.get_overlapping_bodies():
		if next_target == null or next_target.hp <= 0:
			next_target = body
		else:
			var distance_to_body: float = body.global_position.distance_squared_to(global_position)
			var distance_to_target: float = next_target.global_position.distance_squared_to(global_position)
			if distance_to_body < distance_to_target:
				next_target = body
	
	enemy_target = next_target

# NOTE: Not used at the moment, might be useful later.
#func target_closest_tower():
	#enemy_target = null
	#var towers_arr: Array[Node] = get_tree().get_nodes_in_group("tower")
	#if towers_arr.is_empty():
		#printerr("enemy_ship.gd: Why are there no towers?")
		#return
	#
	#for tower: Node2D in towers_arr:
		#if is_in_group("enemy") and tower.is_in_group("friendly"):
			#set_closest_target(tower)
		#elif is_in_group("friendly") and tower.is_in_group("enemy"):
			#set_closest_target(tower)

func set_closest_target(next_target: Node2D):
	if enemy_target == null:
		enemy_target = next_target
	else:
		var target_distance: float = global_position.distance_squared_to(enemy_target.global_position)
		var tower_distance: float = global_position.distance_squared_to(next_target.global_position)
		if tower_distance < target_distance:
			enemy_target = next_target

func _on_detection_area_body_entered(body: Node2D) -> void:
	# Always focus the player instead of other entities
	var deselect_current_target: bool = (enemy_target == null or enemy_target is Base or enemy_target is Tower or body is Player)
	var body_is_targetable: bool = body.is_in_group("friendly") or body.is_in_group("enemy")
	if deselect_current_target and body_is_targetable:
		if enemy_target == null or !(enemy_target is Player):
			enemy_target = body


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	# WARNING: The NavAgent has a max_speed variable that could override the current speed
	# If it's weirdly moving too slow or too fast, change that.
	velocity = safe_velocity
