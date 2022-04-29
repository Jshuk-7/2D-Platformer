# Copyright Jessie's Game Studio 2022, All rights reserved.

extends HBoxContainer

signal percentage_changed

var currentPercentage: float = 1.0

func _ready() -> void:
	$SubtractButton.connect('pressed', self, 'on_button_clicked', [-.1])
	$AdditionButton.connect('pressed', self, 'on_button_clicked', [.1])


func set_current_percentage(percent: float) -> void:
	currentPercentage = clamp(percent, 0, 1)
	
	var labelNumber: int = (currentPercentage * 10) as int
	labelNumber = round(labelNumber)
	
	$Label.text = str(labelNumber)
	emit_signal('percentage_changed', currentPercentage)


func on_button_clicked(change: float) -> void:
	set_current_percentage(currentPercentage + change)
