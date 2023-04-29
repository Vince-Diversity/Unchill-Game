extends Node2D

@onready var spawn_point = $SpawnPoint
@onready var battle_log = %BattleLog
@onready var action_list = $UI/Actions/ActionList
@onready var enemies = $Enemies
var player
var current_action: String
var actions = {
	"Attack": attack,
	"Flee": flee,
}
var current_battler
var turn_order: Array[Character]
var turn := 0

signal action_finished


func _ready():
	player = get_tree().get_root().get_node("Game").player
	spawn_point.add_child(player)
	player.position = Vector2.ZERO
	_ready_ui()
	_ready_battle()
	_battle_loop()


func _ready_ui():
	for action_name in actions.keys():
		var button = Button.new()
		button.name = action_name
		button.text = action_name
		action_list.add_child(button)
		button.pressed.connect(_on_button_pressed.bind(action_name))


func _ready_battle():
	turn_order.append(player)
	for enemy_spawn_point in enemies.get_children():
		var enemy = enemy_spawn_point.get_child(0)
		turn_order.append(enemy)


func _battle_loop():
	current_battler = turn_order[turn % turn_order.size()]
	battle_log.text = "%s's turn." % current_battler.name
	if current_battler == player:
		for button in action_list.get_children():
			button.disabled = false
		await action_finished
	else:
		await get_tree().create_timer(1).timeout
		current_action = current_battler.ai.decide_action(self)
		await actions[current_action].call()
		action_finished.emit()
	turn += 1
	_battle_loop()


func attack():
	if current_battler.attack_list.is_empty():
		battle_log.text = "%s is doing nothing." % [current_battler.name]
	else:
		battle_log.text = "%s used %s!" % [current_battler.name, current_battler.attack_list[0].name]
	await get_tree().create_timer(1).timeout


func flee():
	Events.battle_ended.emit()


func _on_button_pressed(action_name):
	for button in action_list.get_children():
		button.disabled = true
	current_action = action_name
	await actions[current_action].call()
	action_finished.emit()
