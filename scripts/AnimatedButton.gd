# Copyright Jessie's Game Studio 2022, All rights reserved.

extends Button

export var disableHoverAnim: bool

func _ready() -> void:
	connect('mouse_entered', self, 'on_mouse_entered')
	connect('mouse_exited', self, 'on_mouse_exited')
	connect('focus_exited', self, 'on_focus_exited')
	connect('pressed', self, 'on_button_clicked')
	

func _process(_delta: float) -> void:
	rect_pivot_offset = rect_min_size / 2


func reset_button_state() -> void:
	if not disableHoverAnim:
		$HoverAnimationPlayer.play_backwards('hover')


func on_mouse_entered() -> void:
	if not disableHoverAnim:
		$HoverAnimationPlayer.play('hover')
	
	
func on_mouse_exited() -> void:
	reset_button_state()


func on_button_clicked() -> void:
	$AudioStreamPlayer.play()
	$ClickAnimationPlayer.play('click')


func on_focus_exited() -> void:
	reset_button_state()
