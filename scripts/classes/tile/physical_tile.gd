extends PhysicsBody3D
## Abstract parent class for all LogicTiles [br][br]
## Represents the Physical part of a tile, includes mesh and collision [br]
## Responsible for interaction logic. [br]
## Can implement simple interaction logic, but most of the time this logic will be delegated to its corresponding logic_tile
class_name PhysicalTile

var _grid_pos: Vector3i

## Meant to be called by the engine on instanciation
func _tile_init(grid_pos: Vector3i):
	self._grid_pos = grid_pos 

func get_grid_pos() -> Vector3i:
	return self._grid_pos

func interact(_command: CInteraction):
	pass

func on_place():
	pass
