extends Node3D

var is_top_down: bool = true
var active_tween: Tween = null

# Top-Down variables
var target_rotation: Vector3 = Vector3.ZERO

func _process(delta: float) -> void:
	if self.is_top_down and Input.is_action_just_pressed("camera_top_down_rotate_l"): self.rotate_top_down("l")
	if self.is_top_down and Input.is_action_just_pressed("camera_top_down_rotate_r"): self.rotate_top_down("r")

func rotate_top_down(direction: String):
	#TODO make this less awful
	if direction == "l":
		self.target_rotation += Vector3(0, PI/2, 0)
	elif direction == "r":
		self.target_rotation += Vector3(0, -PI/2, 0)
	
	var tween = self.build_new_tween()
	tween.tween_property(self, "rotation", self.target_rotation, 0.4).set_trans(Tween.TRANS_CUBIC)
	
func build_new_tween() -> Tween:
	if self.active_tween != null and self.active_tween.is_running():
		self.active_tween.kill()
	self.active_tween = get_tree().create_tween()
	return self.active_tween
		
