# Copyright Jessie's Game Studio 2022, All rights reserved.

extends KinematicBody2D

var enemyDeathScene = preload('res://scenes/EnemyDeath.tscn')

export var isSpawning: bool = true
var maxSpeed: float = 25
var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var gravity: float = 500
var startDirection: Vector2 = Vector2.RIGHT

func _ready():
	direction = startDirection
	$GoalDetector.connect('area_entered', self, 'on_goal_entered')
	$HitboxArea.connect('area_entered', self, 'on_hitbox_entered')


func _process(delta: float) -> void:
	if isSpawning: return
	
	velocity.x = (direction * maxSpeed).x
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

	$Visuals/AnimatedSprite.flip_h = true if direction.x > 0 else false


func kill() -> void:
	var deathInsatnce = enemyDeathScene.instance()
	get_parent().add_child(deathInsatnce)
	deathInsatnce.global_position = global_position
	if velocity.x > 0:
		deathInsatnce.scale = Vector2(-1, 1)
	queue_free()


func on_goal_entered(_area: Area2D) -> void:
	direction *= -1


func on_hitbox_entered(_area: Area2D) -> void:
	$'/root/Helper'.apply_camera_shake(1)
	call_deferred('kill')
