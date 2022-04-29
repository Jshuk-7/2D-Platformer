# Copyright Jessie's Game Studio 2022, All rights reserved.

extends CanvasLayer

onready var resumeButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
onready var optionsButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
onready var quitButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

var optionsMenuScene: PackedScene = preload('res://scenes/UI/OptionsMenu.tscn')

func _ready() -> void:
	resumeButton.connect('pressed', self, 'on_resume_clicked')
	resumeButton.call_deferred('grab_focus')
	optionsButton.connect('pressed', self, 'on_options_clicked')
	quitButton.connect('pressed', self, 'on_quit_clicked')
	get_tree().paused = true


func _process(delta: float) -> void:
	$'/root/MouseCursor'.update_cursor_position()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('pause'):
		unpause()
		get_tree().set_input_as_handled()


func unpause() -> void:
	queue_free()
	get_tree().paused = false


func on_resume_clicked() -> void:
	unpause()


func on_options_clicked() -> void:
	var optionsMenuInstance: Node = optionsMenuScene.instance()
	add_child(optionsMenuInstance)
	optionsMenuInstance.connect('back_pressed', self, 'on_options_back_clicked')
	$MarginContainer.visible = false


func on_quit_clicked() -> void:
	for _sign in get_tree().get_nodes_in_group('tutorial_sign'):
		_sign.free()

	$'/root/ScreenTransitionManager'.transition_to_menu()
	unpause()


func on_options_back_clicked() -> void:
	$OptionsMenu.queue_free()
	$MarginContainer.visible = true
	resumeButton.call_deferred('grab_focus')
