# Copyright Jessie's Game Studio 2022, All rights reserved.

extends Camera2D

var targetPosition: Vector2 = Vector2.ZERO

export(Color, RGB) var backgroundColor: Color
export(OpenSimplexNoise) var shakeNoise

var xNoiseSampleVector: Vector2 = Vector2.RIGHT
var yNoiseSampleVector: Vector2 = Vector2.DOWN
var xNoiseSamplePosition: Vector2 = Vector2.ZERO
var yNoiseSamplePosition: Vector2 = Vector2.ZERO
var noiseSampleTravelRate: int = 500
var maxShakeOffset: int = 10
var currentShakePercentage: float = 0
var shakeDecay: int = 3

func _ready() -> void:
	set_background_color()


func _process(delta: float) -> void:
	acquire_target_position()
	
	global_position = lerp(targetPosition, global_position, pow(2, -15 * delta))

	if currentShakePercentage > 0:
		xNoiseSamplePosition += xNoiseSampleVector * noiseSampleTravelRate * delta
		yNoiseSamplePosition += yNoiseSampleVector * noiseSampleTravelRate * delta
		var xSample = shakeNoise.get_noise_2d(xNoiseSamplePosition.x, xNoiseSamplePosition.y)
		var ySample = shakeNoise.get_noise_2d(yNoiseSamplePosition.x, yNoiseSamplePosition.y)

		var calculatedOffset: Vector2 = Vector2(xSample, ySample) * maxShakeOffset * pow(currentShakePercentage, 2)
		offset = calculatedOffset

		currentShakePercentage = clamp(currentShakePercentage - shakeDecay * delta, 0, 1)


func acquire_target_position() -> void:
	var accuired = get_target_position_from_node_group('player')
	if not accuired:
		get_target_position_from_node_group('player_death')


func get_target_position_from_node_group(groupName):
	var nodes: = get_tree().get_nodes_in_group(groupName)
	if nodes.size() > 0:
		var node = nodes[0]
		targetPosition = node.global_position
		current = true
		return true
	return false


func set_background_color() -> void:
	VisualServer.set_default_clear_color(backgroundColor)


func apply_shake(percentage: float) -> void:
	currentShakePercentage = clamp(currentShakePercentage + percentage, 0, 1)
