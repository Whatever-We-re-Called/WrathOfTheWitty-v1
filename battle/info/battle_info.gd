class_name BattleInfo extends Resource

@export_group("Enemy Pool")
@export var enemy_pool: Array[PlayerInfo]
@export_group("Blessing Reward")
@export var blessing_reward_ui_scene: PackedScene
@export var blessing_reward_options_count: int
@export var blessing_reward_choices_count: int
@export var blessing_reward_cosmic_chance: float
@export_group("Extra Reward")
@export var has_extra_reward: bool
@export var extra_reward_ui_scene: PackedScene
@export var extra_reward_options_count: int
@export var extra_reward_choices_count: int
