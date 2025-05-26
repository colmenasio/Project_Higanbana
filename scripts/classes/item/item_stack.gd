extends RefCounted
""" 
Class for itemsstacks, fluidstacks, energytanks, etc...
In other words, each slot in an container is a ItemStack
Do
""" 
class_name ItemStack

static var EMPTY_PROTOTYPE = ItemPrototype.new("empty", "stack/empty", ItemType.EMPTY, "Empty Stack", 0)
static var EMPTY = EMPTY_PROTOTYPE.stack(0)

var _amount: int
var _overwritten_name = null # Either string or null
var _prototype: ItemPrototype # The prototype of an Item defines what Item it is

func _init(prototype: ItemPrototype) -> void:
	"""
	Do not call this function directly.
	Instead, use a ItemPrototype
	"""
	self._prototype = prototype

func get_name() -> String:
	return self._overwritten_name if self._overwritten_name != null else self._prototype._base_name

func get_base_repr() -> StringName:
	return self._prototype._base_repr

func get_type() -> ItemType:
	return self._prototype._base_type

func same_item_as(other: ItemStack) -> bool:
	return self._prototype == other._prototype

func get_base_stack_size() -> int :
	return self._prototype._base_stack_size

func repr() -> String :
	return "ItemStack<%s(%s), type: %s, amount: %s>" % [ self.get_name(), self.get_base_repr(), self.get_type().name(), self._amount ]
