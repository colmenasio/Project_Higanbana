extends RefCounted
class_name CInteraction

enum Type{
	LEFT,
	RIGHT,
	SHIFT_LEFT,
	SHIFT_RIGHT
}

var _i_type: Type
var _player: pPlayer
var _canvas: RootCanvas

static func create(interaction_type: Type, player: pPlayer, canvas: RootCanvas) -> CInteraction:
	var product = CInteraction.new()
	product._i_type = interaction_type
	product._player = player
	product._canvas = canvas
	return product

func get_type()->Type:
	return self._i_type

func get_player()->pPlayer:
	return self._player

func get_canvas()->RootCanvas:
	return self._canvas
