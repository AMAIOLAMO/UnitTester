## represents a result from a test
class_name AssertResult extends Object

func _init(is_success: bool, failed_message: String) -> void:
	_success = is_success
	_failed_message = failed_message
	pass

func get_success() -> bool:
	return _success

func get_failure_message() -> String:
	return _failed_message

var _success: bool
var _failed_message: String
