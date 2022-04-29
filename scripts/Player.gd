# Copyright Jessie's Game Studio 2022, All rights reserved.

extends KinematicBody2D

signal died

var playerDeathScene = preload('res://scenes/PlayerDeath.tscn')
var footstepParticlesScene = preload('res://scenes/FootstepParticles.tscn')

enum State { NORMAL, DASHING, INPUT_DISABLED }

export (int, LAYERS_2D_PHYSICS) var dashHazardMask

var gravity: int = 1000
var velocity: Vector2 = Vector2.ZERO
var maxHorizontalSpeed: int = 150
var maxDashSpeed: int = 500
var minDashSpeed: int = 200
var horizontalAcceleration: int = 2000
var jumpForce: int = 310
var jumpTerminationMultiplier: int = 4
var hasDoubleJumped: bool = false
var hasDashed: bool = false
var currentState = State.NORMAL
var isStateNew: bool = true
var defaultHazardMask: int = 0
var isAlive: bool = true

func _ready() -> void:
	$HazardHitbox.connect('area_entered', self, 'on_hazard_area_entered')
	$AnimatedSprite.connect('frame_changed', self, 'on_animated_sprite_frame_changed')
	defaultHazardMask = $HazardHitbox.collision_mask


func _process(delta: float) -> void:
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dashing(delta)
		State.INPUT_DISABLED:
			process_input_disabled(delta)
	isStateNew = false


func change_state(newState) -> void:
	currentState = newState
	isStateNew = true


func process_normal(delta: float) -> void:
	if isStateNew:
		$DashParticles.emitting = false
		$DashArea/CollisionShape2D.disabled = true
		$HazardHitbox.collision_mask = defaultHazardMask

	var moveVector: Vector2 = get_movement_vector()
	
	velocity.x = moveVector.x * maxHorizontalSpeed
	velocity.x += moveVector.x * horizontalAcceleration * delta
	
	if (moveVector.x == 0):
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
		
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)

	if (moveVector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || hasDoubleJumped)):
		velocity.y = moveVector.y * jumpForce
		if (!is_on_floor() && $CoyoteTimer.is_stopped()):
			$'/root/Helper'.apply_camera_shake(.75)
			hasDoubleJumped = false
		$CoyoteTimer.stop()

	if (velocity.y < 0 && !Input.is_action_pressed('jump')):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta

	var wasOnFloor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if (wasOnFloor && !is_on_floor()):
		$CoyoteTimer.start()

	if not wasOnFloor && is_on_floor() && not isStateNew:
		spawn_footsteps(1.5)

	if (is_on_floor()):
		hasDoubleJumped = true
		hasDashed = true

	if hasDashed && Input.is_action_just_pressed('dash'):
		call_deferred('change_state', State.DASHING)
		hasDashed = false

	update_animation()


func process_dashing(delta: float) -> void:
	if isStateNew:
		$DashAudioPlayer.play()
		$DashParticles.emitting = true
		$'/root/Helper'.apply_camera_shake(.75)
		$AnimatedSprite.play('jump')
		$DashArea/CollisionShape2D.disabled = false
		$HazardHitbox.collision_mask = dashHazardMask
		var movementVector = get_movement_vector()
		var velocityMod = 1
		if movementVector.x != 0:
			velocityMod = sign(movementVector.x)
		else:
			velocityMod = 1 if $AnimatedSprite.flip_h else -1 

		velocity = Vector2(maxDashSpeed * velocityMod, 0)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(0, velocity.x, pow(2, -8 * delta))

	if abs(velocity.x) < minDashSpeed:
		call_deferred('change_state', State.NORMAL)


func process_input_disabled(delta: float) -> void:
	if isStateNew:
		$AnimatedSprite.play('idle')
	velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func get_movement_vector() -> Vector2:
	var moveVector: Vector2 = Vector2.ZERO
	moveVector.x = Input.get_action_strength('move_right') - Input.get_action_strength('move_left')
	moveVector.y = -1 if Input.is_action_just_pressed('jump') else 0
	return moveVector


func update_animation() -> void:
	var moveVector: Vector2 = get_movement_vector()

	if (!is_on_floor()):
		$AnimatedSprite.play('jump')
	elif (moveVector.x != 0):
		$AnimatedSprite.play('run')
	else:
		$AnimatedSprite.play('idle')

	if (moveVector.x != 0):
		$AnimatedSprite.flip_h = true if moveVector.x > 0 else false

func kill() -> void:
	if not isAlive: return
	
	isAlive = false
	var playerDeathInstance = playerDeathScene.instance()
	playerDeathInstance.velocity = velocity
	get_parent().add_child_below_node(self, playerDeathInstance)
	playerDeathInstance.global_position= global_position
	emit_signal('died')


func spawn_footsteps(scale: int = 1) -> void:
	var footstep = footstepParticlesScene.instance()
	get_parent().add_child(footstep)
	footstep.scale = Vector2.ONE * scale
	footstep.global_position = global_position
	$FootstepAudioPlayer.play()


func disable_player_input() -> void:
	change_state(State.INPUT_DISABLED)


func on_hazard_area_entered(_area2d: Area2D) -> void:
	$'/root/Helper'.apply_camera_shake(1)
	call_deferred('kill')


func on_animated_sprite_frame_changed() -> void:
	if $AnimatedSprite.animation == 'run' && $AnimatedSprite.frame == 0:
		spawn_footsteps()
