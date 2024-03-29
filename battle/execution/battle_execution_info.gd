class_name BattleExecutionInfo extends Resource

@export var insecurity_group_multiplier: float
@export var insecurity_matching_multiplier: float
@export var buff_enhancement_multiplier: float
@export var extra_buff_enhancement_multiplier: float
@export var weak_enhancement_multiplier: float
@export_group("Base Values")
@export var base_damage_values: Array[int]
@export var base_poison_values: Array[int]
@export var base_shield_value: float
@export var base_poison_value: float
@export var base_heal_value: float
@export var base_life_steal_value: float
@export var base_stamina_value: float
@export var base_fire_value: float
@export var base_weakness_value: float
@export_group("Level Increments")
@export var damage_level_increment: float
@export var shield_level_increment: float
@export var poison_level_increment: float
@export var heal_level_increment: float
@export var life_steal_level_increment: float
@export var stamina_level_increment: float
@export var fire_level_increment: float
@export var weakness_level_increment: float
@export_group("Strength Multipliers")
@export var damage_strength_multipliers: Array[float]
@export var shield_strength_multipliers: Array[float]
@export var poison_strength_multipliers: Array[float]
@export var heal_strength_multipliers: Array[float]
@export var life_steal_strength_multipliers: Array[float]
@export var stamina_strength_multipliers: Array[float]
@export var fire_strength_multipliers: Array[float]
@export var weakness_strength_multipliers: Array[float]
