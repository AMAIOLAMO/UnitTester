## base class of a test
class_name GameTest extends Node

# Refactor list:
# 	- code is really hard to read rn, should refactor
# 	- the test result does not account for any crashes in the code
#		(catching of exceptions / panics)
# 	- include categories for tests (maybe pass in a meta builder for tests?)
#	- refactor the asserter out, without passing it into the actual test


### === Meta Builder === ###

func categorize(category: String) -> void:
	_meta_builder.record_category(category)


### === OVERRIDABLES === ###

## called before all tests are ran
func before_all() -> void:
	pass

## called before any test
func before_test() -> void:
	pass

## called after any test
func after_test() -> void:
	pass

## called after all tests are finished
func after_all() -> void:
	pass

### === Assertions === ###

func assert_eq(expected, actual) -> void:
	_assertion_recorder.eq(expected, actual)

func assert_not_eq(expected, actual) -> void:
	_assertion_recorder.not_eq(expected, actual)

func assert_is_not_null(actual) -> void:
	_assertion_recorder.is_not_null(actual)

func assert_is_null(actual) -> void:
	_assertion_recorder.is_null(actual)

func assert_pass() -> void:
	_assertion_recorder.assert_pass()

func assert_fail(message: String = "assertion failed manually") -> void:
	_assertion_recorder.assert_fail(message)



### === IMPLEMENTATION === ###

# Todo:
#	Remove primitive obsession [test_method] here
func _call_single_test(test_method: Dictionary) -> TestResult:
	var test_method_name: String = test_method["name"]
	
	# var asserter := Asserter.new()
	
	_assertion_recorder.clear()
	_meta_builder.clear()
	
	var execution_timer := ExecutionTimer.start_new()
	call(test_method_name)
	execution_timer.stop()
	
	var assertion_results := _assertion_recorder.get_assert_results()
	
	var test_meta := _meta_builder.get_test_meta()
	
	var execution_time_ms := execution_timer.get_time_ms()
	
	var test_result := TestResult.new(test_method, execution_time_ms, assertion_results, test_meta)
	
	return test_result

var _assertion_recorder := AssertionRecorder.new()
var _meta_builder := TestMetaBuilder.new()



### === COVERED METHODS === ###

func _ready() -> void:
	await get_tree().process_frame
	_start_tests()



func _start_tests() -> void:
	print("==== tests started ====\n")
	
	before_all()
	
	_during_tests()
	
	after_all()
	
	print("==== tests complete ====")

func _during_tests() -> void:
	var test_results: Array[TestResult] = _call_all_tests()
	
	var formatter := get_test_formatter()
	
	var result_output := formatter.format_test_results(test_results)
	
	get_test_output().output(result_output)


func _call_all_tests() -> Array[TestResult]:
	var test_method_list := _get_test_method_list()
	
	var test_results: Array[TestResult] = []
	
	for test_method in test_method_list:
		before_test()
		var test_result := _call_single_test(test_method)
		after_test()
		
		test_results.append(test_result)
	
	return test_results


func _get_test_method_list() -> Array[Dictionary]:
	var method_list = get_method_list()
	
	var result_test_method_list: Array[Dictionary] = []
		
	for method in method_list:
		var method_name: String = method["name"]
		
		if method_name.begins_with("test_"):
			result_test_method_list.append(method)
		
	return result_test_method_list

func get_test_formatter() -> TestFormatter:
	return _formatter




func set_test_output(output: TestOutput) -> void:
	_output = output

func get_test_output() -> TestOutput:
	return _output

var _formatter: TestFormatter = TestFormatter.new()
var _output: TestOutput = DefaultOutput.new()




class DefaultOutput extends TestOutput:
	func output(result_string: String) -> void:
		print_rich(result_string)




class InterfaceAsserter extends Object:
	func _init(interface_methods: Array[InterfaceMethod]) -> void:
		_interface_methods = interface_methods
	
	func assert_object(object: Object) -> void:
		for interface_method in _interface_methods:
			interface_method.assert_object(object)
	
	var _interface_methods: Array[InterfaceMethod]


class InterfaceMethod extends Object:
	func _init(method_name: String) -> void:
		_method_name = method_name
	
	func assert_object(object: Object) -> void:
		assert(object.has_method(_method_name), "object %s does not implement interface method: %s" % [object.get_script(), _method_name])

	var _method_name: StringName





class TestMetaBuilder extends Object:
	func clear() -> void:
		_category = "Default"
	
	func record_category(category: String) -> void:
		_category = category
	
	func get_test_meta() -> TestMeta:
		return TestMeta.new(_category)

	var _category: String




# represents an object which tracks assertion results
class AssertionRecorder extends Object:
	func clear() -> void:
		_assertion_results.clear()
	
	func eq(expected, actual) -> void:
		condition_true(
			expected == actual,
			"expected to be [color=aqua]\"%s\"[/color], but got [color=aqua]\"%s\"[/color] instead" % [expected, actual]
		)


	func not_eq(expected, actual) -> void:
		condition_true(
			expected != actual,
			"expected to be not equal to [color=aqua]%s[/color], but got [color=aqua]%s[/color] instead" % [expected, actual]
		)


	func is_null(actual) -> void:
		condition_true(
			actual == null,
			"expected to be [color=yellow]NULL[/color], but got [color=aqua]%s[/color] instead" % [actual]
		)

	func is_not_null(actual) -> void:
		condition_true(
			actual != null,
			"expected to be not [color=yellow]NULL[/color], but got [color=white]NULL[/color]"
		)

	func float_eq_approx(expected: float, actual: float) -> void:
		condition_true(
			is_equal_approx(expected, actual),
			"expected to be equal approx to [color=aqua]%s[/color], but got [color=aqua]%s[/color] instead" % [expected, actual]
		)

	func float_not_eq_approx(expected: float, actual: float) -> void:
		condition_true(
			not is_equal_approx(expected, actual),
			"expected to be NOT equal approx to [color=aqua]%s[/color], but got [color=aqua]%s[/color] instead" % [expected, actual]
		)


	func condition_true(condition: bool, failed_message: String) -> void:
		if condition:
			assert_pass()
			return
		# else
		
		assert_fail(failed_message)


	func assert_pass() -> AssertResult:
		var result := AssertResult.new(true, "")
		_assertion_results.append(result)
		
		return result

	func assert_fail(message: String) -> AssertResult:
		var result := AssertResult.new(false, message)
		_assertion_results.append(result)
		
		return result

	func get_assert_results() -> Array[AssertResult]:
		return _assertion_results
	
	var _assertion_results: Array[AssertResult] = []

