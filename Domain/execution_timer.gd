## represents a high precision timer
class_name ExecutionTimer extends Object

static func start_new() -> ExecutionTimer:
	var new_timer := ExecutionTimer.new()
	
	new_timer.restart()
	
	return new_timer

func restart() -> void:
	_start_time = Time.get_unix_time_from_system()

func stop() -> void:
	_end_time = Time.get_unix_time_from_system()

func get_time_ms() -> float:
	return (_end_time - _start_time) * 1000.0

var _start_time: float
var _end_time: float
