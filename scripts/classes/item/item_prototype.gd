extends Object
class_name ItemPrototype

var _base_name: String
var _base_repr: StringName
var _base_desc: String
var _base_type: ItemType
var _base_stack_size: int
var _base_texture: Texture

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

static func create_placeholder(base_name: String, item_type) -> ItemPrototype:
	return ItemPrototype.new(
		base_name, 
		generate_item_repr(base_name, item_type),
		item_type,
		"Description WIP", 
		20,
		load("res://assets/item/NullTexture.png")
		)
		
static func create_textured_placeholder(base_name: String, item_type, texture: Texture) -> ItemPrototype:
	return ItemPrototype.new(
		base_name, 
		generate_item_repr(base_name, item_type),
		item_type,
		"Description WIP", 
		20,
		texture
		)
		
static func generate_item_repr(item_name: String, item_type: ItemType) -> StringName:
	return "stack/%s/%s" % [item_type.name(), item_name.to_snake_case()]
