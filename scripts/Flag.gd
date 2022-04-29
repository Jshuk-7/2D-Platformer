# Copyright Jessie's Game Studio 2022, All rights reserved.

extends Node2D

signal player_won

func _ready() -> void:
	$Area2D.connect('area_entered', self, 'on_area_entered')


func  on_area_entered(_area: Area2D) -> void:
	emit_signal('player_won')
	$Particles2D.emitting = true
	$AudioStreamPlayer.play()
	$RandomAudioStreamPlayer.play()
