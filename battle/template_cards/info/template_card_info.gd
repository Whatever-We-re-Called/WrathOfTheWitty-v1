class_name TemplateCardInfo extends Resource

@export_category("Template Card Identity")
@export var name: String
@export_multiline var sentence: String
@export_multiline var info_description: String
@export var background_color: Color
@export_category("Template Card Execution")
@export var insecurities: Array[Constants.Insecurity]
@export var execute_function_name: String
@export_category("Template Card Upgrade")
@export var upgrade_template_card_info: TemplateCardInfo
