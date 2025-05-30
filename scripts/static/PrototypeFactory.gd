extends Object
class_name PrototypeFactory

# ------------------------------------ITEM------------------------------------
static func item_placeholder(base_name: String, item_type) -> ItemPrototype:
	return ItemPrototype.new(
		base_name, 
		_generate_item_repr(base_name, item_type),
		item_type,
		"Description WIP", 
		20,
		load("res://assets/item/NullTexture.png")
		)

static func item_textured(base_name: String, item_type, texture: Texture) -> ItemPrototype:
	return ItemPrototype.new(
		base_name, 
		_generate_item_repr(base_name, item_type),
		item_type,
		"Description WIP", 
		20,
		texture
		)

static func item_placeable(base_name: String, item_type, texture: Texture, placeable_prototype: PlaceablePrototype) -> ItemPrototype:
	var product = ItemPrototype.new(
		base_name, 
		_generate_item_repr(base_name, item_type),
		item_type,
		"Description WIP", 
		20,
		texture
		)
	product.set_placeable_prototype(placeable_prototype)
	return product

static func _generate_item_repr(item_name: String, item_type: ItemType) -> StringName:
	return "stack/%s/%s" % [item_type.name(), item_name.to_snake_case()]

# ------------------------------------PLACEABLE------------------------------------
