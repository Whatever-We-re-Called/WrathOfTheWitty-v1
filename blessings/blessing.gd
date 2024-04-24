class_name Blessing extends Resource

enum Rarity { Common, Uncommon, Rare }
enum Event { ON_EQUIP, ON_UNEQUIP, }

signal equipped(stack: int)
signal unequipped(stack: int)
signal battle_started(stack: int)
signal battle_ended(stack: int)
signal turn_started(stack: int)
signal turn_ended(stack: int)

@export var name: String
@export var texture: Texture2D
@export_multiline var description: String
@export var rarity: Rarity
@export var execution_script: Script

var execution_script_instance = null


func init(player_info: PlayerInfo):
	execution_script_instance = execution_script.new()
	
	execution_script_instance.player_info = player_info
	
	execution_script_instance.blessing = self
	equipped.connect(execution_script_instance._on_equipped)
	unequipped.connect(execution_script_instance._on_unequipped)
	battle_started.connect(execution_script_instance._on_battle_started)
	battle_ended.connect(execution_script_instance._on_battle_ended)
	turn_started.connect(execution_script_instance._on_turn_started)
	turn_ended.connect(execution_script_instance._on_turn_ended)
