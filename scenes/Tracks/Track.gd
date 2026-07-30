extends Node

class_name Track

@onready var track_path: Path2D = $"track path"
@onready var cars_holder: Node = $"Cars holder"
@onready var verification_holder: Node = $"Verification holder"
@onready var track_processor: TrackProcessor = $"track path/TrackProcessor"
@onready var way_points_holder: Node = $"WayPoints holder"
@onready var race_controller: RaceController = $RaceController
@onready var game_ui: GameUi = $UiCanvas/GameUI
@onready var cpu_car: CPUCar = $"Cars holder/CPU Car"
@onready var cpu_car_2: CPUCar = $"Cars holder/CPU Car2"
@onready var cpu_car_3: CPUCar = $"Cars holder/CPU Car3"

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
		if car is CPUCar:
			car.set_next_waypoint(track_processor.first_waypoint)
	
	cars_texture()
	
	race_controller.setup(cars, track_curve)
	
	game_ui.setup(cars)
	


func cars_texture() -> void:
	match GlobalVars.player_car_texture:
		0:
			cpu_car.Cpu_texture = preload("res://assets/levels/Images/CarGreen.png")
			cpu_car_2.Cpu_texture = preload("res://assets/levels/Images/CarPurple.png")
			cpu_car_3.Cpu_texture = preload("res://assets/levels/Images/CarRed.png")
		1:
			cpu_car.Cpu_texture = preload("res://assets/levels/Images/CarBlue.png")
			cpu_car_2.Cpu_texture = preload("res://assets/levels/Images/CarPurple.png")
			cpu_car_3.Cpu_texture = preload("res://assets/levels/Images/CarRed.png")
		2:
			cpu_car.Cpu_texture = preload("res://assets/levels/Images/CarBlue.png")
			cpu_car_2.Cpu_texture = preload("res://assets/levels/Images/CarGreen.png")
			cpu_car_3.Cpu_texture = preload("res://assets/levels/Images/CarRed.png")
		3:
			cpu_car.Cpu_texture = preload("res://assets/levels/Images/CarBlue.png")
			cpu_car_2.Cpu_texture = preload("res://assets/levels/Images/CarPurple.png")
			cpu_car_3.Cpu_texture = preload("res://assets/levels/Images/CarGreen.png")


func _path_direction(from_pos: Vector2) -> Vector2:
	var closest_offset: float = track_curve.get_closest_offset(from_pos)
	var nearest_point: Vector2 = track_curve.sample_baked(closest_offset)
	return from_pos.direction_to(nearest_point)


func _on_track_collision_area_entered(area: Area2D) -> void:
	if area is Car: area.hit_boundry(_path_direction(area.position))
	


func _on_start_line_area_entered(area: Area2D) -> void:
	if area is Car: area.lap_completed()
