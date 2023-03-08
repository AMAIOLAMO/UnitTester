# UnitTester
A really simple unit testing library for godot 4

## example setup:
1. clone / download this lib into your project

2. create a scene for testing

3. create a script on the root node of the scene as the main test script

4. extend the script from `GameTest`

5. create a function with the prefix of "test_" and start testing!

6. run the scene and check the output console of godot to see the results!


## Example script:

```gdscript
extends GameTest

func before_all() -> void:
	print("calls before all tests!")

func before_test() -> void:
	print("calls before every test!")

func after_test() -> void:
	print("calls after every test!")

func after_all() -> void:
	print("calls after all tests!")


### actual tests ###

# DO NOTE:
# only functions that has prefix of "test_" will be included

func test_just_pass() -> void:
	print("this test just passes!")
	assert_pass()

func test_just_fails() -> void:
	print("this test just fails!")
	assert_fail()

func test_some_value() -> void:
	assert_eq("Hello!", "Not so Hello.")

func test_multiple_asserts() -> void:
	assert_eq("Hello!", "Not so Hello.")
	assert_eq("Correct!", "Correct!")

func test_categorizing() -> void:
	categorize("This is a Foo category")
	
	assert_eq("Correct!", "Correct!")


func not_included_in_tests() -> void:
	categorize("Not included in tests")
	
	assert_eq("No effect!", "")
	
	# this will not be called in tests as the function name is not prefixed with "test_"

```
