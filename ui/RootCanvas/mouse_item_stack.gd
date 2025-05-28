extends Control

func _process(_delta: float) -> void:
	self.position = get_viewport().get_mouse_position()
	$ItemStackDisplay.display_stack(Game._player.get_mouse_item_slot().at(0))
