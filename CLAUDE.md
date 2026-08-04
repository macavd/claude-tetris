# CLAUDE.md

Este archivo proporciona orientación a Claude Code (claude.ai/code) al trabajar con el
código de este repositorio.

## Descripción general

Tetris en JavaScript vanilla (HTML5 Canvas + CSS). Sin dependencias, sin proceso de build,
sin `package.json`. Tres archivos fuente: `index.html`, `style.css`, `game.js`.

## Ejecución

Abre `index.html` directamente, o sírvelo de forma estática (recomendado, evita problemas
con `file://`):

```bash
python3 -m http.server 8000   # luego abre http://localhost:8000
```

No hay tests, ni linter, ni build. "Probar" un cambio significa cargar la página y jugar.

## Arquitectura

Toda la lógica del juego vive en `game.js` (~300 líneas, procedural, con estado mutable a
nivel de módulo en la declaración `let board, current, next, ...`). Conceptos clave:

- **El tablero** es una matriz `ROWS × COLS`; cada celda guarda `0` (vacía) o un índice de
  color `1–7`. El mismo índice se usa para buscar tanto en `COLORS[i]` como en `PIECES[i]`,
  así que esos dos arrays están alineados por índice por diseño — mantenlos sincronizados.
- **Las piezas** son matrices cuadradas. La rotación (`rotateCW`) es transposición +
  inversión de filas. `tryRotate` aplica wall kicks básicos (prueba desplazamientos en x
  `[0,-1,1,-2,2]`).
- **El game loop** (`loop`) está basado en `requestAnimationFrame`, acumulando `dt` en
  `dropAccum` y bajando una fila cuando supera `dropInterval`. `animId` guarda el handle de
  RAF; pausa/game over/reinicio lo cancelan.
- **Transiciones de estado**: `init` → `spawn` (mueve `next` a `current`, genera un nuevo
  `next`, dispara `endGame` si la nueva pieza ya colisiona) → `lockPiece`
  (`merge` + `clearLines` + `spawn`).
- **El renderizado** dibuja la grilla, el tablero fijado, la pieza fantasma (`ghostY`,
  alpha 0.2) y luego la pieza actual, en cada frame. La vista previa "next" se renderiza en
  un canvas aparte mediante `drawNext`.
- **Puntuación/nivel**: `LINE_SCORES` × nivel por líneas eliminadas; +2/celda en hard drop,
  +1/fila en soft drop. Nivel = `floor(lines/10)+1`; velocidad =
  `max(100, 1000-(level-1)*90)` ms.

## Detalle importante: las dimensiones del canvas están acopladas a las constantes

`COLS`, `ROWS`, `BLOCK` en `game.js` deben coincidir con el `width`/`height` del
`<canvas id="board">` en `index.html` (`width = COLS*BLOCK`, `height = ROWS*BLOCK`,
actualmente 300×600). Cambiar el tamaño del tablero implica editar ambos archivos.

## Notas

- Los textos de la interfaz y los comentarios del código están en español; respeta ese
  idioma al editar texto visible para el usuario.
- `README.md` tiene una explicación más completa de las mecánicas y las constantes
  ajustables.
