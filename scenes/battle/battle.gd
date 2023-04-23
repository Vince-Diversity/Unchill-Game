extends Node2D

@onready var ally1 = $Ally/Ally1


func _ready():
	var player = get_tree().get_root().get_node("Game").player
	ally1.add_child(player)
	player.global_position = ally1.global_position
