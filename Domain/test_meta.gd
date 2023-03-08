class_name TestMeta extends Object

func _init(category: String) -> void:
	_category = category

func get_category() -> String:
	return _category

var _category: String
