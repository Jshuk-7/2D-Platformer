# Copyright Jessie's Game Studio 2022, All rights reserved.

extends Node

func apply_camera_shake(percentage: float) -> void:
	var cameras = get_tree().get_nodes_in_group('camera')
	if cameras.size() > 0:
		cameras[0].apply_shake(percentage)
