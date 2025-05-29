extends RefCounted
""" 
Class for itemsstacks, fluidstacks, energytanks, etc...
In other words, each slot in an container is a ItemStack
Do
""" 
class_name ItemStack

static var EMPTY_PROTOTYPE = ItemPrototype.new("empty", "stack/empty", ItemType.T_EMPTY, "Empty Stack", 1, load("res://assets/item/EmptyStack.png"))
static var EMPTY = EmptyItemStack.new(EMPTY_PROTOTYPE, 0)

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

## Given 2 stacks A and B, decide whether A can stack into B. [br]
## Note that [code]A.stacks_into(B)[/code] is [b]NOT[/b] equivalent to [code]B.stacks_into(A)[/code]. Let me explain: [br][br]
##
## [code]A.stacks_into(B)[/code] returns: [br]
## -  (1) If A is an empty stack, A does not stack into B. [br]
## -  (2) If B is an empty stack, A always stacks into B, unless (1). [br]
## -  (3) If B is a non-empty stack, A stacks into B iff A and B share prototype and metadata. [br][br]
##
## If A stacks into B, then stacking them should be equivalent to: [br]
##   [code]B.clone_and_set_amount(A.get_amount() + B.get_amount())[/code]
func stacks_into(other: ItemStack) -> bool:
	return (
		other.is_type_empty() or 
		self._prototype == other._prototype
	)

func get_base_stack_size() -> int :
	return self._prototype._base_stack_size

func is_type_empty() -> bool :
	return false

func repr() -> String :
	return "ItemStack<Name: %s(%s), Type: %s, Amount: %s>" % [ self.get_name(), self.get_base_repr(), self.get_type().name(), self.get_amount() ]

func _to_string() -> String:
	return "ItemStack<Name: %s, Type: %s, Amount: %s>" % [ self.get_name(), self.get_type().name(), self.get_amount() ]

func clone() -> ItemStack:
	var product = ItemStack.new(self._prototype, self._amount)
	product._overwritten_name = self._overwritten_name
	return product

func clone_and_set_amount(amount: int) -> ItemStack:
	var product = self.clone()
	product.set_amount(amount)
	return product

class EmptyItemStack:
	extends ItemStack
	
	func set_amount(_amount_: int) -> void:
		assert(false, "Attempted to modify EMPTY ItemStack")
	
	func delta_amount(_delta: int) -> void:
		assert(false, "Attempted to modify EMPTY ItemStack")
	
	func stacks_into(_other: ItemStack) -> bool:
		return false
	
	func clone() -> ItemStack:
		return self
	
	func is_type_empty() -> bool :
		return true
	
