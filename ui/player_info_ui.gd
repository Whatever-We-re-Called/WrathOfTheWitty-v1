extends CenterContainer

@onready var name_label = %NameLabel
@onready var buttons = [
	%StatsButton,
	%BlessingsButton,
	%ActionCardsButton,
	%TemplateCardsButton
]
@onready var tab_containers = [
	%PlayerStatsInfoUI,
	%BlessingsInfoUI,
	%ActionCardsInfoUI,
	%TemplateCardsInfoUI
]
@onready var health_value_label = %HealthValueLabel
@onready var stamina_value_label = %StaminaValueLabel
@onready var hand_value_label = %HandValueLabel
@onready var speed_value_label = %SpeedValueLabel
@onready var attack_value_label = %AttackValueLabel
@onready var support_value_label = %SupportValueLabel
@onready var hide_value_label = %HideValueLabel
@onready var weaken_value_label = %WeakenValueLabel
@onready var poison_value_label = %PoisonValueLabel
@onready var burn_value_label = %BurnValueLabel
@onready var freeze_value_label = %FreezeValueLabel
@onready var slime_value_label = %SlimeValueLabel
@onready var insecurity_containers = {
	Constants.Insecurity.PHYSICAL_APPEARANCE: %PhysicalAppearanceContainer,
	Constants.Insecurity.SELF_ESTEEM: %SelfEsteemContainer,
	Constants.Insecurity.INTELLIGENCE: %IntelligenceContainer,
	Constants.Insecurity.PHYSICAL_ABILITY: %PhysicalAbilityContainer,
	Constants.Insecurity.SOCIAL_LIFE: %SocialLifeContainer,
	Constants.Insecurity.FASHION: %FashionContainer
}
@onready var insecurity_labels = {
	Constants.Insecurity.PHYSICAL_APPEARANCE: %PhysicalAppearanceLabel,
	Constants.Insecurity.SELF_ESTEEM: %SelfEsteemLabel,
	Constants.Insecurity.INTELLIGENCE: %IntelligenceLabel,
	Constants.Insecurity.PHYSICAL_ABILITY: %PhysicalAbilityLabel,
	Constants.Insecurity.SOCIAL_LIFE: %SocialLifeLabel,
	Constants.Insecurity.FASHION: %FashionLabel
}
@onready var hovered_info_container = %HoveredInfoContainer
@onready var hovered_name_label = %HoveredNameLabel
@onready var hovered_info_label = %HoveredInfoLabel
@onready var blessings_grid_container = %BlessingsGridContainer

func _ready():
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_set_open_tab_index.bind(i))


func init(player_info: PlayerInfo):
	_set_open_tab_index(0)
	
	name_label.text = player_info.name + "'s Stats"
	_init_stats_page(player_info)
	_init_blessings_page(player_info)


func _set_open_tab_index(index: int):
	for tab in tab_containers:
		tab.visible = false
	tab_containers[index].visible = true
	
	for i in range(buttons.size()):
		buttons[i].disabled = i == index


func _init_stats_page(player_info: PlayerInfo):
	health_value_label.text = str(player_info.health_stat)
	stamina_value_label.text = str(player_info.stamina_stat)
	hand_value_label.text = str(player_info.hand_stat)
	speed_value_label.text = str(player_info.speed_stat)
	attack_value_label.text = str(player_info.attack_stat)
	support_value_label.text = str(player_info.support_stat)
	
	hide_value_label.text = str(player_info.hide_magic_stat)
	weaken_value_label.text = str(player_info.weaken_magic_stat)
	poison_value_label.text = str(player_info.poison_magic_stat)
	burn_value_label.text = str(player_info.burn_magic_stat)
	freeze_value_label.text = str(player_info.freeze_magic_stat)
	slime_value_label.text = str(player_info.slime_magic_stat)
	
	for insecurity_container in insecurity_containers.values():
		insecurity_container.visible = false
	for insecurity in player_info.insecurity_weaknesses:
		insecurity_containers[insecurity].visible = true
		insecurity_labels[insecurity].text = "Weak"
	for insecurity in player_info.insecurity_strengths:
		insecurity_containers[insecurity].visible = true
		insecurity_labels[insecurity].text = "Strong"
	for insecurity in player_info.insecurity_blocks:
		insecurity_containers[insecurity].visible = true
		insecurity_labels[insecurity].text = "Block"


func _init_blessings_page(player_info: PlayerInfo):
	for child in blessings_grid_container.get_children():
		child.queue_free()
	
	for equipped_blessing in player_info.equipped_blessings:
		var texture_rect = TextureRect.new()
		texture_rect.texture = equipped_blessing.blessing.texture
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.custom_minimum_size = Vector2(96, 96)
		# TODO Color for Cosmic Blessing
		var color = Color("#e59544")
		texture_rect.modulate = color
		
		var hovered_name = equipped_blessing.blessing.name
		var hovered_info = equipped_blessing.blessing.description
		texture_rect.mouse_entered.connect(_show_blessings_hovered_info.bind(hovered_name, hovered_info, color))
		texture_rect.mouse_exited.connect(_hide_blessings_hovered_info)
		
		blessings_grid_container.add_child(texture_rect)


func _show_blessings_hovered_info(name: String, info: String, color: Color):
	print(color)
	hovered_info_container.visible = true
	hovered_name_label.text = name
	hovered_name_label.label_settings.font_color = color
	hovered_info_label.text = info


func _hide_blessings_hovered_info():
	hovered_info_container.visible = false
