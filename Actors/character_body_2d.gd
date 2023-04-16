extends CharacterBody2D
@export var speed: float = 150
func _physics_process(_delta):
	var Inputted_direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = speed * Inputted_direction
	move_and_slide()
