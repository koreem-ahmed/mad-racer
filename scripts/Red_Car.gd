extends Area2D


class_name Red_car


enum CarState {DRIVING, BOUNCING, SLIPPING}

@export var max_speed:float = 380.0
@export var friction:float = 300.0
@export var acceleration:float = 150.0
@export var steering_power:float = 6.0
@export var min_steering_factor:float = 0.5
@export var bounce_time: float = 0.8
@export var bounce_force: float = 30.0
@export var slipping_speed_range: Vector2 = Vector2(0.2, 0.5)

@onready var chrasheffect: CPUParticles2D = $Chrasheffect

var _throttle: float = 0.0
var _steer: float = 0.0
var _velocity: float = 0.0
var _bounce_tween: Tween
var _slip_tween: Tween
var _bounce_target: Vector2 = Vector2.ZERO
var _state: CarState = CarState.DRIVING
var _verification_count: int = 0
var _verification_passed: Array[int] = []

func _ready() -> void:
	pass

func setup(vc: int) -> void:
	_verification_count = vc
	pass

func _process(_delta: float) -> void:
	_throttle = Input.get_action_strength("ui_up")
	_steer = Input.get_axis("ui_left", "ui_right")


func _physics_process(delta: float) -> void:
	if _state != CarState.DRIVING: return
	_throttling(delta)
	_rotating(delta)
	position += transform.x * _velocity * delta

func _throttling(delta: float) -> void:
	if _throttle > 0.0:
		_velocity += acceleration * delta
	else:
		_velocity -= friction * delta
	
	_velocity = clamp(_velocity, 0.0, max_speed)

func steering_factor() -> float:
	return clamp(
		1.0 - pow(_velocity/max_speed, 2.0),
		min_steering_factor,
		1.0
	) * steering_power
	

func _rotating(delta: float) -> void:
	rotate(steering_factor() * delta * _steer)


#region state

func change_state(new_state: CarState) -> void:
	if new_state == _state: return
	_state = new_state
	
	match new_state:
		CarState.BOUNCING:
			bounce()
		CarState.SLIPPING:
			slipping_oil()

#endregion


#region Bounce

func bounce_done() -> void:
	_bounce_tween = null
	change_state(CarState.DRIVING)


func bounce() -> void:
	_velocity = 0.0
	
	kill_slip_tween()
	
	if _bounce_tween and _bounce_tween.is_running():
		_bounce_tween.kill()
	
	rotation_degrees = fmod(rotation_degrees, 360)
	_bounce_tween = create_tween()
	_bounce_tween.set_parallel()
	_bounce_tween.set_ease(Tween.EASE_IN_OUT)
	_bounce_tween.tween_property(self, "position", _bounce_target, bounce_time)
	_bounce_tween.tween_property(self, "rotation_degrees", rotation_degrees + 360.0, bounce_time)
	_bounce_tween.set_parallel(false)
	_bounce_tween.finished.connect(bounce_done)



func hit_boundry(dir_path: Vector2) -> void:
	chrasheffect.restart()
	_bounce_target = position + (dir_path * bounce_force)
	change_state(CarState.BOUNCING)

#endregion 


#region slipping

func kill_slip_tween() -> void:
	if _slip_tween and _slip_tween.is_running():
		_slip_tween.kill()

func slip_done() -> void:
	_slip_tween = null
	change_state(CarState.DRIVING)

func slipping_oil() -> void:
	
	kill_slip_tween()
	
	rotation_degrees = fmod(rotation_degrees, 360)
	_velocity *= randf_range(slipping_speed_range.x, slipping_speed_range.y)
	_slip_tween = create_tween()
	_slip_tween.set_parallel()
	_slip_tween.set_ease(Tween.EASE_IN_OUT)
	_slip_tween.tween_property(self, "position", position + _velocity * transform.x, bounce_time)
	_slip_tween.tween_property(self, "rotation_degrees", rotation_degrees + 720.0, bounce_time)
	_slip_tween.set_parallel(false)
	_slip_tween.finished.connect(slip_done)

func hit_oil() -> void:
	if _state == CarState.BOUNCING: return
	change_state(CarState.SLIPPING)

#endregion


func lap_completed() -> void:
	print("lap completed")


func hit_verification(verification_id: int) -> void:
	if verification_id not in _verification_passed:
		_verification_passed.append(verification_id)
		pass
	
	
	
	
	
	
	
	
	
	
	
