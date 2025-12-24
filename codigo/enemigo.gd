# Script de comportamiento del enemigo
# El enemigo patrulla de izquierda a derecha, cambiando dirección cuando colisiona con obstáculos
extends Node2D

# Velocidad constante de movimiento del enemigo (píxeles por segundo)
const VELOCIDAD = 60

# Variable que controla la dirección del movimiento (1 = derecha, -1 = izquierda)
var direccion = 1

# Referencias a los componentes del enemigo
@onready var ray_cast_derecha: RayCast2D = $RayCastDerecha
@onready var ray_cast_izquierda: RayCast2D = $RayCastIzquierda
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Función que se ejecuta cuando el nodo entra en la escena
func _ready() -> void:
	pass # Replace with function body.


# Función que se ejecuta cada frame para actualizar la posición y comportamiento del enemigo
func _process(delta: float) -> void:
	# Si hay colisión a la derecha, cambiar dirección hacia la izquierda e invertir sprite
	if ray_cast_derecha.is_colliding():
		direccion = -1
		animated_sprite.flip_h = true
	# Si hay colisión a la izquierda, cambiar dirección hacia la derecha y mostrar sprite normal
	if ray_cast_izquierda.is_colliding():
		direccion = 1
		animated_sprite.flip_h = false
	# Actualizar la posición horizontal del enemigo según su dirección y velocidad
	position.x += direccion * VELOCIDAD * delta
