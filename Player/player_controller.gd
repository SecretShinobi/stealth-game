# Insert tool if desired
class_name Player
extends CharacterBody3D

# Signals

# Enums
enum Profile {NORMAL, SPRINT, CROUCH}

# Constants
const BASE_SPEED = 4.0
const MOUSE_SENS = 0.2
const LERP_SPEED = 15.0

# Exports

# Public Variables
var direction = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jump_velocity = 5
var air_lerp_speed = 2.5
var profile = Profile.NORMAL

# Private Variables

# @onready Public Variables
@onready var head = $"Head/Camera3D"
# @onready Private Variables


# Other statements
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:  # Handles mouse movement
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
		head.rotation.x = clamp(head.rotation.x, 
				deg_to_rad(-60.0), deg_to_rad(60.0))
	if Input.is_action_just_pressed("pause_exit"):
		get_tree().quit()


func _unhandled_input(event): # Figure out what to do with later
	if event is InputEventKey:
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# TODO: Implement camera controls
	pass


func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_front", 
			"move_back")

	if is_on_floor():
		var move_speed = BASE_SPEED + \
		(1 * int(Input.is_action_pressed("sprint"))) - \
		(1.5 * int(profile == Profile.CROUCH))
		
		direction = lerp(direction, (transform.basis * 
				Vector3(input_dir.x, 0, input_dir.y)).normalized(), 
				delta * LERP_SPEED)
		
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		print(str(move_speed))
	else:
		velocity.y -= gravity * delta
	
	if Input.is_action_pressed("lean_left"):
		print("lean left")
	if Input.is_action_pressed("lean_right"):
		print("lean right")

	if Input.is_action_just_pressed("crouch"):
		if profile != Profile.CROUCH:
			head.position = Vector3(head.position.x, head.position.y - 0.3, 
					head.position.z)
			profile = Profile.CROUCH
		else:
			head.position = Vector3(head.position.x, head.position.y + 0.3, 
					head.position.z)
			profile = Profile.NORMAL

	move_and_slide()


# Constructor
func _init():
	pass
