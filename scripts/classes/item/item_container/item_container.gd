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

## Given a series of slots in order of preference, try to insert the given itemstack into the container [br]
## Returns the remainder of the insertion [br]
## [param slots] is a [code]Array[int][/code] [br]
## ASSUMES SLOTS ARE VALID AND HAVE BEEN CHECKED  [br] [br]
func _insert( _slots: Array ,item_in: ItemStack,simulate: bool = false):
	assert(not item_in.is_type_empty(), "Interface error: Can not insert EMPTY stack into ItemContainer")
	# Returned stack
	var remainder = item_in.clone()
	
	for slot in _slots:
		var headroom = self.get_headroom(slot, remainder.get_base_stack_size())
		if headroom <= 0: continue
		var inserted_amount = min(headroom, remainder.get_amount())
		
		# If fr (not simulate), insert into the Container
		if not simulate:
			self._contents[slot] = remainder.clone_and_set_amount(self.get_amount(slot)+inserted_amount)
		
		# Calculate the remainder and if continue iteration if necessary
		remainder.delta_amount(-inserted_amount)
		if remainder.get_amount() <= 0: return ItemStack.EMPTY # If remainder is empty, return the EMPTY stack

	return remainder

## Insert ItemStack into container.[br]
## Will attempt to distribute items in multiple slots if necessary[br]
## The return value is the remainder that couldnt be inserter, or the EMPTY stack if nothing remained[br][br]
func insert(item_in: ItemStack, simulate: bool = false) -> ItemStack:
	return self._insert(self.get_insertion_slots(item_in), item_in, simulate)

## Insert ItemStack into a single slot.[br]
## Will not attempt to distribute items outside the given slot [br]
## The return value is the remainder that couldnt be inserted, or the EMPTY stack if nothing remained[br][br]
func insert_single_slot(slot: int, item_in: ItemStack , simulate: bool = false) -> ItemStack:
	if slot in self.get_insertion_slots(item_in):
		return self._insert([slot], item_in, simulate)
	else:
		return item_in.clone()

## Given a series of slots in order of preference, try to insert the given itemstack into the container [br]
## Returns the remainder of the insertion [br]
## [param slots] is a [code]Array[int][/code] [br][br]
func _extract(_slots: Array, item_out: ItemPrototype, max_items: int = 0, simulate: bool = false) -> ItemStack:
	var extracted_stack = item_out.stack(0)
	for slot in _slots:
		if self.at(slot).stacks_into(extracted_stack):
			var extracted_amount = self.at(slot).get_amount()
			if max_items > 0: # Cap the extracted amount
				extracted_amount = min(max_items-extracted_stack.get_amount(), extracted_amount)
			extracted_stack.delta_amount(extracted_amount)
			if not simulate: self.at(slot).delta_amount(-extracted_amount)
			if self.at(slot).get_amount() <= 0: self._contents[slot] = ItemStack.EMPTY
			if extracted_stack.get_amount() == max_items: return extracted_stack
	return extracted_stack if extracted_stack.get_amount() != 0 else ItemStack.EMPTY

## Extract ItemStack from container.
## Will attempt to extract up to the indicated amount of items of the specified ItemPrototype
## The return value is the extracted stack, or the EMPTY stack if nothing can be extracted 
## [param max_items] specifies the maximum amount of items the container should accept. When its value is 0, the container will extract as much as possible
func extract(item_out: ItemPrototype, max_items: int = 0, simulate: bool = false) -> ItemStack:
	return self._extract(range(self.slots()), item_out, max_items, simulate)

## Extract ItemStack from container.
## Will attempt to extract up to the indicated amount of items of any arbitrary ItemPrototype
## The return value is the extracted stack, or the EMPTY stack if nothing can be extracted 
## [param max_items] specifies the maximum amount of items the container should accept. When its value is 0, the container will extract es much as possible
func extract_any(max_items: int = 0, simulate: bool = false) -> ItemStack:
	for stack in self._contents:
		if not stack.is_type_empty():
			return self._extract(range(self.slots()), stack.get_prototype(), max_items, simulate)
	return ItemStack.EMPTY

## Extract ItemStack from the slot specified.
## Will attempt to extract up to the indicated amount of items of the specified ItemPrototype
## The return value is the extracted stack, or the EMPTY stack if nothing can be extracted 
## [param max_items] specifies the maximum amount of items the container should accept. When its value is 0, the container will extract as much as possible
func extract_single_slot(slot: int, item_out: ItemPrototype, max_items: int = 0, simulate: bool = false) -> ItemStack:
	return self._extract([slot], item_out, max_items, simulate)

## Extract ItemStack from the slot specified.
## Will attempt to extract up to the indicated amount of items of any arbitrary ItemPrototype
## The return value is the extracted stack, or the EMPTY stack if nothing can be extracted 
## [param max_items] specifies the maximum amount of items the container should accept. When its value is 0, the container will extract es much as possible
func extract_any_single_slot(slot: int, max_items: int = 0, simulate: bool = false) -> ItemStack:
	if self.at(slot).is_type_empty():
		return ItemStack.EMPTY
	else:
		return self._extract([slot], self.at(slot).get_prototype(), max_items, simulate)
	
## If the item were to be inserted in the container, return the slot it could be inserted into, in order of preference
## Should not care about vacancy of the slot
func get_insertion_slots(item_in: ItemStack) -> Array[int]:
	var available_slots: Array[int] = []
	var empty_slots: Array[int] = []
	for slot in self.slots():
		if not self.can_accept(item_in, slot): continue
		if item_in.stacks_into(self.at(slot)):
			if self.at(slot).is_type_empty(): 
				empty_slots.append(slot)
			else: 
				available_slots.append(slot)
	available_slots.append_array(empty_slots) # Note doing it this way is necessary since slots already occupied are of higher preference
	return available_slots

func can_accept(_item: ItemStack, _slot: int) -> bool:
	"""Wether a slot can accept a particular item in any context, regardless of current state"""
	return true

func as_handle() -> ItemHandle:
	return ItemHandle.new(self)

func _to_string() -> String:
	return "ItemContainer<Slots: %s, Contents: %s>" % [self.slots(), self._contents ]
