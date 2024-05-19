class_name BattleScene extends Node2D

enum State {
	PLAYING,
	EXECUTING,
	ENDING
}

@export var info: BattleInfo

@onready var battle_interface = $CanvasLayer/BattleInterface
@onready var left_player_node = %LeftPlayerNode
@onready var right_player_node = %RightPlayerNode
@onready var canvas_layer = %CanvasLayer

var enemy_info: PlayerInfo
var state: State
var active_side: Constants.PlayerSide
var players = {}
var player: BattlePlayer: 
	get:
		return players[active_side]
	set(value):
		players[active_side] = value

var active_template_card: TemplateCard

const EXECUTE_TURN_SIMULATED_DELAY = 1.5
const ACTION_CARD_SCENE = preload("res://battle/cards/card.tscn")
const TEMPLATE_CARD_SCENE = preload("res://battle/template_cards/template_card.tscn")


func _ready():
	state = State.PLAYING
	active_side = Constants.PlayerSide.LEFT
	
	_init_player(Constants.PlayerSide.LEFT, RunManager.player_info, left_player_node)
	_decide_enemy()
	_init_player(Constants.PlayerSide.RIGHT, enemy_info.duplicate(), right_player_node)
	players[Constants.PlayerSide.LEFT].opponent_battle_player = players[Constants.PlayerSide.RIGHT]
	players[Constants.PlayerSide.RIGHT].opponent_battle_player = players[Constants.PlayerSide.LEFT]
	
	players[Constants.PlayerSide.LEFT].handle_start_battle()
	players[Constants.PlayerSide.LEFT].handle_start_turn()
	players[Constants.PlayerSide.RIGHT].handle_start_battle()
	battle_interface.update_hand(player)
	battle_interface.update_player_deck_and_bag_ui(player)
	battle_interface.update_player_stats(player)
	battle_interface.update_player_stats(get_non_active_side_player())
	reset_active_template_card()
	
	battle_interface.card_toggle_selected.connect(_on_card_toggle_selected)
	battle_interface.card_reroll.connect(reroll_card)


func _decide_enemy():
	var rng = RandomNumberGenerator.new()
	var chosen_enemy_index = rng.randi_range(0, info.enemy_pool.size() - 1)
	enemy_info = info.enemy_pool[chosen_enemy_index]


func _init_player(side: Constants.PlayerSide, player_info: PlayerInfo, parent_node: Node2D):
	player_info.setup_local_to_scene()
	
	var player = BattlePlayer.new()
	player.init(player_info, side)
	player.decreased_opponents_max_health.connect(_on_decreased_opponents_max_health)
	player.damaged_opponent.connect(_on_damaged_opponent)
	player.stamina_changed.connect(_on_stamina_changed)
	player.updated_hand.connect(_on_updated_hand)
	player.drew_card.connect(_on_drew_card)
	player.removed_card.connect(_on_removed_card)
	player.died.connect(end_battle)
	parent_node.add_child(player)
	var sprite_height = player.sprite_frames.get_frame_texture("default", 0).get_height()
	player.global_position.y -= (sprite_height * player_info.sprite_scale.y) / 2.0
	battle_interface.update_player_stats(player)
	
	players[side] = player


func _process(delta):
	_handle_controls_input()
	
	# Debug
	if Input.is_action_just_pressed("debug_1"):
		player.stamina = player.info.stamina_stat
		battle_interface.update_player_stats(player)
	if Input.is_action_just_pressed("debug_2"):
		players[Constants.PlayerSide.LEFT].damage(5)
		battle_interface.update_player_stats(players[Constants.PlayerSide.LEFT])


func _handle_controls_input():
	if state != State.PLAYING: return
	
	if Input.is_action_just_pressed("view_your_info"):
		battle_interface.open_player_info_ui(players[Constants.PlayerSide.LEFT].info)
	elif Input.is_action_just_pressed("view_opponents_info"):
		battle_interface.open_player_info_ui(players[Constants.PlayerSide.RIGHT].info)
	
	if Input.is_action_just_pressed("end_turn") and state == State.PLAYING:
		end_turn_early()
	if Input.is_action_just_pressed("debug_5"):
		MapManager.swap_to_map_scene()


func _on_card_toggle_selected(card: Card):
	var card_info = card.card_info
	if player.selected_cards.has(card_info):
		unselect_card(card)
	else:
		select_card(card)


func _on_decreased_opponents_max_health(percentage: float, executing_player: BattlePlayer):
	if players[Constants.PlayerSide.LEFT] == executing_player:
		var new_health_amount = players[Constants.PlayerSide.RIGHT].info.health_stat * (1 - percentage)
		players[Constants.PlayerSide.RIGHT].info.health_stat = new_health_amount
		players[Constants.PlayerSide.RIGHT].health = new_health_amount
		battle_interface.update_player_stats(players[Constants.PlayerSide.RIGHT])
	else:
		var new_health_amount = players[Constants.PlayerSide.LEFT].info.health_stat * (1 - percentage)
		players[Constants.PlayerSide.LEFT].info.health_stat = new_health_amount
		players[Constants.PlayerSide.LEFT].health = new_health_amount
		battle_interface.update_player_stats(players[Constants.PlayerSide.LEFT])


func reset_active_template_card():
	player.selected_template_card_hand_index = 0
	update_active_template_card()


func update_active_template_card():
	if active_template_card != null:
		active_template_card.queue_free()
	
	var template_card_info = player.template_cards_in_hand[player.selected_template_card_hand_index]
	active_template_card = TEMPLATE_CARD_SCENE.instantiate()
	active_template_card.template_card_info = template_card_info
	active_template_card.played_selected_cards.connect(play_cards)
	active_template_card.selected_previous_template_card.connect(_on_selected_previous_template_card)
	active_template_card.selected_next_template_card.connect(_on_selected_next_template_card)
	active_template_card.rerolled_template_card.connect(reroll_template_card)
	
	battle_interface.update_template_card_ui(active_template_card)
	active_template_card.set_talking_side(active_side)
	active_template_card.update_selected_buttons(player.selected_template_card_hand_index, player.template_cards_in_hand.size())
	_update_template_card_reroll_button()


func select_card(card: Card):
	if active_template_card.is_full(): return
	
	var card_info = card.card_info
	player.selected_cards.push_back(card_info)
	
	active_template_card.add_selected_card(card)
	battle_interface.reflatten_hand_container()


func unselect_card(card: Card):
	var card_info = card.card_info
	for i in range(player.selected_cards.size()):
		if player.selected_cards[i] == card_info:
			player.selected_cards.remove_at(i)
			break
	
	active_template_card.remove_selected_card(card)
	
	battle_interface.add_card(card)


func play_cards():
	player.handle_played_selected_cards()
	if player.active_status_effects.has(Constants.PlayerStatusEffect.DELAY):
		BattleActionExecution.execute_action_cards(player.selected_cards, self)
		BattleAbilityExecution.try_to_execute(active_template_card.template_card_info, player.selected_cards, self)
		player.decrement_status_effect(Constants.PlayerStatusEffect.DELAY, 1)
		battle_interface.update_player_stats(player)
	else:
		BattleAbilityExecution.try_to_execute(active_template_card.template_card_info, player.selected_cards, self)
		BattleActionExecution.execute_action_cards(player.selected_cards, self)
	player.selected_cards.clear()
	
	for i in range(player.template_cards_in_hand.size()):
		if player.template_cards_in_hand[i] == active_template_card.template_card_info:
			player.template_cards_in_hand.remove_at(i)
			break
	player.send_template_card_to_bag(active_template_card.template_card_info)
	
	if player.template_cards_in_hand.size() > 0:
		state = State.EXECUTING
		Delay.delay_function(EXECUTE_TURN_SIMULATED_DELAY, self, func():
			state = State.PLAYING
			player.update_template_card_hand_logic() 
			update_active_template_card()
		)
	else:
		change_turns()


func end_turn_early():
	for card in active_template_card.selected_cards:
		card.free()
	change_turns()


func reroll_card(card: Card):
	player.reroll_card(card)
	battle_interface.update_player_stats(player)
	battle_interface.update_player_deck_and_bag_ui(player)


func reroll_template_card():
	_reset_selected_cards()
	player.reroll_template_card(active_template_card)
	battle_interface.update_player_stats(player)
	battle_interface.update_player_deck_and_bag_ui(player)


func _reset_selected_cards():
	var selected_cards_copy = player.selected_cards.duplicate()
	for selected_card in selected_cards_copy:
		unselect_card(selected_card.card_scene)


func _on_drew_card(card_info: CardInfo):
	battle_interface.add_card_to_hand(card_info, player)
	battle_interface.update_player_stats(player)


func _on_removed_card(card_info: CardInfo):
	battle_interface.remove_card_from_hand(card_info)


func change_turns():
	state = State.EXECUTING
	
	player.handle_end_turn()
	active_template_card.remove_context_ui(true)
	battle_interface.update_player_stats(player)
	battle_interface.update_player_stats(get_non_active_side_player())
	battle_interface.toggle_hand_visibility(false)
	
	Delay.delay_function(EXECUTE_TURN_SIMULATED_DELAY, self, func():
		player.handle_delayed_end_turn()
		
		if active_side == Constants.PlayerSide.LEFT:
			active_side = Constants.PlayerSide.RIGHT
		else:
			active_side = Constants.PlayerSide.LEFT
		
		player.handle_start_turn()
		battle_interface.update_hand(player)
		reset_active_template_card()
		player.handle_delayed_start_turn()
		battle_interface.update_player_deck_and_bag_ui(player)
		battle_interface.update_player_stats(player)
		battle_interface.update_player_stats(get_non_active_side_player())
		battle_interface.toggle_hand_visibility(true)
		
		state = State.PLAYING
	)


func end_battle():
	if state == State.ENDING: return
	
	state = State.ENDING
	players[Constants.PlayerSide.LEFT].handle_end_battle()
	players[Constants.PlayerSide.RIGHT].handle_end_battle()
	await get_tree().process_frame
	
	Delay.cancel_all_delays(self)
	
	var blessing_rewards_ui = info.blessing_reward_ui_scene.instantiate()
	canvas_layer.add_child(blessing_rewards_ui)
	blessing_rewards_ui.init(RunManager.player_info, info.blessing_reward_options_count, info.blessing_reward_choices_count, info.blessing_reward_cosmic_chance)
	await blessing_rewards_ui.finished
	blessing_rewards_ui.queue_free()
	
	if info.has_extra_reward:
		var extra_reward_ui = info.extra_reward_ui_scene.instantiate()
		canvas_layer.add_child(extra_reward_ui)
		extra_reward_ui.init(RunManager.player_info, info.extra_reward_options_count, info.extra_reward_choices_count)
		await extra_reward_ui.finished
		extra_reward_ui.queue_free()
	
	RunManager.update_player_info(players[Constants.PlayerSide.LEFT])
	MapManager.swap_to_map_scene()


func get_non_active_side_player():
	if active_side == Constants.PlayerSide.LEFT:
		return players[Constants.PlayerSide.RIGHT]
	elif active_side == Constants.PlayerSide.RIGHT:
		return players[Constants.PlayerSide.LEFT]


func _on_updated_hand():
	battle_interface.update_hand(player)


func _on_damaged_opponent(amount: int, executing_player: BattlePlayer):
	if players[Constants.PlayerSide.LEFT] == executing_player:
		players[Constants.PlayerSide.RIGHT].damage(amount)
		battle_interface.update_player_stats(players[Constants.PlayerSide.RIGHT])
	else:
		players[Constants.PlayerSide.LEFT].damage(amount)
		battle_interface.update_player_stats(players[Constants.PlayerSide.LEFT])


func _on_selected_previous_template_card():
	if state != State.PLAYING: return
	
	_reset_selected_cards()
	player.selected_template_card_hand_index -= 1
	update_active_template_card()


func _on_selected_next_template_card():
	if state != State.PLAYING: return
	
	_reset_selected_cards()
	player.selected_template_card_hand_index += 1
	update_active_template_card()


func _on_stamina_changed():
	if active_template_card != null and state == State.PLAYING:
		_update_template_card_reroll_button()


func _update_template_card_reroll_button():
	active_template_card.toggle_reroll_button(player.can_afford_template_card_reroll())
