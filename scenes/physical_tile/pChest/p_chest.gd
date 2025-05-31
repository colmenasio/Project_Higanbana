extends PhysicalTile

@export var id: int = 0

var item_container: ItemContainer = ItemContainer.new(3, ItemType.T_SOLID)

func _open_ui(command: CInteraction):
	var ui_scene = preload("res://ui/ItemContainerDisplay/ItemContainerDisplay.tscn")
	var ui_instance = ui_scene.instantiate()
	
	ui_instance.set_handle(ItemHandle.new(self.item_container))
	command.get_canvas().set_entity_interaction_widget(ui_instance)
	

func interact(command: CInteraction):
	if command.get_type() == CInteraction.Type.LEFT:
		item_container.extract(SOLID.STONE_CHUNK, 2)
	if command.get_type() == CInteraction.Type.RIGHT:
		var item_stack = SOLID.WOOD_CHUNK.stack(15)
		item_container.insert(item_stack)
	if command.get_type() == CInteraction.Type.SHIFT_LEFT:
		item_container.extract_any(10)
	if command.get_type() == CInteraction.Type.SHIFT_RIGHT:
		self._open_ui(command)
		
