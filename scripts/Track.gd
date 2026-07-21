extends Node

class_name Track

@onready var track_path: Path2D = $"track path"
@onready var cars_holder: Node = $"Cars holder"
@onready var verification_holder: Node = $"Verification holder"
@onready var track_processor: TrackProcessor = $"track path/TrackProcessor"
@onready var way_points_holder: Node = $"WayPoints holder"
@onready var race_controller: Race_Controller = $RaceController

var track_curve: Curve2D

func _ready() -> void:
	await setup()



func setup() -> void:
	var cars: Array[Car] = []
	track_curve = track_path.curve
	
	track_processor.build_waypoin_data(way_points_holder)
	
	await track_processor.biuld_completed
	print("track_processor.biuld_completed")
	
	for car in cars_holder.get_children():
		cars.append(car)
		if car is Car:
			car.setup(verification_holder.get_children().size())
		if car is CPU_Car:
			car.set_next_waypoint(track_processor.first_waypoint)
	
	race_controller.setup(cars, track_curve)
	
	




func _path_direction(from_pos: Vector2) -> Vector2:
	var closest_offset: float = track_curve.get_closest_offset(from_pos)
	var nearest_point: Vector2 = track_curve.sample_baked(closest_offset)
	return from_pos.direction_to(nearest_point)


func _on_track_collision_area_entered(area: Area2D) -> void:
	if area is Car: area.hit_boundry(_path_direction(area.position))
	


func _on_start_line_area_entered(area: Area2D) -> void:
	if area is Car: area.lap_completed()
