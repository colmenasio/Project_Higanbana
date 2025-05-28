extends Control

var _handle: ItemHandle
var _slots_displays: Array[ItemStackDisplay]

func initialize(handle: ItemHandle) -> void:
	self._handle = handle
	self._build_slots_displays()
	self.update_display()

func _process(_delta: float) -> void:
	self.update_display()
	print()

func _build_slots_displays() -> void:
	if not self._handle.is_valid(): 
		return
	var container = self._handle.container()
	for slot_index in container.slots():
		var display = UIFactory.new_item_stack_display()
		display.bind_callback(self._on_press.bind(slot_index))
		self._slots_displays.append(display)
		$MarginContainer/VBoxContainer/Slots.add_child(display)

func update_display():
	if not self._handle.is_valid(): 
		return
	var container = self._handle.container()
	for slot in container.slots():
		self._slots_displays[slot].display_stack(container.at(slot))

func is_valid() -> bool:
	return self._handle.is_valid()


func _on_press(type: CInteraction.Type, slot: int):
	if not self._handle.is_valid(): 
		return
	var container = self._handle.container()
	var mouse_item_slot = Game.get_player().get_mouse_item_slot()
	if Input.is_action_pressed("shift_mouse_l"):
		# Directly to inventory
		push_warning("Not Implemented")
	elif Input.is_action_pressed("shift_mouse_r"):
		# Take 1
		if container.at(slot).is_type_empty(): return
		var remainder = mouse_item_slot.insert(container.at(slot), 1)
		container.set_slot(slot, remainder)
	elif Input.is_action_pressed("mouse_l"):
		# Insert / take all
		if mouse_item_slot.at(0).is_type_empty():
			if container.at(slot).is_type_empty(): return
			var remainder = mouse_item_slot.insert(container.at(slot))
			container.set_slot(slot, remainder)
		else:
			var remainder = container.insert_single_slot(slot, mouse_item_slot.at(0))
			mouse_item_slot.set_slot(0, remainder)
	elif Input.is_action_pressed("mouse_r"):
		# Insert 1 /take half
		if mouse_item_slot.at(0).is_type_empty():
			if container.at(slot).is_type_empty(): return
			var remainder = mouse_item_slot.insert(container.at(slot), container.at(slot).get_amount()/2)
			container.set_slot(slot, remainder)
		else:
			var remainder = container.insert_single_slot(slot, mouse_item_slot.at(0), 1)
			mouse_item_slot.set_slot(0, remainder)
