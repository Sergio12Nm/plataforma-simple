# Script de la zona de muerte
# Detecta cuando el jugador cae en un área mortal y reinicia el juego
extends Area2D

# Referencias a los componentes de la zona de muerte
@onready var timer: Timer = $Timer
@onready var sonido_muerte: AudioStreamPlayer2D = $SonidoMuerte

# Función que se ejecuta cuando un cuerpo entra en el área de muerte (cuando el jugador cae)
func _on_body_entered(body: Node2D) -> void:
	# Reproducir el sonido de muerte
	sonido_muerte.play()
	# Mostrar mensaje en la consola
	print("Haz perdido!")
	# Ralentizar el tiempo a 50% para efecto de cámara lenta
	Engine.time_scale = 0.5
	# Eliminar la colisión del jugador
	body.get_node("CollisionShape2D").queue_free()
	# Iniciar el temporizador para esperar a que termine el sonido
	timer.start()

# Función que se ejecuta cuando el temporizador termina (después de que termina el sonido de muerte)
func _on_timer_timeout() -> void:
	# Restaurar la velocidad normal del tiempo
	Engine.time_scale = 1
	# Recargar la escena actual para reiniciar el juego
	get_tree().reload_current_scene()
