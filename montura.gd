extends CharacterBody2D
@onready var coyote_timer: Timer = $Coyotetimer



enum STATE {
	CAIDA,
	PISO,
	SALTO, 
	DOBLE_SALTO,
}

const Gravedad_Caida := 1500.0
const Velocidad_Caida := 500.0
const Velocidad_Caminar := 200
const Velocidad_Salto := -600.0
const Desacelerar_S := 1500.0

var active_state := STATE.CAIDA  

func _ready() -> void:
	switch_state(active_state)


func _physics_process(delta: float) -> void:
	process_state(delta)
	move_and_slide()

func switch_state(to_state: STATE) -> void:
	var Estado_Previo := active_state
	active_state = to_state
	
	## State especifico para las acciones que tienen que ser corridas una vez entrado el siguiente estado.
	match active_state:
		STATE.CAIDA:
			if Estado_Previo == STATE.PISO:
				coyote_timer.start()
		
		
		STATE.SALTO:
			velocity.y = Velocidad_Salto
			coyote_timer.stop()


func process_state(delta: float) -> void:
	match active_state:
		STATE.CAIDA:
			velocity.y = move_toward(velocity.y, Velocidad_Caida, Gravedad_Caida * delta) 
			manejar_movimiento()
			
			
			
			if is_on_floor():
				switch_state(STATE.PISO)
			elif Input.is_action_just_pressed("Montura_Salto") and coyote_timer.time_left > 0:
					switch_state(STATE.SALTO)
				
				
				
		STATE.PISO:
			if not is_on_floor():
				switch_state(STATE.CAIDA)
			
			elif Input.is_action_just_pressed("Montura_Salto"):
				switch_state(STATE.SALTO)
			manejar_movimiento()
		STATE.SALTO:
				velocity.y = move_toward(velocity.y, 0, Desacelerar_S * delta)
				manejar_movimiento()
				
				if Input.is_action_just_pressed("Montura_Salto") or velocity.y >= 0:
					velocity.y = 0
					switch_state(STATE.CAIDA)
				
func manejar_movimiento() -> void:
	var input_direction := signf(Input.get_axis("Montura_Der", "Montura_Izq"))
	velocity.x = input_direction * Velocidad_Caminar
