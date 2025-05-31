extends ItemContainer
class_name BottomlessItemContainer

func get_amount(_slot: int):
	return 1

func set_slot(slot: int, stack: ItemStack) -> void:
	if self.at(slot).is_type_empty(): self._contents[slot] = stack.clone_and_set_amount(1)

func _insert(_slots: Array, item_in: ItemStack, _simulate: bool = false):
	# If can insert, insert
	if _slots.size() == 0:
		return item_in.clone()
	else:
		if self.at(_slots[0]).is_type_empty():
			self.set_slot(_slots[0], item_in)
		return ItemStack.EMPTY

func _extract(_slots: Array, item_out: ItemPrototype, max_amount: int = 0, _simulate: bool = false):
	var stack_size: int = item_out.get_base_stack_size() if max_amount == 0 else max_amount
	var extracted_stack = item_out.stack(stack_size)
	for slot in _slots:
		if self.at(slot).stacks_into(extracted_stack):
			return extracted_stack
	return ItemStack.EMPTY

func can_accept(_item_in: ItemStack, _slot: int):
	return true

func _to_string() -> String:
	return "ItemContainer<Slots: %s, Contents: %s>" % [self.slots(), self._contents ]
