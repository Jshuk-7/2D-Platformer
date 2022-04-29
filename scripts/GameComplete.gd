# Copyright Jessie's Game Studio 2022, All rights reserved.

extends CanvasLayer

onready var continueButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueButton

func _ready() -> void:
	continueButton.connect('pressed', self, 'on_continue_clicked')
	$'/root/LevelManager'.set_audio_stream(preload('res://audio/Kenny-Loggins-I_m-Free-_Heaven-Helps-The-Man__1.mp3'))
	$'/root/LevelManager'.play_music()


func on_continue_clicked() -> void:
	$'/root/ScreenTransitionManager'.transition_to_menu()
