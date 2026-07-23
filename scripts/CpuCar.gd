extends "res://scripts/Car.gd"


class_name CPU_Car


@export var debug: bool = true
@export var waypoint_distance: float = 20.0
@export var max_speed_limit: float = 350.0
@export var min_speed_limit: float = 300.0

@onready var target_sprite: Sprite2D = $"Target sprite"



const Steer_reaction_max: float = 9.0

var targeted_waypoint: Vector2 = Vector2.ZERO
var steer_reaction: float = Steer_reaction_max
var target_speed: float = 250.0
var _next_waypoint: Waypoint



func _ready() -> void:
	target_sprite.visible = debug
	target_speed = randf_range(min_speed_limit , max_speed_limit)
	
	super()


func update_waypoint() -> void:
	if global_position.distance_to(targeted_waypoint) < waypoint_distance:
		set_next_waypoint(_next_waypoint.next_waypoint)


func set_next_waypoint(wp: Waypoint) -> void:
	_next_waypoint = wp
	targeted_waypoint = wp.global_position
	target_sprite.global_position = targeted_waypoint



func _physics_process(delta: float) -> void:
	if !_next_waypoint:
		return
	if _state == CarState.SLIPPING:
		update_waypoint()
	if _state != CarState.DRIVING: return
	
	
	var ta: float = (targeted_waypoint - global_position).angle()
	rotation = lerp_angle(rotation, ta, steer_reaction * delta)
	_velocity = lerp(_velocity, target_speed, delta)
	position += transform.x * _velocity * delta
	
	update_waypoint()
