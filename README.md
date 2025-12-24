# Documentación del Juego Plataforma Simple en Godot

## Descripción General

**Plataforma Simple** es un juego 2D de plataformas desarrollado en Godot Engine. El objetivo del juego es controlar a un personaje jugable para recoger monedas mientras evitas enemigos y no caes en zonas mortales. Es un proyecto educativo que demuestra los conceptos básicos de un juego de plataformas.

---

## Estructura del Proyecto

El proyecto se organiza en las siguientes carpetas principales:

### `codigo/` - Scripts GDScript
Contiene todos los scripts que controlan la lógica del juego:
- `jugador.gd` - Control del personaje jugable
- `enemigo.gd` - Comportamiento de los enemigos
- `moneda.gd` - Mecánica de recolección de monedas
- `zona_de_muerte.gd` - Detección de caídas fatales
- `game_manager.gd` - Gestión de puntuación y UI

### `escenas/` - Escenas Godot
Contiene las escenas visuales del juego:
- `jugador.tscn` - Escena del personaje jugable
- `enemigo.tscn` - Escena del enemigo
- `Moneda.tscn` - Escena de las monedas
- `zona_de_muerte.tscn` - Área de muerte
- `plataforma.tscn` - Plataformas (elementos estáticos)
- `escena_01.tscn` - Escena principal del nivel
- `musica.tscn` - Gestor de música

### `recursos/` - Assets del Juego
- **fonts/** - Fuentes de pixel (`PixelOperator8`)
- **music/** - Música de fondo (`time_for_adventure.mp3`)
- **sounds/** - Efectos de sonido:
  - `coin.wav` - Al recoger monedas
  - `explosion.wav` - Efecto de explosión
  - `hurt.wav` - Al recibir daño
  - `jump.wav` - Al saltar
  - `power_up.wav` - Poder especial
  - `tap.wav` - Sonido de golpe
- **sprites/** - Gráficos del juego:
  - Personaje (`knight.png`)
  - Enemigos (`slime_green.png`, `slime_purple.png`)
  - Monedas (`coin.png`)
  - Direcciones visuales (`direction_*.png`)
  - Plataformas (`platforms.png`)
  - Mundo (`world_tileset.png`)
  - Frutas (`fruit.png`)

---

## Sistema de Juego

### Mecánicas Principales

#### 1. **Movimiento y Salto del Jugador**
El jugador está controlado por el script `jugador.gd` usando física 2D de Godot:

- **Movimiento Horizontal**: Presionar las teclas izquierda/derecha mueve el personaje a una velocidad constante de **130 píxeles/segundo**
- **Salto**: Presionar la tecla de salto aplica una velocidad vertical de **-300 píxeles/segundo** (hacia arriba)
- **Gravedad**: Se aplica automáticamente cuando el jugador está en el aire, haciendo que caiga
- **Animaciones**:
  - `reposo`: El jugador está quieto
  - `correr`: El jugador se mueve horizontalmente
  - `saltar2`: El jugador está en el aire
- **Volteo de Sprite**: El personaje se voltea automáticamente según la dirección del movimiento
- **Sonido**: Se reproduce un efecto de sonido al saltar

---

#### 2. **Sistema de Monedas**
Las monedas son elementos coleccionables controlados por `moneda.gd`:

- **Detección**: Cuando el jugador toca una moneda (colisión Area2D), se activa el sistema de recolección
- **Efectos al Recoger**:
  - Se suma 1 punto a la puntuación
  - Se reproduce el sonido `coin.wav`
  - El sprite se oculta
  - La colisión se desactiva
  - La moneda se elimina después de que termina el sonido
- **Puntuación**: Se muestra en pantalla como "Has conseguido X monedas"

---

#### 3. **Enemigos**
Los enemigos están controlados por `enemigo.gd` y tienen un comportamiento de patrulla:

- **Movimiento**: Se desplazan horizontalmente a una velocidad de **60 píxeles/segundo**
- **Patrulla**: Cambian de dirección automáticamente cuando detectan obstáculos usando dos **RayCast2D**:
  - `RayCastDerecha`: Detecta colisiones a la derecha
  - `RayCastIzquierda`: Detecta colisiones a la izquierda
- **Volteo Visual**: El sprite se invierte cuando cambia de dirección
- **Tipos**: El proyecto incluye dos tipos de sprites de enemigos (slime verde y púrpura)
- **Colisión Mortal**: Cuando el jugador toca un enemigo, ocurre lo siguiente:
  - Se reproduce el sonido de muerte
  - El tiempo se ralentiza a 50%
  - Se inicia el proceso de reinicio

---

#### 4. **Zonas Mortales**
Controladas por `zona_de_muerte.gd`, son áreas que causan la derrota del jugador:

- **Activación**: Se activa cuando el jugador cae en el área
- **Efectos al Morir**:
  - Reproducción del sonido de muerte
  - Ralentización del tiempo (0.5x) para efecto cinematográfico
  - Eliminación del collider del jugador
  - Mensaje en consola: "¡Haz perdido!"
- **Reinicio**: Después de que termina el sonido (controlado por un Timer), se recarga la escena actual

---

#### 5. **Gestor del Juego (Game Manager)**
El script `game_manager.gd` controla la interfaz y puntuación:

- **Puntuación**: Mantiene un registro de puntos (inicialmente en 0)
- **UI**: Actualiza una etiqueta en pantalla que muestra la puntuación actual
- **Acceso Global**: Utiliza la anotación `@onready var game_manager: Node = %GameManager` para acceso único desde otras escenas

---

## Flujo de Juego

```
┌─────────────────────────────────────────────────────────────┐
│                    INICIO DEL JUEGO                         │
│              (Escena Principal: escena_01)                  │
└─────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                  JUGADOR EN EL MAPA                         │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ • Controlar movimiento izquierda/derecha            │    │
│  │ • Saltar para evitar obstáculos                     │    │
│  │ • Recoger monedas                                   │    │
│  │ • Evitar enemigos                                   │    │
│  │ • Evitar caer en zonas mortales                     │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
          │                              │
          │ Toca moneda                  │ Cae o toca enemigo
          ▼                              ▼
    ┌─────────────────┐        ┌──────────────────────┐
    │ +1 Puntuación   │        │   RALENTIZAR TIEMPO  │
    │ Sonido moneda   │        │   (efecto muerte)    │
    │ Moneda eliminada│        └──────────────────────┘
    └─────────────────┘                 │
          │                             ▼
          │                     ┌──────────────────────┐
          │                     │  RECARGAR ESCENA     │
          │                     │  (reiniciar juego)   │
          │                     └──────────────────────┘
          │
          └──────────┐
                     │
                     ▼
            ┌──────────────────┐
            │  CONTINUAR JUEGO │
            │  (sin reiniciar) │
            └──────────────────┘
```

---

## Controles del Juego

| Acción | Entrada |
|--------|---------|
| Mover Izquierda | Tecla Izquierda / A |
| Mover Derecha | Tecla Derecha / D |
| Saltar | Espacio / W |

*Nota: Los controles específicos se definen en el archivo `project.godot`*

---

## Física del Juego

### Velocidades Clave

| Elemento | Velocidad |
|----------|-----------|
| Jugador (movimiento) | 130 px/s |
| Jugador (salto) | -300 px/s (hacia arriba) |
| Enemigo (patrulla) | 60 px/s |
| Ralentización (muerte) | 0.5x tiempo normal |

### Sistemas Físicos

- **CharacterBody2D (Jugador)**: Utiliza el sistema de física integrado de Godot para manejar colisiones y gravedad automáticamente
- **Node2D (Enemigo)**: Posicionamiento simple sin física; detecta colisiones mediante raycast
- **Area2D (Monedas, Zona de Muerte)**: Detectan colisiones pero no tienen física; usadas para detección de eventos

---

## Archivos Importantes

### Escenas y Scripts

| Archivo | Tipo | Propósito |
|---------|------|----------|
| [jugador.gd](codigo/jugador.gd) | Script | Movimiento y controles del jugador |
| [enemigo.gd](codigo/enemigo.gd) | Script | Comportamiento de patrulla |
| [moneda.gd](codigo/moneda.gd) | Script | Recolección y puntuación |
| [zona_de_muerte.gd](codigo/zona_de_muerte.gd) | Script | Detección de derrota |
| [game_manager.gd](codigo/game_manager.gd) | Script | Gestión de puntuación y UI |
| [escena_01.tscn](escenas/escena_01.tscn) | Escena | Nivel principal del juego |

---

## Cómo Expandir el Juego

### Posibles Mejoras

1. **Múltiples Niveles**: Crear nuevas escenas con diferentes disposiciones de plataformas y enemigos
2. **Power-ups**: Implementar objetos que otorguen habilidades especiales (invulnerabilidad, velocidad, etc.)
3. **Enemigos Más Complejos**: Añadir enemigos con comportamientos más avanzados (persecución, saltos, etc.)
4. **Mecánicas Adicionales**: Incluir paredes pegajosas, plataformas móviles, o activadores
5. **Pantalla de Game Over**: Crear una pantalla de derrota interactiva
6. **Sistema de Vidas**: Permitir múltiples intentos antes de reiniciar completamente
7. **Jefe Final**: Crear un enemigo especial con comportamiento único

---

## Estructura del Código

### Patrones Utilizados

- **Herencia de Nodos**: Cada entidad extiende un nodo base apropiado (CharacterBody2D, Area2D, Node2D)
- **Señales y Callbacks**: Se usan funciones de retorno para eventos de colisión (`_on_body_entered`)
- **OnReady Annotations**: Los referencias a nodos se cachean al iniciar para optimizar acceso
- **Gestión de Tiempo**: Uso de `delta` para movimiento independiente de frames y `Engine.time_scale` para efectos especiales

---

## Requisitos del Proyecto

- **Engine**: Godot 4.0 o superior
- **Plataforma**: Multiplataforma (Windows, Mac, Linux, Web, Mobile)
- **Dependencias**: Solo la biblioteca estándar de Godot

---

## Conclusión

Este es un proyecto educativo ideal para aprender los fundamentos del desarrollo de juegos 2D en Godot:

- Controles básicos y física de plataformas
- Detección de colisiones y eventos
- Sistema de puntuación
- Efectos de sonido y animaciones
- Gestión del flujo del juego  

El juego está listo para ser expandido y mejorado
---

## Créditos y Fuentes Educativas

Este proyecto fue realizado con fines educativos utilizando tutoriales en línea y recursos de creadores de contenido profesionales:

### Tutoriales Utilizados

- **Academia de Videojuegos** - Tutoriales de desarrollo de juegos en Godot
  - [Playlist: Desarrollo de Juegos con Godot](https://www.youtube.com/playlist?list=PLREdURb87ks2TtpMUiYbgzxr6WC_RsCfs)

- **Brackeys** - Tutoriales fundamentales de plataformas 2D
  - [Tutorial: 2D Platformer](https://youtu.be/LOhfqjmasi0?si=8hmcE3C_xnt13geC)

### Assets Utilizados

- **Brackeys Games** - Paquete completo de assets para plataformas
  - [Brackeys Platformer Bundle](https://brackeysgames.itch.io/brackeys-platformer-bundle)
  - Incluye: sprites, sonidos, efectos visuales y más

- **Kenney.nl** - Recursos de controles móviles y assets diversos
  - [Mobile Controls](https://kenney.nl/assets/mobile-controls)
  - Librería de assets de código abierto y reutilizable

### Agradecimientos

Agradecemos a todos los creadores de contenido educativo que hacen posible que nuevos desarrolladores aprendan las bases del desarrollo de videojuegos de forma accesible y gratuita.