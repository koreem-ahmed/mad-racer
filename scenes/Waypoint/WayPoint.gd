extends Node2D


class_name Waypoint


const MAX_RADIUS: float = 300.0


@onready var right_collision: RayCast2D = $Right_Collision
@onready var left_collision: RayCast2D = $Left_Collision
@onready var debuging_label: Label = $Label_for_debug


var radius: float = MAX_RADIUS:
	get: return radius


var radius_factor: float = 0.0:
	get: return radius_factor


var number: int = 0:
	get: return number


var next_waypoint: Waypoint:
	get:
		if !next_waypoint: printerr("WP %d no next_waypoint!!" % number)
		return next_waypoint


var prev_waypoint: Waypoint:
	get:
		if !prev_waypoint: printerr("WP %d no prev_waypoint!!" % number)
		return prev_waypoint


func setup(next_wp: Waypoint, prev_wp: Waypoint, num: int) -> void:
	next_waypoint = next_wp
	prev_waypoint = prev_wp
	number = num
	debuging_label.text = "%d" % num


func calc_radius() -> void:
	var a: float = prev_waypoint.global_position.distance_to(global_position)
	var b: float = global_position.distance_to(next_waypoint.global_position)
	var c: float = next_waypoint.global_position.distance_to(prev_waypoint.global_position)
	var s: float = (a + b + c) / 2
	
	var area:float = sqrt( max( s * (s - a) * (s - b) * (s - c), 0.0) )
	
	if !is_zero_approx(area):
		radius = (a * b * c) / (4.0 * area)
	


func set_radius_factor(min_radius: float, radius_curve: Curve) -> void:
	var adj: float = clampf(radius, min_radius, MAX_RADIUS)
	var t: float = (adj - min_radius) / (MAX_RADIUS - min_radius)
	radius_factor = radius_curve.sample(t)


func _to_string() -> String:
	return "%d next:%d prev:%d rad:%.2f fac:%.2f" % [
		number, next_waypoint.number, prev_waypoint.number,
		radius, radius_factor
		]
	
