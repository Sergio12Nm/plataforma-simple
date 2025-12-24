# Script del jugador
# Controla el movimiento, saltos y animaciones del personaje jugable
extends CharacterBody2D


# Velocidad constante de movimiento horizontal (píxeles por segundo)
const SPEED = 130.0
# Velocidad de salto (negativa porque es hacia arriba en el eje Y)
const JUMP_VELOCITY = -300.0

# Referencias a los componentes del jugador
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sonido_salto: AudioStreamPlayer2D = $SonidoSalto

# Función que se ejecuta cada frame para manejar la física del jugador
func _physics_process(delta: float) -> void:
	# Aplicar gravedad al jugador cuando no está en el suelo
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Detectar entrada de salto y ejecutarlo si el jugador está en el suelo
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sonido_salto.play()

	# Obtener la entrada del jugador para el movimiento horizontal (izquierda/derecha)
	var direction := Input.get_axis("mover_izquierda", "mover_derecha")
	
	# Voltear el sprite según la dirección del movimiento
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Seleccionar la animación correcta según el estado del jugador
	if is_on_floor():
		if direction == 0:
			# Mostrar animación de reposo si el jugador no se mueve
			animated_sprite.play("reposo")
		else:
			# Mostrar animación de correr si el jugador se mueve
			animated_sprite.play("correr")
	else:
		# Mostrar animación de salto si el jugador está en el aire
		animated_sprite.play("saltar2")
	
	# Actualizar la velocidad horizontal del jugador
	if direction:
		velocity.x = direction * SPEED
	else:
		# Desacelerar cuando no hay entrada de movimiento
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Aplicar el movimiento al jugador
	move_and_slide()
