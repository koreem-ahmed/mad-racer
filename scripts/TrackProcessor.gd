extends PathFollow2D


class_name TrackProcessor


signal biuld_completed


const WAYPOINT = preload("res://scenes/WayPoint.tscn")


@export var interval: float = 50.0
@export var grid_space: float = 75.0



var _waypoints: Array[Waypoint]


var first_waypoint: Waypoint:
	get:
		if _waypoints.size() == 0:
			printerr("Track_Proccessor: First waypoint missing") 
			return null
		return _waypoints[0]

func connect_waypoints() -> void:
	var total_wp: int = _waypoints.size()
	for i in range(total_wp):
		var prev_ix: int = (i - 1 + total_wp) % total_wp
		var next_ix: int = (i + 1) % total_wp
		_waypoints[i].setup(_waypoints[next_ix], _waypoints[prev_ix], i)
		
		

func create_waypoint() -> Waypoint:
	var wp: Waypoint = WAYPOINT.instantiate()
	wp.global_position = global_position
	wp.rotation_degrees = global_rotation_degrees + 90.0
	return wp
	


func generate_waypoints(holder: Node) -> void:
	var path2d: Path2D = get_parent()
	progress = interval
	while progress < path2d.curve.get_baked_length() - grid_space:
		var wp: Waypoint = create_waypoint()
		holder.add_child(wp)
		_waypoints.append(wp)
		progress += interval
	
	await get_tree().physics_frame

func build_waypoin_data(holder: Node) -> void:
	_waypoints.clear()
	await generate_waypoints(holder)
	connect_waypoints()
	for wp in _waypoints:
		print(wp)
	
	biuld_completed.emit()
