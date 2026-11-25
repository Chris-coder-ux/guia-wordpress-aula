# DESIGN.md

## Superficie

`practica-web-interactiva.html` — guía de práctica para el aula: instalar XAMPP y WordPress en local. Modo **Read**: el visitante lee y sigue pasos. Un solo archivo HTML, sin peticiones externas (funciona sin internet en el aula), imprimible en A4.

## Mundo visual

Referente: manuales de taller / etiquetado industrial. Nada de ilustración "infantil" ni capturas de pantalla falsas de programas que no están instalados aquí. Los diagramas son esquemas SVG dibujados a mano (dentro del propio HTML), etiquetados como esquemas, con un código de color coherente con la práctica: verde = funciona (como Apache y MySQL en el panel de XAMPP), ámbar = cuidado, rojo = error.

## Tokens (en `:root` del HTML)

| Rol | Valor | Uso |
|---|---|---|
| `--ground` | #eef2f1 | fondo de página (papel de taller) |
| `--panel` | #ffffff | tarjetas, pasos, formularios |
| `--ink` | #0f1f1e | texto principal |
| `--ink-2` | #47595a | texto secundario, leyendas |
| `--rule` | #ccd6d4 | bordes |
| `--signal` | #0b6b52 | acción, comprobado, progreso (verde XAMPP) |
| `--signal-soft` | #e5f1ec | fondo de comprobaciones |
| `--alert` | #a8321f | errores, lo que no tocar |
| `--alert-soft` | #faece8 | fondos de error |
| `--warn` | #8a5a00 | advertencias |
| `--warn-soft` | #fdf4e3 | fondos de aviso |

## Tipografía

Sistema: Segoe UI y pila del sistema (sin fuentes externas, funciona offline). Cuerpo 17px, toggle de tamaño (100 % → 137,5 %) persistido en localStorage. Rutas y direcciones en mono (Consolas / Cascada Mono).

## Interacciones firmas

- **Progreso**: 14 casillas, barra que se rellena, estado guardado en `localStorage` (`ifct0510.progress.v1`), reset con confirmación.
- **Botón "copiar"**: cada dirección/ruta se copia al portapapeles con fallback `execCommand` y aviso en voz (`aria-live`).
- **Tres micro-ejercicios** con feedback inmediato y desactivación al acertar.
- **Índice rail** fijo en escritorio; desplegable en móvil; paso actual por intersección.
- **Impresión**: `@media print` oculta barra superior y rail, fuerza los detalles abiertos, rompe página por parte.

## Excepción documentada del detector

`impeccable detect` devuelve un aviso `aphoristic-cadence` (7 construcciones cortas). Es intencional: el público es alfabetización digital cero, por exigencia del brief las frases son cortas y una acción por línea; no es copy de marketing.

## Nivel del certificado

No se declara ningún nivel en los documentos del alumnado. La posible discrepancia (IFCD0110 = nivel 3 en catálogo; usuario informado de nivel 1) se deja como nota de verificación solo en `guia-docente-xampp-wordpress.md`.
