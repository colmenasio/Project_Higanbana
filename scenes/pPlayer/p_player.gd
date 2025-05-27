extends CharacterBody3D
class_name pPlayer

# Movement
const vel_limits: Vector3 = Vector3(10, 30, 10) # Absolute limits for speed
const vel_decay_rate: Vector3 = Vector3(0.9, 1, 0.9)
const mov_accel: float = 70 # Acceleration exerted by userr control
const grav: float = 70
var do_gravity: bool = true

# Jumps
const jump_duration: float = 0.2     # Time to reach peak
const jump_linger: float = 0.1     # Time to maintaining the peak in the jump
const jump_exponent: float = 1.5     # Curve steepness
const jump_height: float = 5.0      # Peak height of the jump
const max_jumps: int = 2
var jumps_left: int = self.max_jumps;
var is_jumping: bool = false;
var jump_timer: float = 0;
var jump_starting_y: float = 0;

# Interaction
var interaction_locked: bool = false # Locked camera and movement due to interaction with ui

func _ready() -> void:
	$RootCanvas.opened_interaction_widget.connect(_on_open_interaction_widged)
	$RootCanvas.closed_interaction_widget.connect(_on_close_interaction_widget)
	
func _process(delta: float) -> void:
	# Process input
	if Input.is_action_just_pressed("camera_switch_mode"): self.switch_perspective()
	if $CamPivot.is_top_down() and Input.is_action_just_pressed("camera_top_down_rotate_l"): $CamPivot.rotate_top_down("l")
	if $CamPivot.is_top_down() and Input.is_action_just_pressed("camera_top_down_rotate_r"): $CamPivot.rotate_top_down("r")
	if Input.is_action_just_pressed("escape"): self.on_escape_pressed()
	
	# Model Update
	self.update_direction()

func _physics_process(delta: float) -> void:
	# Process input
	var mov_vel_delta: Vector2 = Vector2.ZERO
	if not self.interaction_locked:
		mov_vel_delta = Input.get_vector("move_s", "move_w", "move_a", "move_d") * mov_accel * delta
		if Input.is_action_just_pressed("jump"): self.try_jump()
	
	# Apply Movement Acceleration
	var grav_vel: float = -grav*delta if self.do_gravity and not self.is_on_floor() else 0.0;
	self.apply_local_delta_vel(Vector3(mov_vel_delta[0], grav_vel, mov_vel_delta[1]))

	# Finalize
	self.process_jump(delta)
	self.move_and_slide()
	self.decay_velocity()
	self.finalize_physics()

func _unhandled_input(event: InputEvent) -> void:
	# Mouse input
	var command: CInteraction
	if event.is_action_pressed("shift_mouse_l"):
		command = CInteraction.create(CInteraction.Type.SHIFT_LEFT, self, $RootCanvas)
	elif event.is_action_pressed("shift_mouse_r"):
		command = CInteraction.create(CInteraction.Type.SHIFT_RIGHT, self, $RootCanvas)
	elif event.is_action_pressed("mouse_l"): 
		command = CInteraction.create(CInteraction.Type.LEFT, self, $RootCanvas)
	elif event.is_action_pressed("mouse_r"):
		command = CInteraction.create(CInteraction.Type.RIGHT, self, $RootCanvas)
	else:
		return
	
	var result: Dictionary = $CamPivot.raycast_from_viewport(100)
	var collider = result.get("collider")
	if collider != null and IInteractable.impl(collider):
		collider.i_interact(command)

# Apply an increment of velocity given in the local frame
# If comply_vel_limits, will not apply the increment past the "vel_limits"
# If comply_vel_limits, will not reset momentum, this is, it does not snap to "vel_limits" if velocity is higher than limits
func apply_local_delta_vel(delta_vel: Vector3, comply_vel_limits: bool = true) -> void:	
	#var fixed_frame_delta_vel: Vector3 = transform.basis * delta_vel
	var fixed_frame_delta_vel: Vector3 = Basis(Vector3.UP, $CamPivot.rotation.y) * delta_vel
	
	if not comply_vel_limits:
		self.velocity += fixed_frame_delta_vel
		return
	
	for i in range(3):
		if (abs(self.velocity[i]) < self.vel_limits[i] or # If within limits, apply increment normally
			abs(self.velocity[i] + fixed_frame_delta_vel[i] ) < abs(self.velocity[i]) # If outside limits, only apply reductions
			):
			self.velocity[i] = clamp(self.velocity[i] + fixed_frame_delta_vel[i], -vel_limits[i], +vel_limits[i])
	return
	
func decay_velocity():
	self.velocity *= self.vel_decay_rate;
		# Snap small components to 0
	if abs(velocity.x) < 0.1:
		velocity.x = 0
	if abs(velocity.y) < 0.1:
		velocity.y = 0
	if abs(velocity.z) < 0.1:
		velocity.z = 0

func try_jump():
	if self.jumps_left > 0:
		self.is_jumping = true
		self.jumps_left -= 1
		self.do_gravity = false
		self.jump_timer = 0.0
		self.velocity.y = 0.0
		self.jump_starting_y = position.y

func end_jump():
	if self.is_jumping:
		self.is_jumping = false
		self.do_gravity = true

# Jump rising edge follows the function h = 1-(1-t/jump_duration)^(jump_exponent) from t=0 to t=jump_duration
func process_jump(delta: float):
	if not self.is_jumping:
		return
	
	if self.is_on_ceiling():
		self.end_jump();
		return
	
	if abs(self.velocity[1]) > 0.0000001: 
		self.end_jump() # If any vertical velocity is applied, cancel jump
		return
	
	self.jump_timer += delta
	if self.jump_timer < self.jump_duration:
		var h: float = (1 - pow(1 - ( self.jump_timer / self.jump_duration ) , self.jump_exponent)) * self.jump_height
		self.position.y = self.jump_starting_y + h
	elif self.jump_timer >= self.jump_duration + self.jump_linger:
		self.end_jump() # If jump has ended, end jump (lmao)
		return

func finalize_physics():
	if self.is_on_floor():
		self.end_jump()
		self.jumps_left = self.max_jumps

func update_direction():
	if $CamPivot.is_top_down(): # Find the closest direction that multiple of pi/4 and apply it to the model
		var vel = Vector2(self.velocity[0], self.velocity[2])
		if vel.length() < 0.5: return
		var pi_over_4 = PI / 4
		$ModelPivot.rotation.y = - round( vel.angle() / pi_over_4) * pi_over_4
	elif $CamPivot.is_first_person() or $CamPivot.is_trans_to_td():
		$ModelPivot.rotation.y = $CamPivot.rotation.y
		

func get_player_facing_direction() -> Vector3:
	if $CamPivot.is_top_down():
		return $ModelPivot.rotation
	else:
		return $CamPivot.rotation

func switch_perspective() -> void:
	if self.interaction_locked:
		return
	if $CamPivot.is_top_down():
		$CamPivot.switch_to_first_person(self.get_player_facing_direction())
		self.set_mouse_capture()
		$RootCanvas.on_switch_to_first_person()
	else:
		$CamPivot.switch_to_top_down()
		self.unset_mouse_capture()
		$RootCanvas.on_switch_to_top_down()

func set_mouse_capture():
	if $CamPivot.is_top_down(): # Cant capture mouse if top down lmao
		return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$CamPivot.set_listen_mouse_movement(true)

func unset_mouse_capture():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CamPivot.set_listen_mouse_movement(false)

func on_escape_pressed()-> void:
	$RootCanvas.close_entity_interaction_widget()

func _on_open_interaction_widged():
	if $CamPivot.is_first_person() :
		self.interaction_locked = true
		self.unset_mouse_capture()

func _on_close_interaction_widget():
	if $CamPivot.is_first_person() :
		self.interaction_locked = false
		self.set_mouse_capture()
