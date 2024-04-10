class_name PlayerConfig extends Resource

@export_category("Visuals")
@export var name: String
@export var sprite_frames: SpriteFrames
@export var sprite_scale: Vector2 = Vector2.ONE
@export_category("Values")
@export var base_level: int
@export var insecurity: Constants.Insecurity
@export var max_health: int
@export var max_stamina: int
@export var max_hand_size: int
@export_category("Deck")
@export var action_card_deck: Array[CardInfo]
@export var template_card_deck: Array[TemplateCardInfo]
