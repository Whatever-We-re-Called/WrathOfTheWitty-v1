class_name PlayerInfo extends Resource

@export_category("Visuals")
@export var name: String
@export var sprite_frames: SpriteFrames
@export var sprite_scale: Vector2 = Vector2.ONE
@export_category("Base Stats")
@export var health_stat: int
@export var stamina_stat: int
@export var action_hand_stat: int
@export var template_hand_stat: int
@export var speed_stat: int
@export_category("Effect Stats")
@export var hide_effect_stat: int
@export var slime_effect_stat: int
@export var poison_effect_stat: int
@export var burn_effect_stat: int
@export var freeze_effect_stat: int
@export var hide_dividend_stat: int
@export var slime_dividend_stat: int
@export var poison_dividend_stat: int
@export var burn_dividend_stat: int
@export var freeze_dividend_stat: int
@export_category("Insecurity Stats")
@export var weak_insecurity_affinities: Array[Constants.Insecurity]
@export var strong_insecurity_affinities: Array[Constants.Insecurity]
@export var block_insecurity_affinities: Array[Constants.Insecurity]
@export var contempt_insecurity_affinities: Array[Constants.Insecurity]
@export var repel_insecurity_affinities: Array[Constants.Insecurity]
@export_category("Resources")
@export var action_card_deck: Array[CardInfo]
@export var equipped_template_cards: Array[EquippedTemplateCard]
@export var equipped_blessings: Array[EquippedBlessing]

var current_player_instance = null
var current_health: int = -1
var attack_buffs: Dictionary


func add_card(card_info: CardInfo):
	if attack_buffs.has(card_info.insecurity):
		card_info.attack_value += attack_buffs[card_info.insecurity]
	action_card_deck.append(card_info)


func add_template_card(equipped_template_card: EquippedTemplateCard):
	equipped_template_cards.append(equipped_template_card)


func remove_template_card(equipped_template_card: EquippedTemplateCard):
	for i in range(equipped_template_cards.size()):
		if equipped_template_card == equipped_template_cards[i]:
			equipped_template_cards.remove_at(i)
			break


func upgrade_template_card(equipped_template_card: EquippedTemplateCard):
	for e in equipped_template_cards:
		if e == equipped_template_card:
			e.is_upgraded = true
			e.template_card_info.is_upgraded = true


func add_blessing(blessing_type: Blessings.Type):
	var equipped_blessing = EquippedBlessing.new()
	equipped_blessing.type = blessing_type
	equipped_blessing.init(self)
	equipped_blessings.append(equipped_blessing)


func remove_blessing(equipped_blessing: EquippedBlessing):
	for i in range(equipped_blessings.size()):
		if equipped_blessing == equipped_blessings[i]:
			equipped_blessing.blessing.unequipped.emit()
			equipped_blessings.remove_at(i)
			break


func heal(amount: int):
	if current_health < 0: return
	
	current_health += amount
	current_health = clamp(current_health, 0, health_stat)


func init_unhandled_equipped_template_cards():
	for equipped_template_card in equipped_template_cards:
		if not equipped_template_card.is_init:
			equipped_template_card.init()


func init_unhandled_equipped_blessings():
	for equipped_blessing in equipped_blessings:
		if not equipped_blessing.is_init:
			equipped_blessing.init(self)


func get_template_card_info() -> Array[TemplateCardInfo]:
	var result: Array[TemplateCardInfo]
	for equipped_template_card in equipped_template_cards:
		result.append(equipped_template_card.template_card_info)
	return result


func emit_battle_started_blessing_signal():
	for equipped_blessing in equipped_blessings:
		equipped_blessing.blessing.battle_started.emit()


func emit_battle_ended_blessing_signal():
	for equipped_blessing in equipped_blessings:
		equipped_blessing.blessing.battle_ended.emit()


func emit_turn_started_blessing_signal():
	for equipped_blessing in equipped_blessings:
		equipped_blessing.blessing.turn_started.emit()


func emit_turn_ended_blessing_signal():
	for equipped_blessing in equipped_blessings:
		equipped_blessing.blessing.turn_ended.emit()


func emit_damaged_signal():
	for equipped_blessing in equipped_blessings:
		equipped_blessing.blessing.damaged.emit()


func emit_rerolled_card_signal():
	for equipped_blessing in equipped_blessings:
		equipped_blessing.blessing.rerolled_card.emit()


func has_blessing(type: Blessings.Type) -> bool:
	for equipped_blessing in equipped_blessings:
		if equipped_blessing.type == type:
			return true
	return false


func get_stack_size_of_blessing(type: Blessings.Type) -> int:
	var result = 0
	for equipped_blessing in equipped_blessings:
		if equipped_blessing.type == type:
			result += 1
	
	return result


func get_insecurity_affinities() -> Dictionary:
	var result: Dictionary
	for insecurity in weak_insecurity_affinities:
		result[insecurity] = Constants.InsecurityAffinityType.WEAK
	for insecurity in strong_insecurity_affinities:
		result[insecurity] = Constants.InsecurityAffinityType.STRONG
	for insecurity in block_insecurity_affinities:
		result[insecurity] = Constants.InsecurityAffinityType.BLOCK
	for insecurity in contempt_insecurity_affinities:
		result[insecurity] = Constants.InsecurityAffinityType.CONTEMPT
	for insecurity in repel_insecurity_affinities:
		result[insecurity] = Constants.InsecurityAffinityType.REPEL
	
	return result
