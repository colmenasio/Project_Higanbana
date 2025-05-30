extends Object
class_name ItemPrototype

var _base_name: String
var _base_repr: StringName
var _base_desc: String
var _base_type: ItemType
var _base_stack_size: int
var _base_texture: Texture
var _placeable_prototype = null

func _init(base_name: String, base_repr: StringName, base_type: ItemType, base_description: String, base_stack_size: int, base_texture: Texture):
	self._base_name = base_name
	self._base_repr = base_repr
	self._base_type = base_type
	self._base_desc = base_description
	self._base_stack_size = base_stack_size
	self._base_texture = base_texture
	return 

func stack(amount: int = 0) -> ItemStack:
	var product = ItemStack.new(self, amount)
	return product

func get_base_stack_size() -> int:
	return self._base_stack_size

func set_placeable_prototype(value: PlaceablePrototype)->void:
	self._placeable_prototype = value

func get_placeable_prototype()->PlaceablePrototype:
	return self._placeable_prototype
