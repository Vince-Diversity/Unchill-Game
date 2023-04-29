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
			var inputted_direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
			var anim_name = anim_name_of(inputted_direction)
			if anim_name == "walk_right":
				anim_name = "walk_left"
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			velocity = speed * inputted_direction
			move_and_slide()
			if inputted_direction == Vector2.ZERO:
				$AnimatedSprite2D.play("default")
			else:
				$AnimatedSprite2D.play(anim_name)
		State.BATTLING:
			pass

func anim_name_of(direction):
	var anim_name
	var snapped_direction = snap_direction(direction)
	match snapped_direction:
		Vector2.DOWN: anim_name = "walk_down"
		Vector2.LEFT: anim_name = "walk_left"
		Vector2.UP: anim_name = "walk_up"
		Vector2.RIGHT: anim_name = "walk_right"
	return anim_name

func snap_direction(direction):
	if direction == Vector2.ZERO: return direction
	var snapped_angle = snapped(direction.angle(), PI / 2)
	var snapped_vector = Vector2.RIGHT.rotated(snapped_angle)
	if is_equal_approx(snapped_vector.x, 0): snapped_vector.x = 0
	if is_equal_approx(snapped_vector.y, 0): snapped_vector.y = 0
	return snapped_vector

func _on_battle_started():
	current_state = State.BATTLING


func _on_battle_ended():
	current_state = State.MOVING
