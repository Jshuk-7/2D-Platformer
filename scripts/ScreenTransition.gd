# Copyright Jessie's Game Studio 2022, All rights reserved.

extends CanvasLayer

signal screen_covered

func emit_screen_covered() -> void:
	emit_signal('screen_covered')
