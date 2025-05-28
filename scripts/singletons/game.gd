extends Node

var _player: pPlayer
var _current_scene: Node

func _ready() -> void:
	var player_scene = preload("res://scenes/pPlayer/pPlayer.tscn")
	self._player = player_scene.instantiate()
	
	self._start_game()

func _start_game():
	self._current_scene = get_tree().current_scene
	self._current_scene.add_child(_player)
	self._player.global_position = Vector3(0, 1, 0)

func get_player() -> pPlayer:
	return self._player
