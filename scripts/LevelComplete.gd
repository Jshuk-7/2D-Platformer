# Copyright Jessie's Game Studio 2022, All rights reserved.

extends CanvasLayer

func _ready() -> void:
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/NextLevelButton.connect('pressed', self, 'on_next_level_clicked')
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/RestartButton.connect('pressed', self, 'on_restart_clicked')


func on_next_level_clicked() -> void:
	$'/root/LevelManager'.increment_level()


func on_restart_clicked() -> void:
	$'/root/LevelManager'.restart_level()
