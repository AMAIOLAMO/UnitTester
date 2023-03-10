## result of a single function test
class_name TestResult extends Object

func _init(test_method: Dictionary, execution_time_ms: float, assert_results: Array[AssertResult], test_meta: TestMeta) -> void:
	_test_method = test_method
	_assert_results = assert_results
	_execution_time_ms = execution_time_ms
	_test_meta = test_meta
	

func get_test_method() -> Dictionary:
	return _test_method

func get_assert_results() -> Array[AssertResult]:
	return _assert_results

func get_execution_time_ms() -> float:
	return _execution_time_ms

func get_test_meta() -> TestMeta:
	return _test_meta

var _test_method: Dictionary
var _assert_results: Array[AssertResult]
var _execution_time_ms: float
var _test_meta: TestMeta
