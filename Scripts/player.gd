extends CharacterBody3D


var double_speed = 1000*0.25
var last_tap = 0.0

var inertia = 1.0
const SPEED = 15.0
const JUMP_VELOCITY = 4.5
const TURN_SPEED = 150.0
const MAX_SPEED = 20.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var anim = $AnimationPlayer
@onready var timer = $Timer

func _ready():
	Global.player = self
	floor_snap_length = 10.0
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var turn_direction = Input.get_axis("turn_left","turn_right")
	rotation_degrees.y=rotation_degrees.y+(-TURN_SPEED)*turn_direction*delta
	
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if(direction):
		if(timer.is_stopped()):
			anim.play("walk")
	
	if (Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_backward") or Input.is_action_just_pressed("strafe_left") or Input.is_action_just_pressed("strafe_right")):
		if double_tap_detect():
			velocity.x = direction.x * MAX_SPEED * 2
			velocity.z = direction.z * MAX_SPEED * 2
	
	if(Input.is_action_just_pressed("swing")):
		timer.start()
		anim.play("swing")
	
	if(velocity != Vector3.ZERO):
		if(timer.is_stopped()):
			anim.play("walk")
	
	if direction:
		velocity.x = move_toward(velocity.x,MAX_SPEED*direction.x,inertia)
		velocity.z = move_toward(velocity.z,MAX_SPEED*direction.z,inertia)
		
	else:
		velocity.x = move_toward(velocity.x, 0, inertia)
		velocity.z = move_toward(velocity.z, 0, inertia)
		if(timer.is_stopped() and !turn_direction):
			anim.play("RESET")
	

	move_and_slide()

#Camera controls
	if($CameraDistance.is_colliding()):
		get_parent().get_child(0).global_position = $CameraDistance.get_collision_point()
		get_parent().get_child(0).rotation = rotation
	else:
		get_parent().get_child(0).global_transform = $Camera3D.global_transform


func double_tap_detect():
	var new_tap: = Time.get_ticks_msec()
	if new_tap - last_tap <= double_speed:
		return true
	last_tap = new_tap
	return false


func _on_area_3d_body_entered(body):
	if(body.has_method("take_damage")):
		body.take_damage(1)
		
		
		
func take_damage(damage):
	Global.player_health -= damage
	get_parent().get_parent().get_parent().update_hearts()
