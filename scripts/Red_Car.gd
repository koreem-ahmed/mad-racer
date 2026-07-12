extends Area2D

class_name Red_car

@export var max_speed:float = 380.0
@export var friction:float = 300.0
@export var acceleration:float = 150.0
@export var steering_power:float = 6.0
@export var min_steering_factor:float = 0.5
@export var bounce_time: float = 0.8
@export var bounce_force: float = 30.0

var _throttle: float = 0.0
var _steer: float = 0.0
var _velocity: float = 0.0


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	_throttle = Input.get_action_strength("ui_up")
	_steer = Input.get_axis("ui_left", "ui_right")

func _physics_process(delta: float) -> void:
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


func bounce() -> void:
	set_physics_process(false)
	_velocity = 0.
	position -= transform.x * bounce_force
	await get_tree().create_timer(bounce_time).timeout	
	set_physics_process(true)



func hit_boundry() -> void:
	bounce()
