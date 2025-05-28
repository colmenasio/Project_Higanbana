extends TextureButton

signal interaction_triggered(type: CInteraction.Type)

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("shift_mouse_l"):
		interaction_triggered.emit(CInteraction.Type.SHIFT_LEFT)
	elif event.is_action_pressed("shift_mouse_r"):
		interaction_triggered.emit(CInteraction.Type.SHIFT_RIGHT)
	elif event.is_action_pressed("mouse_l"):
		interaction_triggered.emit(CInteraction.Type.LEFT)
	elif event.is_action_pressed("mouse_r"):
		interaction_triggered.emit(CInteraction.Type.RIGHT)
	else:
		return
