extends StaticBody3D

@export var id: int = 0

func i_interact(command: CInteraction):
	print("Interacted machine with id: ", self.id, "; interaction type was ", command.get_type())
