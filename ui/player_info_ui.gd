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
@onready var hide_value_label = %HideValueLabel
@onready var poison_value_label = %PoisonValueLabel
@onready var burn_value_label = %BurnValueLabel
@onready var freeze_value_label = %FreezeValueLabel
@onready var slime_value_label = %SlimeValueLabel
@onready var insecurity_icons = {
	Constants.Insecurity.APPEARANCE: %AppearanceIcon,
	Constants.Insecurity.SELF_ESTEEM: %SelfEsteemIcon,
	Constants.Insecurity.INTELLIGENCE: %IntelligenceIcon,
	Constants.Insecurity.PHYSICAL_ABILITY: %PhysicalAbilityIcon,
	Constants.Insecurity.SOCIAL_LIFE: %SocialLifeIcon
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
@onready var template_hand_value_label = %TemplateHandValueLabel
@onready var hide_dividend_label = %HideDividendLabel
@onready var slime_dividend_label = %SlimeDividendLabel
@onready var poison_dividend_label = %PoisonDividendLabel
@onready var burn_dividend_label = %BurnDividendLabel
@onready var freeze_dividend_label = %FreezeDividendLabel
@onready var health_max_label = %HealthMaxLabel
@onready var stamina_max_label = %StaminaMaxLabel
@onready var hand_max_label = %HandMaxLabel
@onready var template_hand_max_label = %TemplateHandMaxLabel

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
	health_value_label.text = str(player_info.current_player_instance.health)
	health_max_label.text = str(player_info.health_stat)
	stamina_value_label.text = str(player_info.current_player_instance.stamina)
	stamina_max_label.text = str(player_info.stamina_stat)
	hand_value_label.text = str(player_info.current_player_instance.cards_in_hand.size())
	hand_max_label.text = str(player_info.action_hand_stat)
	template_hand_value_label.text = str(player_info.current_player_instance.template_cards_in_hand.size())
	template_hand_max_label.text = str(player_info.template_hand_stat)
	speed_value_label.text = str(player_info.speed_stat)
	
	hide_value_label.text = str(player_info.hide_effect_stat)
	hide_dividend_label.text = str(player_info.hide_dividend_stat)
	slime_value_label.text = str(player_info.slime_effect_stat)
	slime_dividend_label.text = str(player_info.slime_dividend_stat)
	poison_value_label.text = str(player_info.poison_effect_stat)
	poison_dividend_label.text = str(player_info.poison_dividend_stat)
	burn_value_label.text = str(player_info.burn_effect_stat)
	burn_dividend_label.text = str(player_info.burn_dividend_stat)
	freeze_value_label.text = str(player_info.freeze_effect_stat)
	freeze_dividend_label.text = str(player_info.freeze_dividend_stat)
	
	var insecurity_affinities = player_info.get_insecurity_affinities()
	# https://github.com/godotengine/godot/issues/85882
	# Can't cast an enum to a god damn int for some reason?
	for i in range(Constants.Insecurity.keys().size()):
		if insecurity_affinities.has(i):
			insecurity_icons[i].texture = Constants.get_insecurity_icon(insecurity_affinities[i])
		else:
			insecurity_icons[i].texture = Constants.get_insecurity_icon(Constants.InsecurityAffinityType.NONE)
		insecurity_icons[i].modulate = Constants.get_insecurity_color(i)
		


func _init_blessings_page(player_info: PlayerInfo):
	for child in blessings_grid_container.get_children():
		child.queue_free()
	
	var cosmic_blessings_count = 0
	for equipped_blessing in player_info.equipped_blessings:
		if equipped_blessing.blessing.is_cosmic:
			cosmic_blessings_count += 1
	cosmic_blessings_value_label.text = str(cosmic_blessings_count)
	
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
		if equipped_blessing.blessing.is_cosmic:
			hovered_name += " (Cosmic)"
			texture_rect.modulate = Blessing.COSMIC_COLOR
			cosmic_texture_rects.append(texture_rect)
		else:
			texture_rect.modulate = Blessing.NORMAL_COLOR
			normal_texture_rects.append(texture_rect)
		var hovered_info = equipped_blessing.blessing.description
		texture_rect.tooltip_text = equipped_blessing.blessing.get_tooltip()
	
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
	
	var cards_in_hand = player_info.current_player_instance.cards_in_hand.size()
	action_cards_hand_label.text = "Hand (" + str(cards_in_hand) + "):"
	for card_info in player_info.current_player_instance.cards_in_hand:
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
