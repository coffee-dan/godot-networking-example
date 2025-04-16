class_name Player
extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -240.0

func _enter_tree():
	set_multiplayer_authority(int(str(name)))
	
func _ready():
	if name == "1":
		$Sprite2D.modulate = Color.RED

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	
	$GunContainer.look_at(get_global_mouse_position())
	
	if get_global_mouse_position().x < global_position.x:
		$GunContainer/GunSprite.flip_v = true
	else:
		$GunContainer/GunSprite.flip_v = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
