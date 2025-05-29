extends CanvasLayer
class_name RootCanvas
"""
Facade for all the UI elements
"""
# Components
var _entity_interaction_ui = null

# Signals
signal opened_interaction_widget()
signal closed_interaction_widget()

func _ready():
	$PermanentUI/Inventory/InventoryPanel/MarginContainer/VBoxContainer/ItemContainerDisplay.set_handle(Game.get_player().get_inventory())

func _process(_delta: float) -> void:
	# Transient UI
	if _entity_interaction_ui != null and not _entity_interaction_ui.is_valid(): self.close_entity_interaction_widget()

func on_switch_to_top_down():
	self.close_entity_interaction_widget()

func on_switch_to_first_person():	
	self.close_entity_interaction_widget()

func on_open_inventory():
	var tween = get_tree().create_tween()
	var og_position = $PermanentUI/Inventory/InventoryPanel.position
	og_position.x = -$PermanentUI/Inventory/InventoryPanel.size.x -30
	tween.tween_property($PermanentUI/Inventory/InventoryPanel, "position", og_position, 0.25).set_trans(Tween.TRANS_SPRING)

func on_close_inventory():	
	var tween = get_tree().create_tween()
	var og_position = $PermanentUI/Inventory/InventoryPanel.position
	og_position.x = 10
	tween.tween_property($PermanentUI/Inventory/InventoryPanel, "position", og_position, 0.25)

func set_entity_interaction_widget(node: Control):
	"""node must implement the 'is_valid' method"""
	if self._entity_interaction_ui != null: self.close_entity_interaction_widget();
	self._entity_interaction_ui = node
	$TransientUI/EntityInteractionUI.add_child(self._entity_interaction_ui)
	self.opened_interaction_widget.emit()

func close_entity_interaction_widget():
	if self._entity_interaction_ui == null: return
	$TransientUI/EntityInteractionUI.remove_child(self._entity_interaction_ui)
	self.closed_interaction_widget.emit()
	self._entity_interaction_ui = null

func crosshair_visibility(enable: bool) -> void:
	if enable: 
		$PermanentUI/CrossHair.show() 
	else: 
		$PermanentUI/CrossHair.hide()
