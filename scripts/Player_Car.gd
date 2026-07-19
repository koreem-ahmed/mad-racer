extends "res://scripts/Car.gd"


class_name PlayerCar


@export var max_speed:float = 380.0
@export var friction:float = 300.0
@export var acceleration:float = 150.0
@export var steering_power:float = 6.0
@export var min_steering_factor:float = 0.5

var _throttle: float = 0.0
var _steer: float = 0.0

var _verification_count: int = 0
var _verification_passed: Array[int] = []


func setup(vc: int) -> void:
	_verification_count = vc


func _process(delta: float) -> void:
	_throttle = Input.get_action_strength("ui_up")
	_steer = Input.get_axis("ui_left", "ui_right")
	super(delta)


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



func lap_completed() -> void:
	if _verification_count == _verification_passed.size():
		var lcd: LapCompleteData = LapCompleteData.new(self, lap_time)
		print("Lap _completed %s" % lcd)
		EventHub.emit_on_lap_completed(lcd)
	_verification_passed.clear()
	super()


func hit_verification(verification_id: int) -> void:
	if verification_id not in _verification_passed:
		_verification_passed.append(verification_id)
		pass
	
