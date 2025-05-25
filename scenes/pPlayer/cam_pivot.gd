extends Node3D

# Generic attributes
var top_down_camera_position: Vector3 = Vector3(-7, 9, 0)
var top_down_camera_rotation: Vector3 = Vector3(-PI/6, -PI/2, 0)
var cam_state: CamState = CamState.TOP_DOWN
var listen_mouse_movement: bool = false

# Controls
var mouse_sensitivity := 0.004

# Animation
var active_tween: Tween = null
var target_rotation: Vector3 = Vector3.ZERO # For top-down rotations

enum CamState {
	TOP_DOWN,
	FIRST_PERSON,
	TRANS_TO_FP,
	TRANS_TO_TD
}

func _ready() -> void:
	self.switch_to_top_down()

func _input(event):
	if event is InputEventMouseMotion and self.listen_mouse_movement:
		var delta = event.relative
		rotate_camera(delta)

func build_new_tween() -> Tween:
	if self.active_tween != null and self.active_tween.is_running():
		self.active_tween.kill()
	self.active_tween = get_tree().create_tween()
	return self.active_tween

func rotate_top_down(direction: String) -> void:
	#TODO make this less awful
	if direction == "l":
		self.target_rotation += Vector3(0, PI/2, 0)
	elif direction == "r":
		self.target_rotation += Vector3(0, -PI/2, 0)
	
	var tween = self.build_new_tween()
	tween.tween_property(self, "rotation", self.target_rotation, 0.4).set_trans(Tween.TRANS_CUBIC)

func switch_to_top_down() -> void:
	self.cam_state = CamState.TRANS_TO_TD
	var tween = self.build_new_tween().set_parallel(true)
	tween.tween_property(self, "rotation", self._get_top_down_snap_angle(), 0.4)
	tween.tween_property($Camera3D, "position", self.top_down_camera_position, 0.4)
	tween.tween_property($Camera3D, "rotation", self.top_down_camera_rotation, 0.4)
	tween.connect("finished", self._set_state_top_down)


func switch_to_first_person(initial_camera_angle: Vector3) -> void:
	self.cam_state = CamState.TRANS_TO_FP
	var tween = self.build_new_tween().set_parallel(true)
	tween.tween_property(self, "rotation", initial_camera_angle, 0.4).set_trans(Tween.TRANS_QUINT)
	tween.tween_property($Camera3D, "position", Vector3(0, 0, 0), 0.4).set_trans(Tween.TRANS_QUINT)
	tween.tween_property($Camera3D, "rotation", Vector3(0, -PI/2, 0), 0.4)
	tween.connect("finished", self._set_state_first_person)

func _set_state_top_down():
	self.cam_state = CamState.TOP_DOWN

func _set_state_first_person():
	self.cam_state = CamState.FIRST_PERSON

func is_top_down():
	return self.cam_state == CamState.TOP_DOWN

func is_first_person():
	return self.cam_state == CamState.FIRST_PERSON

func is_trans_to_td():
	return self.cam_state == CamState.TRANS_TO_TD

func _get_top_down_snap_angle() -> Vector3:
	return Vector3(0, round(self.rotation.y / (PI/2)) * (PI/2), 0)

func set_listen_mouse_movement(value: bool):
	self.listen_mouse_movement = value

func rotate_camera(mouse_delta: Vector2):
	self.rotation.z -= clamp(mouse_delta.y * mouse_sensitivity, deg_to_rad(-80), deg_to_rad(80))
	self.rotation.y -= mouse_delta.x * mouse_sensitivity
