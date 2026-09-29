extends CharacterBody2D
@onready var mano: Sprite2D = $Mano

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:

	var input_direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = input_direction * SPEED

	move_and_slide()
	if Input.is_action_pressed("Subir_Arma"):
		mano.rotation_degrees -=1
	if Input.is_action_pressed("Bajar_arma"):
		mano.rotation_degrees +=1
	mano.rotation_degrees +=0.2
	mano.rotation_degrees = clamp(mano.rotation_degrees, 65, 107)
	
