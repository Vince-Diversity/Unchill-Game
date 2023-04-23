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
	overworld.add_child(player)
	Events.encounter_started.connect(_on_encounter_started)

func _on_encounter_started():
	overworld.remove_child(player)
	overworld.queue_free()
	battle = battle_scene.instantiate()
	add_child.call_deferred(battle)
