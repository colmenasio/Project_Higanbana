@tool
extends Control
class_name ItemContainerDisplay

@export var allow_input: bool = true
@export var allow_output: bool = true

@export var title: String = "":
	set(value):
		if not self.is_node_ready(): await ready
		title = value
		$TitleContainer/Title.text = title
		if title == "":
			$TitleContainer.hide()

#@export_group("Conditional Settings", "title_down_padding")
@export var title_down_padding: int = 0:
	set(value):
		if not self.is_node_ready(): await ready
		title_down_padding = value
		$TitleContainer.add_theme_constant_override("margin_bottom", value)

var _handle: ItemHandle = ItemHandle.build_invalid()
var _slots_displays: Array[ItemStackDisplay]

func set_handle(handle: ItemHandle) -> void:
	self._handle = handle
	self._build_slots_displays()
	self.update_display()

func _process(_delta: float) -> void:
	self.update_display()

func _build_slots_displays() -> void:
	if not self._handle.is_valid(): 
		return
	var container = self._handle.container()
	for slot_index in container.slots():
		var display = UIFactory.new_item_stack_display()
		display.bind_callback(self._on_press.bind(slot_index))
		self._slots_displays.append(display)
		##$ScrollContainer/GridContainer.
		$ScrollContainer/GridContainer.add_child(display)

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
	if type == CInteraction.Type.SHIFT_LEFT:
		# Directly to inventory
		push_warning("Not Implemented")
	elif type == CInteraction.Type.SHIFT_RIGHT:
		# Take 1
		if not self.allow_output: return
		if container.at(slot).is_type_empty(): return
		var remainder = mouse_item_slot.insert(container.at(slot), 1)
		container.set_slot(slot, remainder)
	elif  type == CInteraction.Type.LEFT:
		# Insert / take all
		if mouse_item_slot.at(0).is_type_empty():
			if not self.allow_output: return
			if container.at(slot).is_type_empty(): return
			var remainder = mouse_item_slot.insert(container.at(slot))
			container.set_slot(slot, remainder)
		else:
			if not self.allow_input: return
			var remainder = container.insert_single_slot(slot, mouse_item_slot.at(0))
			mouse_item_slot.set_slot(0, remainder)
	elif  type == CInteraction.Type.RIGHT:
		# Insert 1 /take half
		if mouse_item_slot.at(0).is_type_empty():
			if container.at(slot).is_type_empty(): return
			if not self.allow_output: return
			var remainder = mouse_item_slot.insert(container.at(slot), int(container.at(slot).get_amount()/2))
			container.set_slot(slot, remainder)
		else:
			if not self.allow_input: return
			var remainder = container.insert_single_slot(slot, mouse_item_slot.at(0), 1)
			mouse_item_slot.set_slot(0, remainder)
