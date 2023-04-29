extends Node2D

@onready var spawn_point = $SpawnPoint
var player


func _ready():
	player = get_tree().get_root().get_node("Game").player
	spawn_point.add_child(player)
	player.position = Vector2.ZERO
