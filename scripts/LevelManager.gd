# Copyright Jessie's Game Studio 2022, All rights reserved.

extends Node

export (Array, PackedScene) var levelScenes
export (Array, AudioStreamMP3) var ambiancePlaylist

var currentLevelIndex: int = 0

func change_level(level: int) -> void:
	currentLevelIndex = level
	if currentLevelIndex >= levelScenes.size():
		$'/root/ScreenTransitionManager'.transition_to_scene('res://scenes/UI/GameComplete.tscn')
		stop_music()
		return
	else:
		$'/root/ScreenTransitionManager'.transition_to_scene(levelScenes[currentLevelIndex].resource_path)
	change_music(currentLevelIndex)


func increment_level() -> void:
	change_level(currentLevelIndex + 1)


func play_music() -> void:
	$AudioStreamPlayer.play()


func set_audio_stream(path: Object) -> void:
	$AudioStreamPlayer.stream = path


func change_music(index: int) -> void:
	$AudioStreamPlayer.stream = ambiancePlaylist[index]
	$AudioStreamPlayer.play()


func stop_music() -> void:
	$AudioStreamPlayer.stop()


func restart_level() -> void:
	change_level(currentLevelIndex)
