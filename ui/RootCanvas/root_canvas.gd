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

func _process(delta: float) -> void:
	# Transient UI
	if _entity_interaction_ui != null and not _entity_interaction_ui.is_valid(): self.close_entity_interaction_widget()

func on_switch_to_top_down():
	self.close_entity_interaction_widget()

func on_switch_to_first_person():	
	self.close_entity_interaction_widget()

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
