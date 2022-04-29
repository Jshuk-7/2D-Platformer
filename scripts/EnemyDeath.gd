# Copyright Jessie's Game Studio 2022, All rights reserved.

extends Node2D

func _ready() -> void:
	$DeathSoundPlayer1.play()
	$DeathSoundPlayer2.play()
