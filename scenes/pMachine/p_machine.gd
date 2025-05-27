extends StaticBody3D

@export var id: int = 0

var item_container: ItemContainer = ItemContainer.new(3, ItemType.SOLID)

func _on_button_pressed(command: CInteraction):
	var ui_scene = preload("res://ui/dItemContainerDisplay/dItemContainerDisplay.tscn")
	var ui_instance = ui_scene.instantiate()
	ui_instance.initialize(ItemHandle.new(self.item_container))
	command._canvas.add_transient(ui_instance)


func i_interact(command: CInteraction):
	print("Interacted machine with id: ", self.id, "; interaction type was ", command.get_type())
	if command.get_type() == CInteraction.Type.LEFT:
		var extracted = item_container.extract(SOLID.STONE_CHUNK, 2)
		print(item_container)
		print("extracted ", extracted)	
	if command.get_type() == CInteraction.Type.RIGHT:
		var item_stack = SOLID.WOOD_CHUNK.stack(15)
		var remainder = item_container.insert(item_stack)
		print(item_container)
		print("remainder ", remainder)
	if command.get_type() == CInteraction.Type.SHIFT_LEFT:
		var extracted = item_container.extract_any(10)
		print(item_container)
		print("extracted any ", extracted)
	if command.get_type() == CInteraction.Type.SHIFT_RIGHT:
		self._on_button_pressed(command)
		
