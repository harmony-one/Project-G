extends CharacterBody2D
class_name Player

signal hp_changed(new_hp: float)

@export var hp: int = 20 :
	set(val):
		hp = val
		hp_changed.emit(hp)
		if is_inside_tree():
			var tween: Tween = create_tween()
			tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "modulate", Color.WHITE, 0.5).from(Color(1.3, 1.3, 1.3))
			if hp <= 0:
				die()

@export var speed: float = 1000
@export var max_speed: float = 650

@onready var acceleration_particles: GPUParticles2D = $Particles/AccelerationParticles
@onready var left_strafe_particles: GPUParticles2D = $Particles/LeftStrafeParticles
@onready var right_strafe_particles: GPUParticles2D = $Particles/RightStrafeParticles
@onready var explosion_particles: GPUParticles2D = $Particles/ExplosionParticles

var is_dead: bool

func _process(delta: float) -> void:
	if is_dead:
		return
	
	var mouse_position: Vector2 = get_global_mouse_position()
	look_at(mouse_position)
	rotation_degrees += 90

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	handle_acceleration(delta)
	handle_strafing(delta)
	
	velocity = velocity.limit_length(max_speed)
	
	move_and_slide()
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		var collision_normal: Vector2 = collision.get_normal()
		velocity -= collision_normal * 200
		collision_normal = -abs(collision_normal)
		if collision_normal.x == 0:
			collision_normal.x = 0.5
		if collision_normal.y == 0:
			collision_normal.y = 0.5
		velocity *= 0.7 * collision_normal
		
		if collision.get_collider() is CharacterBody2D: # Hit enemy or such
			collision.get_collider().velocity = -velocity
		
		$BumpSFX.pitch_scale = randf_range(1, 1.1)
		$BumpSFX.play()

func handle_acceleration(delta: float) -> void:
	var acceleration_input: float = Input.get_axis("accelerate", "decelerate")
	
	if acceleration_input < 0:
		velocity += Vector2(0, acceleration_input).rotated(rotation) * speed * delta
		acceleration_particles.emitting = true
	else:
		if acceleration_input > 0:
			velocity += Vector2(0, acceleration_input).rotated(rotation) * speed / 2 * delta
		acceleration_particles.emitting = false
		velocity = velocity.move_toward(Vector2.ZERO, delta * speed / 6)

func handle_strafing(delta: float) -> void:
	var strafing_input: float = Input.get_axis("move_left", "move_right")
	
	if strafing_input:
		if strafing_input > 0:
			left_strafe_particles.emitting = true
			right_strafe_particles.emitting = false
		else:
			right_strafe_particles.emitting = true
			left_strafe_particles.emitting = false
		
		var strafing_vector: Vector2 = Vector2(strafing_input, -0.1).rotated(rotation) * speed * 0.75 * delta
		velocity += strafing_vector
	else:
		left_strafe_particles.emitting = false
		right_strafe_particles.emitting = false

func die():
	is_dead = true
	$ProjectileShooter.process_mode = Node.PROCESS_MODE_DISABLED
	$Sprite2D.visible = false
	$CollisionPolygon2D.set_deferred("disabled", true)
	
	explosion_particles.emitting = true
	acceleration_particles.emitting = false
	left_strafe_particles.emitting = false
	right_strafe_particles.emitting = false
	$ExplosionSFX.play()
