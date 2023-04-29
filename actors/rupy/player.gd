extends Character

enum State {MOVING, BATTLING}
var current_state: int = State.MOVING

@export var speed: float = 150


func _ready():
	Events.battle_started.connect(_on_battle_started)
	Events.battle_ended.connect(_on_battle_ended)


func _physics_process(_delta):
	match current_state:
		State.MOVING:
			var Inputted_direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
			velocity = speed * Inputted_direction
			move_and_slide()
		State.BATTLING:
			pass


func _on_battle_started():
	current_state = State.BATTLING


func _on_battle_ended():
	current_state = State.MOVING
