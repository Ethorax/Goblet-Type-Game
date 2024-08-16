extends CharacterBody3D



@export var text : String
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var animation_player = $AnimationPlayer


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	animation_player.play("Idle")
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()
