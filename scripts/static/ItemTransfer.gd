extends Object
class_name ItemTransfer
# I KNOW THIS MIGHT LOOK BAD BUT HEAR ME OUT 
# HEAR ME OUT I SAYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY

## Transfer a single ItemStack from [u]A[/u]ny slot of [param from] to [u]A[/u]ny slot of [param to]. [br]
## Transfer is [u]T[/u]yped, meaning only the an ItemStack matching [param type] can be transfered (ItemStack.stacks_with(type)) [br]
## Finally, [param max_amount] limits the size of the stack transfered. A value of 0 means no limit [br]
static func a2at(_from: ItemContainer, _to: ItemContainer, type: ItemStack , max_amount: int = 0):
	# Obtain the maximun trasnferable amount
	var simulated_extract = _from.extract(type.get_prototype(), max_amount, true)
	if simulated_extract.is_type_empty(): return
	var simulated_remainder = _to.insert(simulated_extract, true)
	var true_max = simulated_extract.get_amount()-simulated_remainder.get_amount()
	
	# Perform the insertion
	_to.insert(_from.extract(type.get_prototype(), true_max))

## Transfer a single ItemStack from a specific [u]S[/u]lot of [param from] to [u]A[/u]ny slot of [param to]. [br]
## Transfer is [u]T[/u]yped, meaning only the an ItemStack matching [param type] can be transfered (ItemStack.stacks_with(type)) [br]
## Finally, [param max_amount] limits the size of the stack transfered. A value of 0 means no limit [br]
static func s2at(_from: ItemContainer, _from_slot: int, _to: ItemContainer, type: ItemStack , max_amount: int = 0):
	# Obtain the maximun trasnferable amount
	var simulated_extract = _from.extract_single_slot(_from_slot, type.get_prototype(), max_amount, true)
	if simulated_extract.is_type_empty(): return
	var simulated_remainder = _to.insert(simulated_extract, true)
	var true_max = simulated_extract.get_amount()-simulated_remainder.get_amount()
	
	# Perform the insertion
	_to.insert(_from.extract_single_slot(_from_slot, type.get_prototype(), true_max))

## Transfer a single ItemStack from [u]A[/u]ny slot of [param from] to a specific [u]S[/u]lot of [param to]. [br]
## Transfer is [u]T[/u]yped, meaning only the an ItemStack matching [param type] can be transfered (ItemStack.stacks_with(type)) [br]
## Finally, [param max_amount] limits the size of the stack transfered. A value of 0 means no limit [br]
static func a2st(_from: ItemContainer, _to: ItemContainer, _to_slot: int, type: ItemStack, max_amount: int = 0):
	# Obtain the maximun trasnferable amount
	var simulated_extract = _from.extract(type.get_prototype(), max_amount, true)
	if simulated_extract.is_type_empty(): return
	var simulated_remainder = _to.insert_single_slot(_to_slot, simulated_extract, true)
	var true_max = simulated_extract.get_amount()-simulated_remainder.get_amount()
	
	# Perform the insertion
	_to.insert_single_slot(_to_slot, _from.extract(type.get_prototype(), true_max))

## Transfer a single ItemStack from a specific [u]S[/u]lot of [param from] to a specific [u]S[/u]lot of [param to]. [br]
## Transfer is [u]T[/u]yped, meaning only the an ItemStack matching [param type] can be transfered (ItemStack.stacks_with(type)) [br]
## Finally, [param max_amount] limits the size of the stack transfered. A value of 0 means no limit [br]
static func s2st(_from: ItemContainer, _from_slot: int, _to: ItemContainer, _to_slot: int, type: ItemStack, max_amount: int = 0):
	# Obtain the maximun trasnferable amount
	var simulated_extract = _from.extract_single_slot(_from_slot, type.get_prototype(), max_amount, true)
	if simulated_extract.is_type_empty(): return
	var simulated_remainder = _to.insert_single_slot(_to_slot, simulated_extract, true)
	var true_max = simulated_extract.get_amount()-simulated_remainder.get_amount()
	
	# Perform the insertion
	_to.insert_single_slot(_to_slot, _from.extract_single_slot(_from_slot, type.get_prototype(), true_max))

## Transfer a single ItemStack from [u]A[/u]ny slot of [param from] to [u]A[/u]ny slot of [param to]. [br]
## Transfer is [u]U[/u]ntyped, meaning it does not matter what ItemStack was transfered [br]
## Finally, [param max_amount] limits the size of the stack transfered. A value of 0 means no limit [br]
static func a2au(_from: ItemContainer, _to: ItemContainer, max_amount: int = 0):
		# Obtain the maximun trasnferable amount
	var simulated_extract = _from.extract_any(max_amount, true)
	if simulated_extract.is_type_empty(): return
	var simulated_remainder = _to.insert(simulated_extract, true)
	var true_max = simulated_extract.get_amount()-simulated_remainder.get_amount()
	
	# Perform the insertion
	_to.insert(_from.extract_any(true_max))

## Transfer a single ItemStack from a specific [u]S[/u]lot of [param from] to [u]A[/u]ny slot of [param to]. [br]
## Transfer is [u]U[/u]ntyped, meaning it does not matter what ItemStack was transfered [br]
## Finally, [param max_amount] limits the size of the stack transfered. A value of 0 means no limit [br]
static func s2au(_from: ItemContainer, _from_slot: int, _to: ItemContainer, max_amount: int = 0):
		# Obtain the maximun trasnferable amount
	var simulated_extract = _from.extract_any_single_slot(_from_slot, max_amount, true)
	if simulated_extract.is_type_empty(): return
	var simulated_remainder = _to.insert(simulated_extract, true)
	var true_max = simulated_extract.get_amount()-simulated_remainder.get_amount()
	
	# Perform the insertion
	_to.insert(_from.extract_any_single_slot(_from_slot, true_max))

## Transfer a single ItemStack from [u]A[/u]ny slot of [param from] to a specific [u]S[/u]lot of [param to]. [br]
## Transfer is [u]U[/u]ntyped, meaning it does not matter what ItemStack was transfered [br]
## Finally, [param max_amount] limits the size of the stack transfered. A value of 0 means no limit [br]
static func a2su(_from: ItemContainer, _to: ItemContainer, _to_slot: int, max_amount: int = 0):
	# Obtain the maximun trasnferable amount
	var simulated_extract = _from.extract_any(max_amount, true)
	if simulated_extract.is_type_empty(): return
	var simulated_remainder = _to.insert_single_slot(_to_slot, simulated_extract, true)
	var true_max = simulated_extract.get_amount()-simulated_remainder.get_amount()
	
	# Perform the insertion
	_to.insert_single_slot(_to_slot, _from.extract_any(true_max))

## Transfer a single ItemStack from a specific [u]S[/u]lot of [param from] to a specific [u]S[/u]lot of [param to]. [br]
## Transfer is [u]U[/u]ntyped, meaning it does not matter what ItemStack was transfered [br]
## Finally, [param max_amount] limits the size of the stack transfered. A value of 0 means no limit [br]
static func s2su(_from: ItemContainer, _from_slot: int, _to: ItemContainer, _to_slot: int, max_amount: int = 0):
	var simulated_extract = _from.extract_any_single_slot(_from_slot, max_amount, true)
	if simulated_extract.is_type_empty(): return
	var simulated_remainder = _to.insert_single_slot(_to_slot, simulated_extract, true)
	var true_max = simulated_extract.get_amount()-simulated_remainder.get_amount()
	
	# Perform the insertion
	_to.insert_single_slot(_to_slot, _from.extract_any_single_slot(_from_slot, true_max))
