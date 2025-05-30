extends RefCounted

class_name ItemContainer
"""
Basic Item Container of a single type
"""

var _type: ItemType
var _contents: Array[ItemStack] = []
var _capacity_multiplier: int

func _init(slots_: int, type: ItemType, capacity_multiplier: int = 1) -> void:
	self._type = type
	self._contents.resize(slots_)
	self._contents.fill(ItemStack.EMPTY)
	self._capacity_multiplier = capacity_multiplier

func slots() -> int:
	return _contents.size()

func at(slot: int) -> ItemStack:
	return self._contents[slot]

func set_slot(slot: int, stack: ItemStack) -> void:
	self._contents[slot] = stack

func get_capacity(slot: int, base_capacity_if_empty: int = 20) -> int:
	var base_capacity = base_capacity_if_empty if self._contents[slot].is_type_empty() else self._contents[slot].get_base_stack_size()
	return base_capacity*self._capacity_multiplier

func get_amount(slot: int) -> int:
	return self._contents[slot].get_amount()

func get_headroom(slot: int, base_capacity_if_empty: int = 20) -> int:
	return self.get_capacity(slot, base_capacity_if_empty) - self.get_amount(slot)


## Insert ItemStack into container.[br]
## Will attempt to distribute items in multiple slots if necessary[br]
## The return value is the remainder that couldnt be inserter, or the EMPTY stack if nothing remained[br][br]
## [param max_items] specifies the maximum amount of items the container should accept. When its value is 0, the container will accept up to the whole ItemStack
func insert(item_in: ItemStack, max_items: int = 0, simulate: bool = false) -> ItemStack:
	assert(not item_in.is_type_empty(), "Interface error: Can not insert EMPTY stack into ItemContainer")
	# Returned stack
	var remainder = item_in.clone()
	# Effective size of the returned stack
	var eff_remainder_amount = remainder.get_amount() if max_items <= 0 else max_items
	
	for slot in get_insertion_slots(remainder):
		var headroom = self.get_headroom(slot, remainder.get_base_stack_size())
		if headroom <= 0: continue
		var inserted_amount = min(headroom, eff_remainder_amount)
		
		# If fr (not simulate), insert into the Container
		if not simulate:
			self._contents[slot] = remainder.clone_and_set_amount(self.get_amount(slot)+inserted_amount)
		
		# Calculate the remainder and if continue iteration if necessary
		remainder.delta_amount(-inserted_amount)
		eff_remainder_amount -= inserted_amount
		if remainder.get_amount() <= 0: return ItemStack.EMPTY # If remainder is empty, return the EMPTY stack
		if eff_remainder_amount <= 0: return remainder # If the effective remainder amount is 0, no more items can be inserted

	return remainder

## Insert ItemStack into a single slot.[br]
## Will not attempt to distribute items outside the given slot [br]
## The return value is the remainder that couldnt be inserted, or the EMPTY stack if nothing remained[br][br]
## [param max_items] specifies the maximum amount of items the container should accept. When its value is 0, the container will accept up to the whole ItemStack
func insert_single_slot(slot: int, item_in: ItemStack, max_items: int = 0, simulate: bool = false) -> ItemStack:
	assert(not item_in.is_type_empty(), "Interface error: Can not insert EMPTY stack into ItemContainer")
	# Returned stack
	var remainder = item_in.clone()
	# Effective size of the returned stack
	var eff_remainder_amount = remainder.get_amount() if max_items <= 0 else max_items
	
	if get_insertion_slots(remainder).has(slot):
		var headroom = self.get_headroom(slot, remainder.get_base_stack_size())
		if headroom <= 0: return remainder
		var inserted_amount = min(headroom, eff_remainder_amount)
		
		# If fr (not simulate), insert into the Container
		if not simulate:
			self.set_slot(slot, remainder.clone_and_set_amount(self.get_amount(slot)+inserted_amount))
		
		# Calculate the remainder and if continue iteration if necessary
		remainder.delta_amount(-inserted_amount)
		if remainder.get_amount() <= 0: return ItemStack.EMPTY # If remainder is empty, return the EMPTY stack

	return remainder

## Extract ItemStack from container.
## Will attempt to extract up to the indicated amount of items of the specified ItemPrototype
## The return value is the extracted stack, or the EMPTY stack if nothing can be extracted 
## [param max_items] specifies the maximum amount of items the container should accept. When its value is 0, the container will extract as much as possible
func extract(item_out: ItemPrototype, max_items: int = 0, simulate: bool = false) -> ItemStack:
	var extracted_stack = item_out.stack(0)
	for slot in self.slots():
		if self.at(slot).stacks_into(extracted_stack):
			var extracted_amount = self.at(slot).get_amount()
			if max_items > 0: # Cap the extracted amount
				extracted_amount = min(max_items-extracted_stack.get_amount(), extracted_amount)
			print(extracted_amount, " out of a max of ", max_items)
			extracted_stack.delta_amount(extracted_amount)
			if not simulate: self.at(slot).delta_amount(-extracted_amount)
			if self.at(slot).get_amount() <= 0: self._contents[slot] = ItemStack.EMPTY
			if extracted_stack.get_amount() == max_items: return extracted_stack
	return extracted_stack if extracted_stack.get_amount() != 0 else ItemStack.EMPTY

## Extract ItemStack from container.
## Will attempt to extract up to the indicated amount of items of any arbitrary ItemPrototype
## The return value is the extracted stack, or the EMPTY stack if nothing can be extracted 
## [param max_items] specifies the maximum amount of items the container should accept. When its value is 0, the container will extract es much as possible
func extract_any(max_items: int = 0, simulate: bool = false) -> ItemStack:
	for stack in self._contents:
		if not stack.is_type_empty():
			return self.extract(stack.get_prototype(), max_items, simulate)
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

func can_accept(_item: ItemPrototype, _slot: int) -> bool:
	"""Wether a slot can accept a particular item in any context, regardless of current state"""
	return true

func as_handle() -> ItemHandle:
	return ItemHandle.new(self)

func _to_string() -> String:
	return "ItemContainer<Slots: %s, Contents: %s>" % [self.slots(), self._contents ]
