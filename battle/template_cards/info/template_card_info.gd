class_name TemplateCardInfo extends Resource

@export_category("Template Card Identity")
@export var name: String:
	get:
		return _name + "+" if is_upgraded else _name
	set(value):
		_name = value
@export_multiline var sentence: String
@export_multiline var nonupgraded_description: String
@export_multiline var upgraded_description: String
@export var background_color: Color
@export_category("Template Card Execution")
@export var insecurity_count: int
@export var execute_function_name: String

var is_upgraded = false
var insecurities: Array[Constants.Insecurity]
var _name: String
var description: String:
	get:
		if is_upgraded:
			return upgraded_description
		else:
			return nonupgraded_description
