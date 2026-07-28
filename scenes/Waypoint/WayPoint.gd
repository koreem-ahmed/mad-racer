extends Node2D


class_name Waypoint


const MAX_RADIUS: float = 300.0
const COLLISION_MARGIN: float = 10.0

@onready var right_collision: RayCast2D = $Right_Collision
@onready var left_collision: RayCast2D = $Left_Collision
@onready var debuging_label: Label = $Label_for_debug


var left_coll_dist: float = 0.0
var right_coll_dist: float = 0.0
var left_coll_dir: Vector2 = Vector2.ZERO
var right_coll_dir: Vector2 = Vector2.ZERO
var _max_path_deviation: float = 50.0


var radius: float = MAX_RADIUS:
	get: return radius


var radius_factor: float = 0.0:
	get: return radius_factor


var number: int = 0:
	get: return number


var next_waypoint: Waypoint:
	get:
		if !next_waypoint: print("WP %d no next_waypoint!!" % number)
		return next_waypoint


var prev_waypoint: Waypoint:
	get:
		if !prev_waypoint: print("WP %d no prev_waypoint!!" % number)
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


func set_collider_data(max_path_deviation: float) -> void:
	_max_path_deviation = max_path_deviation
	
	left_coll_dist = left_collision.target_position.length()
	right_coll_dist = right_collision.target_position.length()
	
	if left_collision.is_colliding():
		var col_point: Vector2 = left_collision.get_collision_point()
		left_coll_dist = global_position.distance_to(col_point) - COLLISION_MARGIN
		left_coll_dist = max(0, left_coll_dist)
	
	if left_collision.is_colliding():
		var col_point: Vector2 = right_collision.get_collision_point()
		right_coll_dist = global_position.distance_to(col_point) - COLLISION_MARGIN
		right_coll_dist = max(0, right_coll_dist)
	
	left_coll_dir = Vector2.LEFT.rotated(rotation)
	right_coll_dir = Vector2.RIGHT.rotated(rotation)


func get_target_adjusted(weight: float) -> Vector2:
	if is_zero_approx(weight): return global_position
	
	if weight > 0.0:
		var deviation: float = weight * right_coll_dist
		deviation = clampf(deviation, -_max_path_deviation, _max_path_deviation)
		return right_coll_dir * deviation * global_position
	else:
		var deviation: float = weight * left_coll_dist
		deviation = clampf(deviation, -_max_path_deviation, _max_path_deviation)
		
		return global_position - left_coll_dir * deviation
	


func _to_string() -> String:
	return "%d next:%d prev:%d rad:%.2f fac:%.2f lcd: %.2f rcd: %.2f" % [
		number, next_waypoint.number, prev_waypoint.number,
		radius, radius_factor, left_coll_dist, right_coll_dist
		]
	
