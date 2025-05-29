extends RefCounted
class_name ItemHandle

var _container

static func build_invalid():
	return ItemHandle.new(null)

func _init(container_: ItemContainer) -> void: 
	self._container = container_

func is_valid() -> bool:
	return self._container != null

func invalidate() -> void:
	self._container = null

func container() -> ItemContainer:
	return self._container
