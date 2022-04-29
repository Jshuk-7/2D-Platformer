# Copyright Jessie's Game Studio 2022, All rights reserved.

extends Position2D

enum Direction { RIGHT, LEFT }

export (PackedScene) var enemyScene
export (Direction) var startDirection

var currentEnemyNode: Node = null
var spawnOnNextFrame: bool = false

func _ready() -> void:
	$SpawnTimer.connect('timeout', self, 'on_spawn_timer_timeout')
	call_deferred('spawn_enemy')


func spawn_enemy() -> void:
	currentEnemyNode = enemyScene.instance()
	currentEnemyNode.startDirection = Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT
	get_parent().add_child(currentEnemyNode)
	currentEnemyNode.global_position = global_position


func check_enemy_spawn() -> void:
	if not is_instance_valid(currentEnemyNode):
		if spawnOnNextFrame:
			spawn_enemy()
			spawnOnNextFrame = false
		else:
			spawnOnNextFrame = true


func on_spawn_timer_timeout() -> void:
	check_enemy_spawn()
