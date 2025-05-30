extends ItemStack
class_name  EmptyItemStack

func set_amount(_amount_: int) -> void:
	assert(false, "Attempted to modify EMPTY ItemStack")

func delta_amount(_delta: int) -> void:
	assert(false, "Attempted to modify EMPTY ItemStack")

func stacks_into(_other: ItemStack) -> bool:
	return false

func clone() -> ItemStack:
	return self

func is_type_empty() -> bool :
	return true
