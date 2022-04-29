# Copyright Jessie's Game Studio 2022, All rights reserved.

extends CanvasLayer

signal back_pressed

onready var backButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BackButton
onready var windowModeButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WindowModeButton
onready var musicRangeControl = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MusicVolumeContainer/RangeControl
onready var sfxRangeControl = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/SFXVolumeContainer/RangeControl

var fullscreen: bool = false

func _ready() -> void:
	windowModeButton.connect('pressed', self, 'on_window_mode_clicked')
	windowModeButton.call_deferred('grab_focus')
	backButton.connect('pressed', self, 'on_back_clicked')
	musicRangeControl.connect('percentage_changed', self, 'on_music_volume_changed')
	sfxRangeControl.connect('percentage_changed', self, 'on_sfx_volume_changed')
	update_display()
	update_initial_volume_settings()


func update_display() -> void:
	windowModeButton.text = 'WINDOWED' if !fullscreen else 'FULLSCREEN'


func update_bus_volume(busName: String, volumePercent: float) -> void:
	var busIdx = AudioServer.get_bus_index(busName)
	var volumeDb = linear2db(volumePercent)
	AudioServer.set_bus_volume_db(busIdx, volumeDb)


func get_bus_volume_percent(busName: String) -> float:
	var busIdx = AudioServer.get_bus_index(busName)
	var volumePercent = db2linear(AudioServer.get_bus_volume_db(busIdx))
	return volumePercent


func update_initial_volume_settings() -> void:
	var musicPercent = get_bus_volume_percent('Music')
	musicRangeControl.set_current_percentage(musicPercent)
	
	var sfxPercent = get_bus_volume_percent('SFX')
	sfxRangeControl.set_current_percentage(sfxPercent)


func on_window_mode_clicked() -> void:
	fullscreen = !fullscreen
	OS.window_fullscreen = fullscreen
	update_display()


func on_back_clicked() -> void:
	emit_signal('back_pressed')


func on_music_volume_changed(percent: float) -> void:
	update_bus_volume('Music', percent)	


func on_sfx_volume_changed(percent: float) -> void:
	update_bus_volume('SFX', percent)
