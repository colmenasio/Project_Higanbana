extends Object
class_name CATALOGUE

static var TempCatalogue: ItemContainer = build_temp_catalogue()

static func build_temp_catalogue():
	var product = BottomlessItemContainer.new(0, ItemType.T_SOLID, 1)
	product._contents.push_back(SOLID.WOOD_CHUNK.stack(1))
	product._contents.push_back(SOLID.STONE_CHUNK.stack(1))
	product._contents.push_back(SOLID.CUT_WOOD.stack(1))
	product._contents.push_back(SOLID.P_CHEST.stack(1))
	return product
