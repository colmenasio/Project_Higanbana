extends PlaceablePrototype
class_name BasicPlaceablePrototype

var _physical_tile_factory: PackedScene
var _logic_tile_factory: Callable

## Use example: [br]
## [code]BasicPlaceablePrototype.new(preload("res://scenes/pChest/p_chest.gd"), preload("res://scenes/pChest/p_chest_logic.gd"))[/code]
func _init(physical_tile_resource: PackedScene, logic_tile_resource: Callable) -> void:
	self._physical_tile_factory = physical_tile_resource
	self._logic_tile_factory = logic_tile_resource

func build_physical_tile() -> PhysicalTile:
	return self._physical_tile_factory.instantiate()

func build_logical_tile() -> LogicTile:
	return self._logic_tile_factory.call()
