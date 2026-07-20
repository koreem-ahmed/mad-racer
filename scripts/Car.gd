extends Area2D


class_name Car


enum CarState {WAITING, DRIVING, BOUNCING, SLIPPING}

@export var car_texture: Texture2D = preload("res://assets/levels/Images/CarRed.png")
@export var car_name: String = "Light Mcqueen"
@export var car_number: int = 0
@export var bounce_time: float = 0.8
@export var bounce_force: float = 30.0
@export var slipping_speed_range: Vector2 = Vector2(0.2, 0.5)

@onready var chrasheffect: CPUParticles2D = $Chrasheffect
@onready var car_sprite: Sprite2D = $Car_Sprite


var _velocity: float = 0.0
var _bounce_tween: Tween
var _slip_tween: Tween
var _bounce_target: Vector2 = Vector2.ZERO
var _state: CarState = CarState.WAITING	
var lap_time: float = 0.0
var _verification_count: int = 0
var _verification_passed: Array[int] = []


func _ready() -> void:
	EventHub.on_race_start.connect(on_race_starts)
	set_physics_process(false)
	car_sprite.texture = car_texture



func setup(vc: int) -> void:
	_verification_count = vc



func on_race_starts() -> void:
	change_state(CarState.DRIVING)




func _process(delta: float) -> void:
	lap_time += delta



#region state

func change_state(new_state: CarState) -> void:
	if new_state == _state: return
	_state = new_state
	
	match new_state:
		CarState.BOUNCING:
			bounce()
		CarState.SLIPPING:
			slipping_oil()
		CarState.DRIVING:
			set_physics_process(true)

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
	if _verification_count == _verification_passed.size():
		var lcd: LapCompleteData = LapCompleteData.new(self, lap_time)
		print("Lap _completed %s" % lcd)
		EventHub.emit_on_lap_completed(lcd)
		lap_time = 0
	_verification_passed.clear()

func hit_verification(verification_id: int) -> void:
	if verification_id not in _verification_passed:
		_verification_passed.append(verification_id)
	
