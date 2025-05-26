extends StaticBody3D

@export var id: int = 0

var item_container: ItemContainer = ItemContainer.new(3, ItemType.SOLID)

func i_interact(command: CInteraction):
	print("Interacted machine with id: ", self.id, "; interaction type was ", command.get_type())
	if command.get_type() == CInteraction.Type.RIGHT:
		var item_stack = SOLID.WOOD_CHUNK.stack(15)
		var remainder = item_container.insert(item_stack)
		print(item_container)
		print("remainder ", remainder)
