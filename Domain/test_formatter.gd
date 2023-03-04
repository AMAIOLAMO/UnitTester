class_name TestFormatter extends Object

func format_test_result(test_result: TestResult) -> String:
	var assert_results: Array[AssertResult] = test_result.get_assert_results()
		
	var test_method: Dictionary = test_result.get_test_method()
	var test_method_name: String = test_method["name"]
	
	var execution_time_ms: float = test_result.get_execution_time_ms()
	
	
	# UGLY hardcoded values, could extract into a formatting class
	var result_output := "[color=#f5c275][%.2f ms][/color]" % execution_time_ms
	
	result_output += " [color=#77c5f9][u][b]%s:[/b][/u][/color] " % test_method_name
	
	result_output = BBCodeUtils.wrap_tag_value(result_output, "font_size", "15")
	
	for assert_result in assert_results:
		var output_string := _parse_assert_result_to_output_string(assert_result)
		var status_string := "✅" if assert_result.get_success() else "❎"
		
		result_output += "\n\t%s %s" % [status_string, output_string]
	
	return result_output

# Refactor:

func _parse_assert_result_to_output_string(assert_result: AssertResult) -> String:
	var assertion_success := assert_result.get_success()
	var failed_message := assert_result.get_failure_message()
	
	if assertion_success:
		return "[color=green]SUCCESS[/color]"
	else:
		return "[u][color=#fc5f6d]%s[/color][/u]" % failed_message







class BBCodeUtils:
	static func wrap_tag_value(content: String, tag: String, value: String) -> String:
		return "[%s=%s]%s[/%s]" % [tag, value, content, tag]
