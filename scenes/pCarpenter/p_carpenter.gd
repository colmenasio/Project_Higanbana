extends StaticBody3D

@export var id: int = 0

var input_inventory: ItemContainer = ItemContainer.new(2, ItemType.T_SOLID)
var output_inventory: ItemContainer = ItemContainer.new(1, ItemType.T_SOLID)
var current_recipe: Recipe = null
var recipe_progress: int = 0

func _process(_delta: float) -> void:
	self.tick()

func _open_ui(command: CInteraction):
	var ui_scene = preload("res://ui/SimpleMachineDisplay/SimpleMachineDisplay.tscn")
	var ui_instance = ui_scene.instantiate()
	ui_instance.set_input(self.input_inventory.as_handle())
	ui_instance.set_output(self.output_inventory.as_handle())
	command.get_canvas().set_entity_interaction_widget(ui_instance)

func i_interact(command: CInteraction):
	if command.get_type() == CInteraction.Type.SHIFT_RIGHT:
		self._open_ui(command)

func tick():
	if current_recipe == null:
		# Recipe Lookup
		for recipe in [CutWoodRecipe, DuplicateStoneRecipe]:
			if recipe.matches(self.input_inventory):
				recipe.draw_inputs(self.input_inventory)
				self.current_recipe = recipe
				recipe_progress = 0
				break
	else:
		recipe_progress += 1
		if recipe_progress >= current_recipe._duration:
			output_inventory.insert(current_recipe._output[0])
			current_recipe = null


static var CutWoodRecipe = Recipe.new([SOLID.WOOD_CHUNK.stack(1)], [SOLID.CUT_WOOD.stack(2)], 100)
static var DuplicateStoneRecipe = Recipe.new([SOLID.STONE_CHUNK.stack(1)], [SOLID.STONE_CHUNK.stack(2)], 100)

class Recipe:
	var _input: Array[ItemStack]
	var _output: Array[ItemStack]
	var _duration: int
	
	func _init(input: Array[ItemStack], output: Array[ItemStack], duration: int):
		self._input = input
		self._output = output
		self._duration = duration
	
	## Given an input, return the amount of this recipe that can be performed
	## [param available] Is the available inputs from which a recipe match will be searched
	## [param mult_cap] Is the maximum number of paralell that will be searched. If 0, no cap is applied
	func matches(available: ItemContainer, mult_cap: int = 1) -> int:
		var max_mult = mult_cap
		for required_input in self._input:
			var rounds = int(available.extract(required_input.get_prototype(), 0, false).get_amount() / required_input.get_amount())
			if rounds == 0: return 0
			max_mult = rounds if max_mult == 0 else min(max_mult, rounds)
		return max_mult
	
	func draw_inputs(available: ItemContainer, mult: int = 1) -> void:
		for required_input in self._input:
			available.extract(required_input.get_prototype(), required_input.get_amount()*mult)
			# Maybe check the extracted amount is what you expected??
