extends RefCounted
""" 
Class for itemsstacks, fluidstacks, energytanks, etc...
In other words, each slot in an container is a ItemStack
Do
""" 
class_name ItemStack

static var EMPTY_PROTOTYPE = ItemPrototype.new("empty", "stack/empty", ItemType.EMPTY, "Empty Stack", 1)
static var EMPTY = InertItemStack.new(EMPTY_PROTOTYPE, 0)

var _amount: int
var _overwritten_name = null # Either string or null
var _prototype: ItemPrototype # The prototype of an Item defines what Item it is

func _init(prototype: ItemPrototype, amount: int) -> void:
	"""
	Do not call this function directly.
	Instead, use a ItemPrototype
	"""
	self._prototype = prototype
	self._amount = amount

func get_name() -> String:
	return self._overwritten_name if self._overwritten_name != null else self._prototype._base_name

func set_amount(amount: int) -> void:
	self._amount = amount

func get_amount() -> int:
	return self._amount

func delta_amount(delta: int) -> void:
	self._amount+=delta

func get_prototype() -> ItemPrototype:
	return self._prototype

func get_base_repr() -> StringName:
	return self._prototype._base_repr

func get_type() -> ItemType:
	return self._prototype._base_type

func same_item_as(other: ItemStack) -> bool:
	return self._prototype == other._prototype

func get_base_stack_size() -> int :
	return self._prototype._base_stack_size

func is_type_empty() -> bool :
	return self == ItemStack.EMPTY

func repr() -> String :
	return "ItemStack<Name: %s(%s), Type: %s, Amount: %s>" % [ self.get_name(), self.get_base_repr(), self.get_type().name(), self.get_amount() ]

func _to_string() -> String:
	return "ItemStack<Name: %s, Type: %s, Amount: %s>" % [ self.get_name(), self.get_type().name(), self.get_amount() ]


func clone() -> ItemStack:
	var product = ItemStack.new(self._prototype, self._amount)
	product._overwritten_name = self._overwritten_name
	return product

class InertItemStack:
	extends ItemStack
	
	func set_amount(amount: int):
		assert(false, "Cannot modify InertItemStack")
	
