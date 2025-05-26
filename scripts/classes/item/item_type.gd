extends Object
class_name ItemType

var _id: int
var _name: String

static var EMPTY = ItemType.new(0, "empty")
static var SOLID = ItemType.new(1, "solid")
static var FLUID = ItemType.new(2, "fluid")
static var ENERGY = ItemType.new(3, "energy")
static var KARMA = ItemType.new(4, "karma")

func _init(id: int, name: String) -> void:
	self._id = id
	self._name = name

func name() -> String:
	return self._name
