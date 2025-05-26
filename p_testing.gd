extends Node3D

func _ready() -> void:
	print("RUN-ONCE TESTS:")
	var empty_stack = ItemStack.EMPTY
	var solid_stack = SOLID.WOOD_CHUNK.stack(10)
	var fluid_stack = FLUID.WATER.stack(15)
	print("Stack examples:")
	print(empty_stack.repr())
	print(solid_stack.repr())
	print(fluid_stack.repr())
