extends RefCounted

class_name ItemContainer
"""
Basic Item Container of a single type
"""

var _type: ItemType
var _contents: Array[ItemStack] = []
var _capacity_multiplier: int

func _init(slots: int, type: ItemType, capacity_multiplier: int = 1) -> void:
	self._type = type
	self._contents.resize(slots)
	self._contents.fill(ItemStack.EMPTY)
	self._capacity_multiplier = capacity_multiplier

func slots() -> int:
	return _contents.size()

func at(slot: int) -> ItemStack:
	return self._contents[slot]

func get_capacity(slot: int, base_capacity_if_empty: int = 20) -> int:
	var base_capacity = base_capacity_if_empty if self._contents[slot].is_type_empty() else self._contents[slot].get_base_stack_size()
	return base_capacity*self._capacity_multiplier

func get_amount(slot: int) -> int:
	return self._contents[slot].get_amount()

func get_headroom(slot: int, base_capacity_if_empty: int = 20) -> int:
	return self.get_capacity(slot, base_capacity_if_empty) - self.get_amount(slot)

func insert(item_in: ItemStack, simulate: bool = false) -> ItemStack:
	"""
	Insert ItemStack into container.
	Will attempt to distribute items in multiple slots if necessary
	The return value is the remainder that couldnt be inserter, or the EMPTY stack if nothing remained 
	"""
	assert(not item_in.is_type_empty(), "Interface error: Can not insert EMPTY stack into ItemContainer")
	var remainder = item_in.clone()
	for slot in get_insertion_slots(remainder):
		var headroom = self.get_headroom(slot, remainder.get_base_stack_size())
		if headroom <= 0: continue
		var inserted_amount = min(headroom, remainder.get_amount())
		
		# If fr (not simulate), insert into the Container
		if not simulate:
			self._contents[slot] = remainder.clone_and_set_amount(self.get_amount(slot)+inserted_amount)
		
		# Calculate the remainder and if continue iteration if necessary
		remainder.delta_amount(-inserted_amount)
		if remainder.get_amount() <= 0: return ItemStack.EMPTY

	return remainder

func extract(item_out: ItemPrototype, amount: int, simulate: bool = false) -> ItemStack:
	"""
	Extract ItemStack from container.
	Will attempt to extract up to the indicated amount of items of the specified ItemPrototype
	The return value is the extracted stack, or the EMPTY stack if nothing can be extracted 
	"""
	var extracted_stack = item_out.stack(0)
	for slot in self.slots():
		if self.at(slot).stacks_into(extracted_stack):
			var extracted_amount = min(amount-extracted_stack.get_amount(), self.at(slot).get_amount())
			extracted_stack.delta_amount(extracted_amount)
			self.at(slot).delta_amount(-extracted_amount)
			if self.at(slot).get_amount() <= 0: self._contents[slot] = ItemStack.EMPTY
			if extracted_stack.get_amount() == amount: return extracted_stack
	return extracted_stack if extracted_stack.get_amount() != 0 else ItemStack.EMPTY

func extract_any(amount: int, simulate: bool = false) -> ItemStack:
	"""
	Extract ItemStack from container.
	Will attempt to extract up to the indicated amount of items of any arbitrary ItemPrototype
	The return value is the extracted stack, or the EMPTY stack if nothing can be extracted 
	"""
	for stack in self._contents:
		if not stack.is_type_empty():
			return self.extract(stack.get_prototype(), amount, simulate)
	return ItemStack.EMPTY

func get_insertion_slots(item_in: ItemStack) -> Array[int]:
	"""
	If the item were to be inserted in the container, return the slot it could be inserted into, in order of preference
	Should not care about vacancy of the slot
	"""
	var available_slots: Array[int] = []
	for slot in self.slots():
		if not self.can_accept(item_in.get_prototype(), slot): continue
		if item_in.stacks_into(self.at(slot)):
			available_slots.append(slot)
	return available_slots

func can_accept(item: ItemPrototype, slot: int) -> bool:
	"""Wether a slot can accept a particular item in any context, regardless of current state"""
	return true

func _to_string() -> String:
	return "ItemContainer<Slots: %s, Contents: %s>" % [self.slots(), self._contents ]
