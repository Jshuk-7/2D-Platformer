# Copyright Jessie's Game Studio 2022, All rights reserved.

extends Node2D

func _ready() -> void:
	$Area2D.connect('area_entered', self, 'on_coin_area_entered')

func on_coin_area_entered(area: Area2D) -> void:
	if area.get_parent() != get_tree().get_nodes_in_group('player')[0]: return
	else:
		$AnimationPlayer.play('pickup')
		$RandomAudioStreamPlayer.play()
		$RandomAudioStreamPlayer2.play()
		call_deferred('disable_pickup')

	var baseLevel = get_tree().get_nodes_in_group('base_level')[0]
	baseLevel.coin_collected()
	
func disable_pickup() -> void:
	$Area2D/CollisionShape2D.disabled = true
