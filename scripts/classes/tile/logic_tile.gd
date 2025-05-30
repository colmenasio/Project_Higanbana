extends RefCounted

## Abstract parent class for all LogicTiles [br][br]
## Pure code tile, represents the logic part of a tile, and is responsible for ticking, capabilities, etc... [br]
## Note that an LogicTile MUST
class_name LogicTile

var _grid_pos: Vector3i

## Meant to be called by the engine on instanciation
func _tile_init(grid_pos: Vector3i):
	self._grid_pos = grid_pos 

func tick()->void:
	pass

# Get capabilities,serialize, etc...
