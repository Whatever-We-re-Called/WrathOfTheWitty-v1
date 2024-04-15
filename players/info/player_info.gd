class_name PlayerInfo extends Resource

@export_category("Visuals")
@export var name: String
@export var sprite_frames: SpriteFrames
@export var sprite_scale: Vector2 = Vector2.ONE
@export_category("Insecurities")
@export var insecurity_weaknesses: Array[Constants.Insecurity]
@export var insecurity_strengths: Array[Constants.Insecurity]
@export var insecurity_blocks: Array[Constants.Insecurity]
@export_category("Stats")
@export var health_stat: int
@export var stamina_stat: int
@export var hand_stat: int
@export var speed_stat: int
@export var attack_stat: int
@export var support_stat: int
@export var hide_magic_stat: int
@export var weaken_magic_stat: int
@export var poison_magic_stat: int
@export var burn_magic_stat: int
@export var freeze_magic_stat: int
@export var slime_magic_stat: int
@export_category("Resources")
@export var action_card_deck: Array[CardInfo]
@export var template_card_deck: Array[TemplateCardInfo]
@export var equipped_blessings: Array[EquippedBlessing]

var current_player_instance = null
var current_health: int = -1


func init_unhandled_equipped_blessings():
	for equipped_blessing in equipped_blessings:
		equipped_blessing.blessing.init(self)
		while equipped_blessing.equipped_stack < equipped_blessing.stack:
			equipped_blessing.equipped_stack += 1
			equipped_blessing.blessing.equipped.emit(equipped_blessing.equipped_stack)


func emit_battle_started_blessing_signal():
	for equipped_blessing in equipped_blessings:
		equipped_blessing.blessing.battle_started.emit(equipped_blessing.stack)


func emit_battle_ended_blessing_signal():
	for equipped_blessing in equipped_blessings:
		equipped_blessing.blessing.battle_ended.emit(equipped_blessing.stack)


func emit_turn_started_blessing_signal():
	for equipped_blessing in equipped_blessings:
		equipped_blessing.blessing.turn_started.emit(equipped_blessing.stack)


func emit_turn_ended_blessing_signal():
	for equipped_blessing in equipped_blessings:
		equipped_blessing.blessing.turn_started.emit(equipped_blessing.stack)
