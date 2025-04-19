class_name Player
extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -240.0
const MAX_HEALTH = 100

const BULLET = preload("res://bullet/bullet.tscn")

var health = MAX_HEALTH

@onready var game: Game = get_parent()

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
	
	if Input.is_action_just_pressed("shoot"):
		shoot.rpc(multiplayer.get_unique_id())
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# syncing bullet location across the network could get very expensive in a situation
# with many bullets, for that reason we only sync the creation of a new bullet and
# the hit detection is authoritatively handled by the shooter.
@rpc("call_local")
func shoot(shooter_pid: int):
	var bullet = BULLET.instantiate()
	bullet.set_multiplayer_authority(shooter_pid)
	get_parent().add_child(bullet)
	bullet.transform = $GunContainer/GunSprite/Muzzle.global_transform

@rpc("any_peer")
func take_damage(amount: int) -> void:
	health -= amount
	
	if health <= 0:
		health = MAX_HEALTH
		global_position = game.get_random_spawnpoint()
