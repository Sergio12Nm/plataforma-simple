# Script del gestor del juego
# Controla la puntuación y actualiza la interfaz de usuario
extends Node

# Variable que almacena la puntuación actual del jugador
var puntuacion = 0

# Referencia a la etiqueta que muestra la puntuación en pantalla
@onready var etiqueta_puntuacion: Label = $EtiquetaPuntuacion

# Función que incrementa la puntuación en 1 punto cuando se recoge una moneda
func incrementa_un_punto():
	# Aumentar el contador de puntuación
	puntuacion += 1
	# Mostrar la puntuación en la consola para depuración
	print(puntuacion)
	# Actualizar el texto de la etiqueta con la puntuación actual
	etiqueta_puntuacion.text = "Haz conseguido\n"+str(puntuacion)  +" monedas."
