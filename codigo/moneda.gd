# Script de la moneda
# Detecta cuando el jugador recoge la moneda y actualiza la puntuación
extends Area2D

# Referencias a los componentes de la moneda
@onready var game_manager: Node = %GameManager
@onready var sonido_moneda: AudioStreamPlayer2D = $SonidoMoneda
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Función que se ejecuta cuando un cuerpo entra en el área de la moneda (cuando el jugador la toca)
func _on_body_entered(body: Node2D) -> void:
	# Incrementar la puntuación del jugador
	game_manager.incrementa_un_punto()
	# Reproducir el sonido de recogida de moneda
	sonido_moneda.play()
	# Ocultar el sprite de la moneda
	animated_sprite.visible = false
	# Desactivar la colisión de la moneda (deferred para evitar conflictos con la física)
	collision_shape.call_deferred("set", "disabled", true)

# Función que se ejecuta cuando el sonido de la moneda termina de reproducirse
func _on_sonido_moneda_finished() -> void:
	# Eliminar la moneda de la escena
	queue_free()
