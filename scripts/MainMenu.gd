# Copyright Jessie's Game Studio 2022, All rights reserved.

extends CanvasLayer

onready var playButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PlayButton
onready var optionsButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
onready var quitButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

var mainMenuMusic = preload('res://audio/How-It-Was-_feat.-Future_.mp3')

func _ready() -> void:
	playButton.connect('pressed', self, 'on_play_clicked')
	playButton.call_deferred('grab_focus')
	optionsButton.connect('pressed', self, 'on_options_clicked')
	quitButton.connect('pressed', self, 'on_quit_clicked')
	$'/root/LevelManager'.set_audio_stream(mainMenuMusic)
	$'/root/LevelManager'.play_music()


func on_play_clicked() -> void:
	$'/root/LevelManager'.change_level(0)


func on_options_clicked() -> void:
	$'/root/ScreenTransitionManager'.transition_to_scene('res://scenes/UI/OptionsMenuStandalone.tscn')


func on_quit_clicked() -> void:
	get_tree().quit()
