extends Node2D


class_name Waypoint

@onready var right_collision: RayCast2D = $Right_Collision
@onready var left_collision: RayCast2D = $Left_Collision
@onready var debuging_label: Label = $Label_for_debug


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

func _to_string() -> String:
	return "%d next:%d prev:%d" % [number, next_waypoint.number, prev_waypoint.number]
