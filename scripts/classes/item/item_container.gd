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

func get_slots() -> int:
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
			var new_slot = remainder.clone()
			new_slot.set_amount(inserted_amount+self.get_amount(slot))
			self._contents[slot] = new_slot
		
		# Calculate the remainder and if continue iteration if necessary
		remainder.delta_amount(-inserted_amount)
		if remainder.get_amount() <= 0:
			return ItemStack.EMPTY

	return remainder

func extract(item: ItemPrototype, amount: int, simulate: bool = false) -> ItemStack:
	return ItemStack.EMPTY

func extract_any(amount: int, simulate: bool = false) -> ItemStack:
	return ItemStack.EMPTY

func get_insertion_slots(item_in: ItemStack) -> Array[int]:
	"""
	If the item were to be inserted in the container, return the slot it could be inserted into, in order of preference
	Should not care about vacancy of the slot
	"""
	var available_slots: Array[int] = []
	for slot in self._contents.size():
		if not self.can_accept(item_in.get_prototype(), slot): continue
		available_slots.append(slot)
	return available_slots

func can_accept(item: ItemPrototype, slot: int) -> bool:
	"""Wether a slot can accept a particular item in any context, regardless of current state"""
	return true

func _to_string() -> String:
	return "ItemContainer<Slots: %s, Contents: %s>" % [self.get_slots(), self._contents ]
