class_name TemplateCardInfo extends Resource

@export_category("Identity")
@export var name: String
@export_multiline var info_description: String
@export var background_color: Color
@export_category("Execution")
@export var insecurity: Constants.Insecurity
@export_multiline var sentence: String
@export var execute_function_name: String
@export var power_enhanced: bool
