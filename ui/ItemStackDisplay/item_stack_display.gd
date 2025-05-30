extends Control
class_name ItemStackDisplay

@export var clickable: bool = true:
	## [param value]: [code]false[/code] disables the button-like behaviour. On the contrary, [code]true[/code] enables button-like behaviour
	set(value):
		if !is_node_ready(): await ready
		$TextureButton.disabled = not value;
		$TextureButton.mouse_filter = MOUSE_FILTER_STOP if value else MOUSE_FILTER_IGNORE
		self.mouse_filter = MOUSE_FILTER_STOP if value else MOUSE_FILTER_IGNORE
	get():
		return not $TextureButton.disabled

func display_stack(stack: ItemStack):
	$TextureButton.texture_normal = stack.get_prototype()._base_texture
	$TextureButton.texture_hover = load("res://assets/item/EmptyStack.png")
	$Amount.text = "" if stack.get_amount() in [0, 1] else String.num_int64(stack.get_amount())

## [param callback] must take a single argument of type CInteraction.Type
func bind_callback(callback: Callable):
	$TextureButton.interaction_triggered.connect(callback)

## [param value]: [code]false[/code] disables the button-like behaviour. On the contrary, [code]true[/code] enables button-like behaviour
func apdmaowdmset_clickable(value: bool):
	$TextureButton.disabled = not value
