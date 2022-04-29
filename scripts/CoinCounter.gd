# Copyright Jessie's Game Studio 2022, All rights reserved.

extends HBoxContainer

func _ready() -> void:
	var baseLevels = get_tree().get_nodes_in_group('base_level')

	if baseLevels.size() > 0:
		baseLevels[0].connect('coin_total_changed', self, 'on_coin_total_changed')
		update_display(baseLevels[0].totalCoins, baseLevels[0].collectedCoins)


func update_display(totalCoins: int, collectedCoins: int) -> void:
	$Label.text = str(collectedCoins, '/', totalCoins)


func on_coin_total_changed(totalCoins: int, collectedCoins: int) -> void:
	update_display(totalCoins, collectedCoins)
