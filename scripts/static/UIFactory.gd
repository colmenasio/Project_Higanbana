extends Object
class_name UIFactory

static var _item_stack_display = preload("res://ui/ItemStackDisplay/ItemStackDisplay.tscn")

static func new_item_stack_display() -> ItemStackDisplay:
	return UIFactory._item_stack_display.instantiate() 
