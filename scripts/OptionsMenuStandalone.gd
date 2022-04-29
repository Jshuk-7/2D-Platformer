# Copyright Jessie's Game Studio 2022, All rights reserved.

extends CanvasLayer

func _ready() -> void:
	$OptionsMenu.connect('back_pressed', self, 'on_back_clicked')


func on_back_clicked() -> void:
	$'/root/ScreenTransitionManager'.transition_to_menu()
