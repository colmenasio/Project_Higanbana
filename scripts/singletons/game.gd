extends Node

var _player: pPlayer
var _current_scene: Node

var _main_realm: Realm = Realm.new()

func _ready() -> void:
	var player_scene = preload("res://scenes/pPlayer/pPlayer.tscn")
	self._player = player_scene.instantiate()
	
	self._start_game()
	self._debug_shit()

func _debug_shit():
	self._player.get_inventory().container().insert(SOLID.P_CHEST.stack(1))
	self._main_realm.place_tile(Vector3i(0, 5, 0), SOLID.P_CHEST.get_placeable_prototype(), self._current_scene)

func _start_game():
	self._current_scene = get_tree().current_scene
	self._current_scene.add_child(_player)
	self._player.global_position = Vector3(0, 1, 0)

func get_player() -> pPlayer:
	return self._player

class Realm:
	extends RefCounted
	
	var _physical_tiles: Dictionary[Vector3i, PhysicalTile]
	var _logic_tiles: Dictionary[Vector3i, LogicTile]
	
	func place_tile(position: Vector3i, prototype: PlaceablePrototype, scene):
		var physical = prototype.build_physical_tile()
		var logic = prototype.build_logical_tile()
		self._physical_tiles[position] = physical
		self._logic_tiles[position] = logic
		scene.add_child(physical)
		physical.position = position

	func tick():
		for logic_tile in self._logic_tiles.values():
			logic_tile.tick()
