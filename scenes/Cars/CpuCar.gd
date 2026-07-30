extends "Car.gd"


class_name CPUCar


const STEER_REACTION_MAX: float = 12.0
const STEER_REACTION_MIN: float = 9.0

const DEVI_STEP_MIN: float = 0.02
const DEVI_STEP_MAX: float = 0.25

const DEVI_LIMIT_MIN: float = 0.1
const DEVI_LIMIT_MAX: float = 1.0




@export var debug: bool = true
@export_range(0,1) var skill: float = 1.0
@export var waypoint_distance: float = 20.0
@export var max_top_speed_limit: float = 350.0
@export var min_top_speed_limit: float = 300.0
@export var max_bottom_speed_limit: float = 120.0
@export var min_bottom_speed_limit: float = 80.0
@export var speed_reaction: float = 2.0
@export var Cpu_texture: Texture2D


@onready var target_sprite: Sprite2D = $"Target sprite"



const Steer_reaction_max: float = 9.0

var targeted_waypoint: Vector2 = Vector2.ZERO
var steer_reaction: float = Steer_reaction_max
var target_speed: float = 250.0
var _next_waypoint: Waypoint
var deviation_step: float = 0.0
var deviation_limit: float = 0.0
var deviation_weight: float =  0.0
var inverted_skill: float = 1.0
var allowed_max_speed: float = 0.0
var allowed_min_speed: float = 0.0


func _ready() -> void:
	super()
	target_sprite.visible = debug
	inverted_skill = 1.0 - skill
	target_speed = randf_range(min_top_speed_limit , max_top_speed_limit)
	deviation_step = lerp(DEVI_STEP_MIN, DEVI_STEP_MAX, inverted_skill)
	deviation_limit = lerp(DEVI_LIMIT_MIN, DEVI_LIMIT_MAX, inverted_skill)
	deviation_weight = randf_range(-deviation_limit, deviation_limit)
	steer_reaction = lerp(STEER_REACTION_MIN, STEER_REACTION_MAX, skill)
	update_speeds()
	car_sprite.texture = Cpu_texture

func update_speeds() -> void:
	allowed_max_speed = randf_range(min_top_speed_limit, max_top_speed_limit)
	allowed_min_speed = randf_range(min_bottom_speed_limit, max_bottom_speed_limit)
	
	




func update_waypoint() -> void:
	if global_position.distance_to(targeted_waypoint) < waypoint_distance:
		set_next_waypoint(_next_waypoint.next_waypoint)
		target_speed = lerp(
			allowed_min_speed,
			allowed_max_speed,
			_next_waypoint.next_waypoint.radius_factor
		)
		
	

func set_next_waypoint(wp: Waypoint) -> void:
	_next_waypoint = wp
	
	deviation_weight += randf_range(-deviation_step, deviation_step)
	deviation_weight = clampf(deviation_weight, -deviation_limit, deviation_limit)

	
	targeted_waypoint = wp.get_target_adjusted(deviation_weight)
	target_sprite.global_position = targeted_waypoint



func _physics_process(delta: float) -> void:
	car_sprite.texture = Cpu_texture
	
	if !_next_waypoint:
		return
	if _state == CarState.SLIPPING:
		update_waypoint()
	if _state != CarState.DRIVING: return
	
	
	var ta: float = (targeted_waypoint - global_position).angle()
	rotation = lerp_angle(rotation, ta, steer_reaction * delta)
	_velocity = lerp(_velocity, target_speed, speed_reaction * delta)
	position += transform.x * _velocity * delta
	
	update_waypoint()


func _on_deviation_timer_timeout() -> void:
	update_speeds()
	if randf() < inverted_skill:
		deviation_weight = -deviation_weight
