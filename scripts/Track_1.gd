extends Node

class_name Track

@onready var track_path: Path2D = $"track path"
@onready var cars_holder: Node = $"Cars holder"
@onready var verification_holder: Node = $"Verification holder"

var _track_curve: Curve2D

func _ready() -> void:
	_track_curve = track_path.curve
	
	for car in cars_holder.get_children():
		if car is Red_car:
			car.setup(verification_holder.get_children().size())

func _path_direction(from_pos: Vector2) -> Vector2:
	var closest_offset: float = _track_curve.get_closest_offset(from_pos)
	var nearest_point: Vector2 = _track_curve.sample_baked(closest_offset)
	return from_pos.direction_to(nearest_point)


func _on_track_collision_area_entered(area: Area2D) -> void:
	if area is Red_car: area.hit_boundry(_path_direction(area.position))
	


func _on_start_line_area_entered(area: Area2D) -> void:
	if area is Red_car: area.lap_completed()
