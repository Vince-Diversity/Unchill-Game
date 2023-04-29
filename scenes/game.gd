extends Node2D

@onready var player_scene: PackedScene = preload("res://actors/rupy/rupy.tscn")
@onready var overworld_scene: PackedScene = preload("res://scenes/overworld/overworld.tscn")
@onready var battle_scene: PackedScene = preload("res://scenes/battle/battle.tscn")
var player
var overworld
var battle

func _ready():
	player = player_scene.instantiate()
	overworld = overworld_scene.instantiate()
	add_child(overworld)
	player.global_position = overworld.spawn_point.global_position
	Events.battle_started.connect(_on_battle_started)
	Events.battle_ended.connect(_on_battle_ended)


func _on_battle_started():
	overworld.spawn_point.remove_child(player)
	overworld.queue_free()
	battle = battle_scene.instantiate()
	add_child.call_deferred(battle)


func _on_battle_ended():
	battle.spawn_point.remove_child(player)
	battle.queue_free()
	overworld = overworld_scene.instantiate()
	add_child.call_deferred(overworld)
