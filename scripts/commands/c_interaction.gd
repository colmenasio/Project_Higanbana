extends RefCounted
class_name CInteraction

enum Type{
	LEFT,
	RIGHT,
	SHIFT_LEFT,
	SHIFT_RIGHT
}

var _i_type: Type

static func create(interaction_type: Type) -> CInteraction:
	var product = CInteraction.new()
	product._i_type = interaction_type
	return product

func get_type()->Type:
	return self._i_type
