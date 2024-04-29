class_name EquippedTemplateCard extends Resource

@export var template_card_info: TemplateCardInfo
@export var is_upgraded: bool
@export var insecurity_overrides: Array[Constants.Insecurity]

var is_init: bool = false


func init():
	if is_init: return
	
	template_card_info = template_card_info.duplicate(true)
	_init_insecurities()
	
	is_init = true


func _init_insecurities():
	# Handle overrides.
	for insecurity in insecurity_overrides:
		if template_card_info.insecurity_count > template_card_info.insecurities.size():
			template_card_info.insecurities.append(insecurity)
	
	# Handle generating the random rest.
	var rng = RandomNumberGenerator.new()
	while template_card_info.insecurities.size() < template_card_info.insecurity_count:
		var result = rng.randi_range(0, 5)
		while template_card_info.insecurities.has(result):
			result = rng.randi_range(0, 5)
		template_card_info.insecurities.append(result)
