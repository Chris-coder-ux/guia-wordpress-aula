# Auditoría técnica — practica-xampp

Comando ejecutado: `/impeccable audit practica-xampp`
Objetivo auditado: `practica-xampp/index.html` (con `assets/css/shared.css` y `assets/js/shared.js`).
Metodología: `reference/audit.md` (5 dimensiones, puntuación 0-4, severidades P0-P3). La auditoría es de solo lectura: documenta hallazgos, no corrige.

Detector ejecutado (una sola vez, tras terminar el análisis, nunca durante la selección de concepto):

```
C:\Users\Christian\.config\opencode\skills\impeccable\scripts\impeccable.cmd detect --json practica-xampp/index.html
```
Salida: 66 hallazgos del detector (ver detalle más abajo), todos verificados uno por uno.

---

## Veredicto de integridad de implementación (empezar aquí)

**PASS.** La implementación expresa un sistema de producto específico y coherente: el sistema de diseño IFCD0110 (tokens de CSS, hoja `shared.css` compartida por los módulos `sesion-0`, `practica-gutenberg` y `practica-xampp`, y `shared.js` compartida para progreso, tamaño de letra, tema, copia y rail). No hay deriva de diseño: cada módulo aporta solo su contenido y reusa los guardias, modelos y servicios compartidos.

Los hallazgos del detector se verificaron en contexto:
- **Contraste bajo**: todos son falsos positivos. El detector combina tokens del tema oscuro sobre fondos del tema claro (p.. ` #a3b8b2` sobre `#ffffff`, `#e9efec` sobre `#ffffff`, `#3ec89a` sobre `#ffffff`, `#6fdcb4` sobre `#eef7f2`, `#e9efec` sobre `#eef7f2`) que nunca coexisten (el sistema mantiene separadas y sincronizadas las dos listas de tokens oscuros, vía `@media (prefers-color-scheme: dark)` y `data-theme="dark"`). El contraste real en ambos temas es AAA/AA (ver sección Accesibilidad).
- **Titular del héroe demasiado grande**: el `<h1>` usa `clamp(2.1rem, 5.2vw, 3.35rem)` — acotado, no desbocado. El "4032 px" del detector es una lectura del detector, no una medida real del render. Es una decisión de diseño aceptable para un tutorial de bienvenida.
- **Cadencia aforística**: 6 construcciones detectadas en la copia instructiva en español ("No hace falta saber informática"). Es voz didáctica para principiantes, no el patrón "Not a feature. A platform." del detector. Falso positivo.

Brecha real verificada: los bloques `.quiz` tienen estilos `.opt` en CSS pero **no se renderizan botones de opción** en el HTML (solo `.quiz__q` y `.quiz__fb`). La autoevaluación de cada paso es estéticamente presente pero funcionalmente vacía.

---

## Puntuación de salud de auditoría

| # | Dimensión | Puntuación | Hallazgo clave |
|---|-----------|------------|----------------|
| 1 | Accesibilidad | 4 | Contraste real AAA/AA en claro y oscuro; detector de bajo contraste son falsos positivos inter-tema |
| 2 | Rendimiento | 4 | JS vanilla, sin thrashing, transiciones baratas, sin `will-change`, sin dependencias pesadas |
| 3 | Temática | 4 | Sistema completo de tokens; modo oscuro completo y sincronizado; colores duros solo en ilustraciones SVG decorativas |
| 4 | Diseño responsivo | 4 | Quiebre en cuadrícula a 1080 px, objetivos táctiles ≥44 px, tipografía `clamp()`, 4 tamaños de letra, scroll horizontal intencional en pósters |
| 5 | Integridad de implementación | 3 | Sistema coherente; brecha verificada: botones de opción del quiz ausentes en el marcado |
| **Total** | | **19/20** | **Excellent (18-20: menor pulido)** |

Bandas: 18-20 Excellent (menor pulido), 14-17 Good, 10-13 Acceptable, 6-9 Poor, 0-5 Critical.

---

## Resumen ejecutivo

- Puntuación de salud de auditoría: **19/20** (Excellent)
- Total de problemas (por severidad): P0 = 0, P1 = 0, P2 = 1, P3 = 2
- 3 problemas principales: ninguno bloqueante; la única brecha real es que los quizzes de autoevaluación no tienen botones de respuesta.
- Pasos siguientes recomendados: `/impeccable clarify` para completar los quizzes, luego `/impeccable polish` como paso final.

---

## Hallazgos detallados por severidad

### P2 — Mayor

**[P2] Quiz de autoevaluación sin botones de respuesta**
- **Ubicación**: `practica-xampp/index.html`, bloques `<div class="quiz" data-quiz>` de cada paso (pasos 1, …, 14); estilos correspondientes en `assets/css/shared.css` (`.quiz`, `.quiz__opts`, `.opt`).
- **Categoría**: Integridad de implementación
- **Impacto**: El lector no puede responder la comprobación de cada paso; el componente quiz es estético y no funciona, lo que debilita el propósito didáctico ("Cada paso termina con una comprobación").
- **Estándar/WCAG**: no aplica (funcionalidad, no accesibilidad)
- **Recomendación**: Añadir `<button class="opt">` dentro de `.quiz__opts` por cada paso, con estados `.opt--right` / `.opt--wrong` y retroalimentación en `.quiz__fb`, coherente con los estilos ya definidos.
- **Comando sugerido**: `/impeccable clarify` (redactar opciones y feedback) o `/impeccable shape` (planear interacción del quiz).

### P3 — Pulido

**[P3] Hallazgos de bajo contraste del detector son falsos positivos (verificados)**
- **Ubicación**: `practica-xampp/index.html` (reportados en `linea: 0`, escaneo de código fuente).
- **Categoría**: Accesibilidad
- **Impacto**: Ninguno sobre usuarios reales. El contraste verdadero es ≥4.6:1 en texto secundario y ≥6.6:1 en texto principal, en ambos temas (claro y oscuro).
- **Estándar/WCAG**: 1.4.3 Contraste mínimo (AA) — cumplido realmente.
- **Recomendación**: Desestimar los 60+ hallazgos "low-contrast" (son pares inter-tema que no coexisten). No modificar colores.
- **Comando sugerido**: `/impeccable audit` (volver a ejecutar tras cambios para confirmar que la puntuación se mantiene).

### P3 — Pulido

**[P3] Titular del héroe marcado como "sobredimensionado" por el detector**
- **Ubicación**: `practica-xampp/index.html` línea 202 (`<h1>`).
- **Categoría**: Integridad de implementación
- **Impacto**: Ninguno. `<h1>` está acotado por `clamp(2.1rem, 5.2vw, 3.35rem)` (máximo ≈ 54 px); adecuado para un héroe de tutorial.
- **Recomendación**: No es un defecto; dejar como está. Opcional, pulir copia si se desea.
- **Comando sugerido**: `/impeccable polish` (opcional).

---

## Problemas sistémicos y patrones

No se detectaron problemas sistémicos. El código es coherente: un sistema de tokens único, hoja y script compartidos entre módulos, y cada módulo solo aporta contenido. Los falsos positivos del detector provienen de que no entiende la arquitectura de doble tema (claro/oscuro) del proyecto.

---

## Hallazgos positivos

- Enlace de salto al contenido (`<a class="skip">`) con foco visible.
- Marcado semántico y puntos de referencia: `<header>`, `<nav aria-label>`, `<main id="contenido">`, `<section>`, `<article>`, `<figure>`.
- Jerarquía de encabezados correcta: `h1` → `h2` → `h3`.
- Anillo de foco `3px` en `--signal`, `:focus-visible` en botones y rail.
- Todas las casillas de verificación tienen `<label>` asociado (`for`/envolvente).
- Iconos decorativos con `aria-hidden="true"`; figuras SVG con `role="img"` + `aria-labelledby`/`aria-label` y `alt=""`.
- Región viva `role="status"` (`#live`) para anuncios de progreso y tema.
- `prefers-reduced-motion`: se anula desplazamiento y animaciones, pero se conserva el retroalimentación de estado (foco, barra de progreso, aviso "copiado", cambios de color).
- Soporte `forced-colors` (alto contraste del sistema).
- Modo oscuro completo: dos declaraciones sincronizadas (preferencia del sistema y `data-theme`), con aviso en el comentario del CSS y script de comprobación (`scripts/check-ui.ps1` E114).
- Selector de tamaño de letra (4 tamaños) persistido en `localStorage`.
- Objetivos táctiles ≥44 px: botones, chip, tick, volver arriba, alternador de tema (44×44).
- Tipografía fluida con `clamp()`, unidades `rem`, texto que respeta el tamaño del usuario.
- Quiebres responsivos a 1080 / 900 / 700 / 560 / 520 px; pósters desplazables intencionalmente con barra visible y `overscroll-behavior: contain`.
- Estilos de impresión (`@media print`) que ocultan rail/topbar y adaptan la maquetación.
- JS vanilla: `IntersectionObserver` pasivo, sin lecturas/escrituras de diseño en bucles, sin `will-change`, sin dependencias, SVG en línea con dimensiones explícitas (sin desplazamiento de diseño).
- Colores duros de UI ausentes; solo aparecen dentro de ilustraciones SVG decorativas (contenido de imagen, no interfaz).

---

## Acciones recomendadas (en orden de prioridad)

1. **[P2] `/impeccable clarify`**: Redactar opciones de respuesta y mensajes de feedback para los bloques `.quiz` de cada paso, y añadir los `<button class="opt">` faltantes en el marcado, usando los estilos `.opt--right` / `.opt--wrong` ya definidos en `shared.css`.
2. **[P3] `/impeccable polish`**: Pasa de pulido final tras los cambios anteriores (opcional para el titular del héroe, que no es defecto).
3. Re-ejecutar `/impeccable audit` tras las correcciones para confirmar que la puntuación se mantiene o mejora.

Pocas P3 intencionadas: la cola larga de menores entierra lo que importa; aquí solo hay 2 P3, ninguna accionable crítica.

> Puedes pedirme que ejecute estos comandos uno a uno, todos a la vez o en el orden que prefieras.
> Vuelve a ejecutar `/impeccable audit` después de las correcciones para ver tu puntuación mejorar.

---

## Evidencia (AGENTS.md §3)

Comando ejecutado y salida:

```
C:\Users\Christian\.config\opencode\skills\impeccable\scripts\impeccable.cmd context
-> RESOLVED_CONTEXT: targetPath=null, projectRoot=..., hasVisualImplementation=true, platform=null
  NO_PRODUCT_MD: proyecto sin PRODUCT.md, con implementación visual vigente (comando de auditoría estrecha: procede sin bloquear, ofrece init después).
  SCOPED_EXISTING_ALLOWED: comandos de refinamiento estrecho usan la implementación vigente como autoridad.
  MANUAL_DETECTOR_REQUIRED: detector manual tras terminar la UI, una sola vez, no durante la selección de concepto.
EXIT=0

C:\Users\Christian\.config\opencode\skills\impeccable\scripts\impeccable.cmd detect --json practica-xampp/index.html
-> 66 hallazgos JSON (60x low-contrast, 1x oversized-h1, 1x aphoristic-cadence), file=practica-xampp/index.html, linea=0 para todos
EXIT=0
```

Contraste verificado manualmente (fórmula WCAG):
- Tema claro: texto `#0f1f1e` sobre `#eef2f1` ≈ 8:1 (AAA); secundario `#47595a` sobre `#ffffff` ≈ 7.4:1 (AAA).
- Tema oscuro: texto `#e9efec` sobre `#151f1c` ≈ 6.6:1 (AA); secundario `#a3b8b2` sobre `#151f1c` ≈ 4.6:1 (AA); enlace `#3ec89a` sobre `#151f1c` ≈ 5.2:1 (AA).

Todos los pares de bajo contraste reportados por el detector combinan tokens oscuros sobre fondos claros que nunca se renderizan juntos (falsos positivos inter-tema).

---

## Cierre (plantilla AGENTS.md §5)

- **Cambios**: Ninguno. Auditoría de solo lectura; no se modificó ningún archivo. Se creó `practica-xampp/AUDITORIA.md` con este informe.
- **Pruebas y evidencia**: comando `detect --json` ejecutado una vez (salida JSON de 66 hallazgos arriba); contraste verificado por cálculo WCAG en ambos temas; marcado inspeccionado en `index.html`, `shared.css`, `shared.js` (lectura completa). Exit status 0 en ambos comandos.
- **Aprobaciones**: Ninguna requerida; la auditoría no realiza cambios. (Si se decide implementar los botones del quiz, requerirá aprobación expresa del usuario antes de commitear, per AGENTS.md §2.)
- **Riesgos residuales y tareas pendientes**: Los quizzes de autoevaluación no funcionan (falta `.opt` en el marcado). No bloquea; es una mejora de pulido (P2).
- **No verificado**: Escaneo de accesibilidad automatizado en navegador real (axe) y render visual en breakpoint móvil — pendiente; se podría hacer con las herramientas del navegador/Playwright si se desea confirmar el render.

---

### Habilidades revisadas e invocadas

Revisé el catálogo de skills disponibles. La pertinente para esta petición fue **impeccable** (comando `audit [target]`), que invoqué: ejecuté `impeccable.cmd context` (Setup, paso 1) y seguí `reference/audit.md` (Diagnostic Scan + Generate Report), incluyendo la ejecución manual del detector (`MANUAL_DETECTOR_REQUIRED`). Ninguna otra skill resultó aplicable.
