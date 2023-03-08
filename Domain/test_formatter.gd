class_name TestFormatter extends Object

# Refactor Set;
#	- include results at the end after the tests are done

func format_test_results(test_results: Array[TestResult]) -> String:
	var result_output := ""
	
	test_results.sort_custom(_compare_test_result_category)
	
	var current_category := ""
	
	for test_result in test_results:
		var test_meta := test_result.get_test_meta()
		
		var test_category := test_meta.get_category()
		
		if current_category != test_category:
			current_category = test_category
			
			result_output += "[font_size=20][b][u]== %s ==[/u][/b][/font_size]\n" % current_category
		
		
		result_output += "\t%s\n" % _format_single_test_result(test_result)
	
	return result_output



func _format_single_test_result(test_result: TestResult) -> String:
	var assert_results: Array[AssertResult] = test_result.get_assert_results()
		
	var test_method: Dictionary = test_result.get_test_method()
	var test_method_name: String = test_method["name"]
	
	var execution_time_ms: float = test_result.get_execution_time_ms()

	var trimmed_test_method_name := test_method_name.right(test_method_name.length() - "test_".length())
	
	
	# UGLY hardcoded values, could extract into a formatting class
	var result_output := "[color=#f5c275][%.2f ms][/color]" % execution_time_ms
	
	result_output += " [color=#77c5f9][u][b]%s:[/b][/u][/color] " % trimmed_test_method_name
	
	result_output = BBCodeUtils.wrap_tag_value(result_output, "font_size", "15")
	
	for assert_result in assert_results:
		var output_string := _parse_assert_result_to_output_string(assert_result)
		var status_string := "✅" if assert_result.get_success() else "❎"
		
		result_output += "\n\t--> %s %s" % [status_string, output_string]
	
	result_output += "\n"
	
	return result_output

# Refactor:

func _parse_assert_result_to_output_string(assert_result: AssertResult) -> String:
	var assertion_success := assert_result.get_success()
	var failed_message := assert_result.get_failure_message()
	
	if assertion_success:
		return "[color=green]SUCCESS[/color]"
	else:
		return "[u][color=#fc5f6d]%s[/color][/u]" % failed_message





func _compare_test_result_category(a: TestResult, b: TestResult) -> bool:
	var a_test_meta := a.get_test_meta()
	var b_test_meta := b.get_test_meta()
	
	var a_category := a_test_meta.get_category()
	var b_category := b_test_meta.get_category()
	
	if a_category < b_category:
		return true
	# else
	
	return false





class BBCodeUtils:
	static func wrap_tag_value(content: String, tag: String, value: String) -> String:
		return "[%s=%s]%s[/%s]" % [tag, value, content, tag]
