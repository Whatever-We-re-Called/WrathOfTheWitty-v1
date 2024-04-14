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
@export_category("Deck")
@export var action_card_deck: Array[CardInfo]
@export var template_card_deck: Array[TemplateCardInfo]

var current_health: int = -1
