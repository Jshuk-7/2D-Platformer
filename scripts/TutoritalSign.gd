# Copyright Jessie's Game Studio 2022, All rights reserved.

extends Node2D

export (String, MULTILINE) var text

func _ready() -> void:
	$PanelContainer/MarginContainer/Label.text = text
	$PanelContainer.visible = false
	
	$Area2D.connect('area_entered', self, 'on_trigger_enter')
	$Area2D.connect('area_exited', self, 'on_trigger_exit')


func on_trigger_enter(area: Area2D) -> void:
	if area.get_parent() != get_tree().get_nodes_in_group('player')[0]: return
	else:
		$PanelContainer.visible = true
		$Sprite.frame = 1


func on_trigger_exit(area: Area2D) -> void:
	if get_tree().get_current_scene().get_name() == 'MainMenu': return
	if area.get_parent() != get_tree().get_nodes_in_group('player')[0]: return
	else:
		$PanelContainer.visible = false
		$Sprite.frame = 0
