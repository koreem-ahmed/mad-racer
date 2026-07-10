extends Area2D


@export var max_speed:float = 380.0
@export var friction:float = 300.0
@export var acceleration:float = 1500
@export var steering_power:float = 4.0

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
	position = transform.x * _velocity * delta

func _throttling(delta: float) -> void:
	if _throttle > 0.0:
		_velocity += acceleration * delta
	else:
		_velocity -= friction * delta
	
	_velocity = clampf(_velocity, 0.0, max_speed)

func _rotating(delta: float) -> void:
	rotate(steering_power * delta * _steer)
	
