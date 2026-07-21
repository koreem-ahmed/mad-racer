extends Node


class_name Race_Controller

@export var total_laps: int = 5

@onready var race_controller: Race_Controller = $"."
@onready var race_over_timer: Timer = $RaceOverTimer


var cars: Array[Car] = []
var track_curve: Curve2D
var _race_data: Dictionary[Car, CarRaceData] = {}
var started: bool = false
var finished: bool = false
var start_time: float


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
			pass
			

func _on_race_over_timer_timeout() -> void:
	finish_race()
