extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var health = 1

@onready var attack_timer = $AttackTimer


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y -= gravity * delta 
	
	if(health>=1):
		velocity = (Global.player.global_position - global_position).normalized() *SPEED
	else:
		velocity = lerp(velocity,Vector3.ZERO, 0.1)
		
	move_and_slide()

func take_damage(damage : int):
	health -= damage
	velocity = (Global.player.global_position - global_position).normalized() * -SPEED * 10
	if(health <=0):
		attack_timer.autostart = false
		$Alive.hide()
		$Dead.show()
	


func _on_area_3d_body_entered(body):
	if(body.is_in_group("Player") and health >=0):
		attack_timer.start(1.0)


func _on_attack_timer_timeout():
	Global.player.take_damage(1)


func _on_area_3d_body_exited(body):
	if(body.is_in_group("Player")):
		attack_timer.stop()
		
