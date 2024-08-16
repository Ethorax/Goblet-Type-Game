extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var health = 1

var burst = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if(health>=1):
		if(burst):
			velocity = (Global.player.global_position - global_position).normalized() *SPEED * 4.0
			burst = false
		else:
			velocity = velocity.move_toward(Vector3.ZERO,0.2)
	else:
		velocity = lerp(velocity,Vector3.ZERO, 0.1)
	move_and_slide()

func take_damage(damage : int):
	health -= damage
	velocity = (Global.player.global_position - global_position).normalized() * -SPEED * 10
	if(health <=0):
		$Alive.hide()
		$Dead.show()
	


func _on_timer_timeout():
	burst = true
