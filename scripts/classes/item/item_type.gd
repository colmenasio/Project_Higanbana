extends Object
class_name ItemType

var _id: int
var _name: String

static var T_EMPTY = ItemType.new(0, "empty")
static var T_SOLID = ItemType.new(1, "solid")
static var T_FLUID = ItemType.new(2, "fluid")
static var T_ENERGY = ItemType.new(3, "energy")
static var T_KARMA = ItemType.new(4, "karma")

func _init(id: int, type_name: String) -> void:
	self._id = id
	self._name = type_name

func name() -> String:
	return self._name
