extends Control

func set_input(handle: ItemHandle):
	$HBoxContainer/InputDisplay.set_handle(handle)

func set_output(handle: ItemHandle):
	$HBoxContainer/OutputDisplay.set_handle(handle)
	
func is_valid():
	return $HBoxContainer/InputDisplay.is_valid() and $HBoxContainer/OutputDisplay.is_valid()
