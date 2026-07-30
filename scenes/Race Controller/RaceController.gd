extends Node


class_name RaceController

@export var total_laps: int = 5
@export var current_track: String

@onready var race_controller: RaceController = $"."
@onready var race_over_timer: Timer = $RaceOverTimer
@onready var winning_label: Label = $"../UiCanvas/winning_label"
@onready var winning_label_2: Label = $"../UiCanvas/winning_label2"
@onready var winning_label_3: Label = $"../UiCanvas/winning_label3"


var cars: Array[Car] = []
var track_curve: Curve2D
var _race_data: Dictionary[Car, CarRaceData] = {}
var started: bool = false
var finished: bool = false
var start_time: float
var winner_time: float = 10000000000
var winner_car: String


func setup(_cars: Array[Car], _track_curve: Curve2D):
	cars = _cars
	track_curve = _track_curve
	for c in _cars:
		_race_data[c] = CarRaceData.new(
			c.car_name, c.car_number, total_laps
		)
	print("Race_Controller init with %d cars" % _cars.size())


func _enter_tree() -> void:
	EventHub.on_lap_completed.connect(emit_on_lap_completion)
	EventHub.on_race_start.connect(on_race_start)
	


func on_race_start() -> void:
	if started:
		return
	started = true
	finished  = false
	start_time = Time.get_ticks_msec()

func get_elapsed_time() -> float:
	return   Time.get_ticks_msec() - start_time

func emit_on_lap_completion(info: LapCompleteData) -> void:
	print("RaceController on_lap_completed:", info)
	if not started or finished: return
	
	var car: Car = info.car
	var rd: CarRaceData = _race_data[car]
	rd.add_lap_time(info.lap_time)
	EventHub.emit_on_lap_update(
		car,
		rd._completed_laps,
		info.lap_time
	)
	
	if car is PlayerCar:
		GameManager.save_best_lap(info.lap_time)
	
	if rd.race_completed:
		print("race finnished")
		car.change_state(Car.CarState.RACEOVER)
		rd.set_total_time(get_elapsed_time())
		if race_over_timer.is_stopped(): race_over_timer.start()


func finish_race() -> void:
	if finished: return
	finished = true
	
	var total_len: float = track_curve.get_baked_length()
	for c in cars:
		var rd: CarRaceData = _race_data[c]
		var elapesed: float = Time.get_ticks_msec() - start_time
		if not rd.race_completed:
			var offset: float = track_curve.get_closest_offset(c.global_position)
			var progress: float = offset / total_len 
			rd.force_finish(elapesed, progress)
			c.change_state(Car.CarState.RACEOVER)
		
		if rd.total_time != 0 && rd.total_time < winner_time:
			winner_time = rd.total_time
			winner_car = rd.car_name
		
		
	var results: Array[CarRaceData] = _race_data.values()
	results.sort_custom(CarRaceData.compare)
	EventHub.emit_on_race_over(results)
	
	print(winner_car,": ", winner_time)
	if winner_car == GlobalVars.player_name:
		
		winning_label.visible = true
		winning_label_2.visible = true
		winning_label_3.visible = true
		
		match current_track:
			"Indy":
				GlobalVars.wins = 1
				print("added")
			"Monza":
				GlobalVars.wins = 2
				print("added")
			"Monaco":
				GlobalVars.wins = 3
				print("added")
			"Silverstone":
				GlobalVars.wins = 4
				print("added")



func _on_race_over_timer_timeout() -> void:
	finish_race()
