extends Object
class_name SOLID

static var WOOD_CHUNK = PrototypeFactory.item_textured("Wood Chunk", ItemType.T_SOLID, load("res://assets/item/solid/pWoodChunk.png"))
static var STONE_CHUNK = PrototypeFactory.item_textured("Stone Chunk", ItemType.T_SOLID, load("res://assets/item/solid/pStoneChunk.png"))
static var CUT_WOOD = PrototypeFactory.item_textured("Cut Wood", ItemType.T_SOLID, load("res://assets/item/solid/pCutWood.png"))

# Placeables
static var P_CHEST = PrototypeFactory.item_placeable(
	"P Chest", 
	ItemType.T_SOLID, 
	load("res://assets/pOldHiganbanaTextures/block/test_buffer_front.png"), 
	BasicPlaceablePrototype.new(
		preload("res://scenes/pChest/pChest.tscn"), 
		LogicTilePChest.new)
)
