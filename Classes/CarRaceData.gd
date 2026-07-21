extends Object


class_name CarRaceData

const DEFAULT_LAPTIME: float = 999.99

var car_number: int
var car_name: String
var total_time: float = 0.0
var completed_laps: int
var partial_progress: float = 0.0
var best_lap: float = DEFAULT_LAPTIME
var target_laps: int = 0


var race_completed: bool:
	get: return completed_laps == target_laps

var total_progress: float:
	get: return completed_laps + partial_progress


func _init(_car_name: String, _car_number: int, _target_laps: int) -> void:
	car_name = _car_name
	car_number = _car_number
	target_laps = _target_laps	


func add_lap_time(lap_time: float) -> void:
	completed_laps += 1
	best_lap = min(best_lap, lap_time)
	


func set_total_time(_total_time: float) -> void:
	total_time = _total_time


func force_finish(_total_time: float, progress: float) -> void:
	partial_progress = progress
	total_time = _total_time
