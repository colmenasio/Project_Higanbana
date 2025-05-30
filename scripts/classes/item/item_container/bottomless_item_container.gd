extends ItemContainer

func get_amount(slot: int):
	return 1

func set_slot(slot: int, stack: ItemStack) -> void:
	if self.at(slot).is_type_empty(): self._contents[slot] = stack.clone_and_set_amount(1)

func insert(item_in: ItemStack, max_items: int = 0, _simulate: bool = false) -> ItemStack:
	var slots = self.get_insertion_slots(item_in)
	if slots.size() == 0:
		return item_in.clone()
	else:
		if self.at(slots[0]).is_type_empty():
			self.set_slot(slots[0], item_in)
		return ItemStack.EMPTY

func insert_single_slot(slot: int, item_in: ItemStack, max_items: int = 0, _simulate: bool = false) -> ItemStack:
	var insertion_slots = self.get_insertion_slots(item_in)
	if not slot in insertion_slots:
		return item_in
	if self.at(slot).is_type_empty():
		self.set_slot(slot, item_in.clone_and_set_amount(1))
	return ItemStack.EMPTY

func extract(item_out: ItemPrototype, max_items: int = 0, simulate: bool = false) -> ItemStack:
	var stack_size: int = item_out.get_base_stack_size() if max_items == 0 else max_items
	var extracted_stack = item_out.stack(stack_size)
	for slot in self.slots():
		if self.at(slot).stacks_into(extracted_stack):
			return extracted_stack
	return ItemStack.EMPTY

func get_insertion_slots(item_in: ItemStack) -> Array[int]:
	var first_empty_slot = null
	for slot in self.slots():
		if not self.can_accept(item_in, slot): continue
		if item_in.stacks_into(self.at(slot)):
			if self.at(slot).is_type_empty() and first_empty_slot == null: 
				first_empty_slot = slot
			else: 
				return [slot]
	return [] if first_empty_slot == null else first_empty_slot

func can_accept(item_in: ItemStack, slot: int):
	return true

func _to_string() -> String:
	return "ItemContainer<Slots: %s, Contents: %s>" % [self.slots(), self._contents ]
