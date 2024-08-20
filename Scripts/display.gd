extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$SubViewportContainer/SubViewport/Camera3D.global_transform = $SubViewportContainer/SubViewport/Player/Camera3D.global_transform
	if(Input.is_action_just_pressed("close_menu")):
		$Textbox.hide()
		
	


func _on_talk_button_up():
	if $SubViewportContainer/SubViewport/Player/RayCast3D.is_colliding():
		if($SubViewportContainer/SubViewport/Player/RayCast3D.get_collider().is_in_group("NPC")):
			#print("Talking!")
			$Textbox/RichTextLabel.text = $SubViewportContainer/SubViewport/Player/RayCast3D.get_collider().text
			$Textbox.show()


func _on_timer_timeout():
	for heart in $HeartContainer.get_children():
		if(heart.frame == 1):
			heart.frame = 0
		else:
			heart.frame = 1

func update_hearts():
	var heart_index = 0
	for i in $HeartContainer.get_children():
		heart_index += 1
		if heart_index > Global.player_health:
			i.hide()
		else:
			i.show()
