extends PanelContainer

## TODO Add support for tabs
## For now only a single tab and therefore a single catalogue is supported
## Also im realizing this shit might be useful for more than only bottomless catalogue
func add_tab(tab_name: String, handle: ItemHandle):
	$MarginContainer/VBoxContainer2.set_handle(handle)

## TODO REMOVE THIS FUNCTION, ITS ONLY HERE AS A PATCH FOR DEBUG
func is_valid() -> bool:
	return true 
