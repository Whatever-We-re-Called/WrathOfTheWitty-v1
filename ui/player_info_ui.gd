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
	Constants.Insecurity.APPEARANCE: %PhysicalAppearanceContainer,
	Constants.Insecurity.SELF_ESTEEM: %SelfEsteemContainer,
	Constants.Insecurity.INTELLIGENCE: %IntelligenceContainer,
	Constants.Insecurity.PHYSICAL_ABILITY: %PhysicalAbilityContainer,
	Constants.Insecurity.SOCIAL_LIFE: %SocialLifeContainer
}
@onready var insecurity_labels = {
	Constants.Insecurity.APPEARANCE: %PhysicalAppearanceLabel,
	Constants.Insecurity.SELF_ESTEEM: %SelfEsteemLabel,
	Constants.Insecurity.INTELLIGENCE: %IntelligenceLabel,
	Constants.Insecurity.PHYSICAL_ABILITY: %PhysicalAbilityLabel,
	Constants.Insecurity.SOCIAL_LIFE: %SocialLifeLabel
}
@onready var hovered_info_container = %HoveredInfoContainer
@onready var hovered_name_label = %HoveredNameLabel
@onready var hovered_info_label = %HoveredInfoLabel
@onready var blessings_grid_container = %BlessingsGridContainer
@onready var action_cards_hand_grid_container = %ActionCardsHandGridContainer
@onready var action_cards_deck_grid_container = %ActionCardsDeckGridContainer
@onready var action_cards_bag_grid_container = %ActionCardsBagGridContainer
@onready var action_cards_hand_label = %ActionCardsHandLabel
@onready var action_cards_deck_label = %ActionCardsDeckLabel
@onready var action_cards_bag_label = %ActionCardsBagLabel
@onready var template_cards_hand_grid_container = %TemplateCardsHandGridContainer
@onready var template_cards_hand_label = %TemplateCardsHandLabel
@onready var template_cards_deck_label = %TemplateCardsDeckLabel
@onready var template_cards_deck_grid_container = %TemplateCardsDeckGridContainer
@onready var template_cards_bag_label = %TemplateCardsBagLabel
@onready var template_cards_bag_grid_container = %TemplateCardsBagGridContainer
@onready var close_button = %CloseButton
@onready var cosmic_blessings_value_label = %CosmicBlessingsValueLabel
@onready var normal_blessings_value_label = %NormalBlessingsValueLabel
@onready var cosmic_blessings_limit_value = %CosmicBlessingsLimitValue

const CARD_SCENE = preload("res://battle/cards/card.tscn")
const TEMPLATE_CARD_SCENE = preload("res://battle/template_cards/template_card.tscn")


func _ready():
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_set_open_tab_index.bind(i))
	
	close_button.pressed.connect(func(): self.visible = false)


func init(player_info: PlayerInfo):
	_set_open_tab_index(0)
	
	name_label.text = player_info.name + "'s Info"
	_init_stats_page(player_info)
	_init_blessings_page(player_info)
	_init_action_cards_page(player_info)
	_init_template_cards_page(player_info)


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
	
	var cosmic_blessings_count = 0
	for equipped_blessing in player_info.equipped_blessings:
		if equipped_blessing.is_cosmic:
			cosmic_blessings_count += 1
	cosmic_blessings_value_label.text = str(cosmic_blessings_count)
	cosmic_blessings_limit_value.text = str(player_info.cosmic_blessings_limit)
	
	var normal_blessings_count = player_info.equipped_blessings.size() - cosmic_blessings_count
	normal_blessings_value_label.text = str(normal_blessings_count)
	
	var cosmic_texture_rects = []
	var normal_texture_rects = []
	for equipped_blessing in player_info.equipped_blessings:
		var texture_rect = TextureRect.new()
		texture_rect.texture = equipped_blessing.blessing.texture
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.custom_minimum_size = Vector2(96, 96)
		
		var hovered_name = equipped_blessing.blessing.name
		var hovered_info = ""
		
		if equipped_blessing.is_cosmic:
			hovered_name += " (Cosmic)"
			hovered_info = equipped_blessing.blessing.cosmic_description
			texture_rect.modulate = Blessing.COSMIC_COLOR
			cosmic_texture_rects.append(texture_rect)
		else:
			hovered_info = equipped_blessing.blessing.normal_description
			texture_rect.modulate = Blessing.NORMAL_COLOR
			normal_texture_rects.append(texture_rect)
		
		texture_rect.tooltip_text = hovered_name + ": " + hovered_info
	
	for texture_rect in cosmic_texture_rects:
		blessings_grid_container.add_child(texture_rect)
	for texture_rect in normal_texture_rects:
		blessings_grid_container.add_child(texture_rect)


func _init_action_cards_page(player_info: PlayerInfo):
	for child in action_cards_hand_grid_container.get_children():
		child.queue_free()
	for child in action_cards_deck_grid_container.get_children():
		child.queue_free()
	for child in action_cards_bag_grid_container.get_children():
		child.queue_free()
	
	var cards_in_hand = player_info.current_player_instance.cards_in_hand.size() + player_info.current_player_instance.selected_cards.size()
	action_cards_hand_label.text = "Hand (" + str(cards_in_hand) + "):"
	for card_info in player_info.current_player_instance.cards_in_hand:
		var card = _get_card_instance(card_info)
		action_cards_hand_grid_container.add_child(card)
	for card_info in player_info.current_player_instance.selected_cards:
		var card = _get_card_instance(card_info)
		action_cards_hand_grid_container.add_child(card)
	action_cards_deck_label.text = "Deck (" + str(player_info.current_player_instance.cards_in_deck.size()) + "):"
	for card_info in player_info.current_player_instance.cards_in_deck:
		var card = _get_card_instance(card_info)
		action_cards_deck_grid_container.add_child(card)
	action_cards_bag_label.text = "Bag (" + str(player_info.current_player_instance.cards_in_bag.size()) + "):"
	for card_info in player_info.current_player_instance.cards_in_bag:
		var card = _get_card_instance(card_info)
		action_cards_bag_grid_container.add_child(card)


func _get_card_instance(card_info: CardInfo) -> Card:
	var new_card_scene = CARD_SCENE.instantiate()
	new_card_scene.card_info = card_info
	return new_card_scene


func _init_template_cards_page(player_info: PlayerInfo):
	for child in template_cards_hand_grid_container.get_children():
		child.queue_free()
	for child in template_cards_deck_grid_container.get_children():
		child.queue_free()
	for child in template_cards_bag_grid_container.get_children():
		child.queue_free()
	
	var cards_in_hand = player_info.current_player_instance.template_cards_in_hand.size()
	template_cards_hand_label.text = "Hand (" + str(cards_in_hand) + "):"
	for card_info in player_info.current_player_instance.template_cards_in_hand:
		var card = _get_template_card_instance(card_info)
		template_cards_hand_grid_container.add_child(card)
		card.remove_context_ui()
	template_cards_deck_label.text = "Deck (" + str(player_info.current_player_instance.template_cards_in_deck.size()) + "):"
	for card_info in player_info.current_player_instance.template_cards_in_deck:
		var card = _get_template_card_instance(card_info)
		template_cards_deck_grid_container.add_child(card)
		card.remove_context_ui()
	template_cards_bag_label.text = "Bag (" + str(player_info.current_player_instance.template_cards_in_bag.size()) + "):"
	for card_info in player_info.current_player_instance.template_cards_in_bag:
		var card = _get_template_card_instance(card_info)
		template_cards_bag_grid_container.add_child(card)
		card.remove_context_ui()


func _get_template_card_instance(template_card_info: TemplateCardInfo) -> TemplateCard:
	var new_template_card_scene = TEMPLATE_CARD_SCENE.instantiate()
	new_template_card_scene.template_card_info = template_card_info
	return new_template_card_scene
