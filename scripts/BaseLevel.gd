# Copyright Jessie's Game Studio 2022, All rights reserved.

extends Node

signal coin_total_changed

export var levelCompleteScene: PackedScene

var playerScene: PackedScene = preload('res://scenes/Player.tscn')
var pauseScene: PackedScene = preload('res://scenes/UI/PauseMenu.tscn')

var spawnPosition: Vector2 = Vector2.ZERO
var currentPlayerNode = null
var totalCoins: int = 0
var collectedCoins: int = 0

func _ready() -> void:
	spawnPosition = $PlayerRoot/Player.global_position
	register_player($PlayerRoot/Player)

	coin_total_changed(get_tree().get_nodes_in_group('coin').size())

	$Flag.connect('player_won', self, 'on_player_won')


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('pause'):
		var pauseInstance: Node = pauseScene.instance()
		add_child(pauseInstance)


func coin_collected() -> void:
	collectedCoins += 1
	emit_signal('coin_total_changed', totalCoins, collectedCoins)


func coin_total_changed(newTotal: int) -> void:
	totalCoins = newTotal
	emit_signal('coin_total_changed', totalCoins, collectedCoins)


func register_player(player: Node) -> void:
	currentPlayerNode = player
	currentPlayerNode.connect('died', self, 'on_player_died', [], CONNECT_DEFERRED)


func create_player() -> void:
	var playerInstance = playerScene.instance()
	$PlayerRoot.add_child(playerInstance)
	playerInstance.global_position = spawnPosition
	register_player(playerInstance)
	

func on_player_died() -> void:
	currentPlayerNode.queue_free()
	
	var timer = get_tree().create_timer(1.25)
	yield(timer, 'timeout')
	
	create_player()


func on_player_won() -> void:
	currentPlayerNode.disable_player_input()
	var levelComplete: Node = levelCompleteScene.instance()
	add_child(levelComplete)
