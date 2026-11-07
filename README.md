# IFCT0510 · Prácticas de aula — XAMPP + WordPress + Gutenberg

Material didáctico **imprimible, interactivo y offline** para el certificado **IFCT0510** (Gestión de sistemas informáticos).

> **Público:** Alumnado desde cero (nunca ha usado un ordenador) · Adultos en aula · Equipos Windows 10/11 del centro  
> **Formato:** HTML autónomo (sin internet, sin CDN, sin build) + Markdown para imprimir/entregar  
> **Licencia:** Uso docente interno · Adaptable a tu centro

---

## 📦 Qué incluye este repo

| Carpeta / Archivo | Qué es | Para quién |
|-------------------|--------|------------|
| `index.html` | Portada con enlaces a los 3 módulos | Alumnado / Profesorado |
| `sesion-0/` | **Sesión 0** · Primeros pasos (ratón, teclado, carpetas, capturas) — 12 pasos, ~90 min | Alumnado sin experiencia |
| `practica-xampp/` | **Práctica principal** · Instalar XAMPP + WordPress en local — 14 pasos, 3 sesiones de 60 min | Alumnado |
| `practica-gutenberg/` | **Primera sesión de Gutenberg** · Crear una página con bloques básicos — 12 pasos, 60 min | Alumnado (tras XAMPP) |
| `assets/` | CSS/JS/SVGs compartidos (SRP) | — (infraestructura) |
| `material/` | **Documentos para imprimir/entregar** (Markdown) | Alumnado + Profesorado |
| `documentos/` | `DESIGN.md` + `PRODUCT.md` (contexto de diseño/producto) | Equipo docente / Mantenedores |

---

## 🚀 Cómo usar en el aula (sin internet)

### Opción A — Servidor local rápido (recomendado)
```bash
# Desde la raíz del repo
python -m http.server 8080
# Abre http://localhost:8080/ en el navegador
```
> Funciona en cualquier equipo con Python instalado. No requiere internet tras la primera carga.

### Opción B — Copia directa a equipos del aula
1. Copia **toda la carpeta** del repo a cada equipo (USB, red local, carpeta compartida).
2. Haz doble clic en `index.html` → se abre en el navegador por defecto.
3. **Todo funciona sin internet**: CSS/JS/SVGs son locales, progreso se guarda en `localStorage` del navegador.

### Opción C — Solo imprimir (papel)
Los archivos en `material/*.md` están listos para:
- Abrir en VS Code / Obsidian / Typora → **Exportar a PDF** (A4, márgenes normales)
- O convertir con `pandoc`:
  ```bash
  pandoc material/ficha-practica-xampp-wordpress.md -o ficha-alumno.pdf --pdf-engine=weasyprint
  ```

---

## 📚 Estructura de las 3 prácticas (orden recomendado)

| Orden | Módulo | Pasos | Tiempo | Qué aprenden |
|-------|--------|-------|--------|--------------|
| 1 | **Sesión 0** | 12 | ~90 min | Encender, escritorio, ratón (clic/doble/clic derecho/arrastrar), teclado (8 teclas clave), navegador (barra vs buscador), descargas, carpetas, capturas, ergonomía |
| 2 | **XAMPP + WordPress** | 14 | 3×60 min | Instalar XAMPP (solo Apache/MySQL/phpMyAdmin), arrancar servicios, verificar puertos, descargar WP, desplegar en `htdocs/miwordpress`, crear BD en phpMyAdmin, instalar WP, acceder a `wp-admin`, ver web publicada |
| 3 | **Gutenberg (primera sesión)** | 12 | 60 min | Entrar al panel, elegir el aspecto de la web, comprobar Gutenberg, crear las páginas Inicio y Sobre nosotros, abrir el editor, usar bloques básicos (encabezado, texto e imagen), menú, página de inicio estática, colores y letra, y publicar |

> **Regla de oro:** Si el alumnado no supera la **lista de comprobación del paso 10 (Sesión 0)** o la del **paso 14 (XAMPP)**, **no pasa al siguiente módulo**. Repetir el bloque correspondiente.

---

## 🧑‍🏫 Material para el profesorado (en `material/`)

| Archivo | Qué contiene |
|---------|--------------|
| `guia-docente-xampp-wordpress.md` | Objetivos medibles, 4 hitos con verificaciones, tabla de incidencias, rúbrica 4 criterios (25 % cada uno), ampliaciones, anexo rutas |
| `guia-docente-sesion-0.md` | Objetivos, timing por bloques (90 min), señales de "grupo no listo", adaptaciones, rúbrica observacional |
| `guia-docente-gutenberg.md` | Objetivos, 3 bloques, verificaciones por paso, rúbrica, incidencias típicas |
| `ficha-practica-xampp-wordpress.md` | **Versión alumno** (lenguaje llano, glosario, hoja de progreso, capturas, diccionario, chuletas) |
| `sesion-0-primeros-pasos.md` | **Versión alumno** de la Sesión 0 (para imprimir/entregar antes de la práctica principal) |
| `plantilla-evidencias.md` | Plantilla para que el alumnado entregue capturas ordenadas + frase `localhost` + incidencia |

---

## ♿ Accesibilidad y restricciones verificadas

- ✅ **Sin internet**: 0 peticiones externas (CDN, fuentes, analítica)
- ✅ **Imprimible A4**: `@media print` oculta UI, rompe página por parte, muestra URLs
- ✅ **Contraste AA**: Tokens `--ink`/`--panel`/`--signal` validados
- ✅ **Navegación teclado**: `Skip link`, `:focus-visible`, `tabindex` correctos
- ✅ **Redimensionable**: Toggle tamaño fuente (100 % → 137.5 %) persistido
- ✅ **Preferencias sistema**: `prefers-reduced-motion`, `prefers-contrast`, `forced-colors`
- ✅ **Áreas táctiles ≥ 44 px**: Botones, chips, checkboxes
- ✅ **Offline total**: Abre con doble clic, funciona en red aislada del aula

---

## 🛠️ Stack técnico (para mantenimiento)

- **HTML5 semántico** + **CSS custom properties** (tokens en `:root`)
- **Vanilla JS** (ES2020) — `localStorage` por módulo (`ifct0510-portada-*`, `ifct0510-s0-*`, `ifct0510-xampp-*`, `ifct0510-gutenberg-*`)
- **Claves de progreso** — `ifct0510-portada-progress.v1`, `ifct0510-s0-progress.v1`, `ifct0510-xampp-progress.v1`, `ifct0510-gutenberg-progress.v3` (más las `*-font.v1` para el tamaño de letra)
- **Gate estático de UI** — `scripts/check-ui.ps1` valida el rail, el índice móvil, el foco del salto al contenido y las claves de progreso (`-Fail` devuelve error de salida)
- **SVG inline/externo** — diagramas esquemáticos a mano (estilo manual de taller)
- **Arquitectura SRP**: cada módulo = su HTML; `assets/css/shared.css` + `assets/js/shared.js` compartidos
- **Git** — histórico en `master`, commits atómicos por fase

---

## 📝 Checklist rápido para el docente antes de la sesión

- [ ] Verificar que los equipos tienen **Windows 10/11** y **permisos de admin** (UAC)
- [ ] Comprobar **≥ 2 GB libres** en disco
- [ ] Confirmar **puerto 80 libre** (no IIS, Skype, Teams corriendo)
- [ ] Tener **Python** instalado si vas a usar `http.server` (opcional)
- [ ] Imprimir/entregar: `material/sesion-0-primeros-pasos.md` (sesión 0) + `material/ficha-practica-xampp-wordpress.md` (práctica principal)
- [ ] Tener a mano: `material/guia-docente-sesion-0.md`, `material/guia-docente-xampp-wordpress.md`, `material/guia-docente-gutenberg.md`
- [ ] Preparar plantilla de evidencias: `material/plantilla-evidencias.md` (una por alumno/grupo)

---

## 🔗 Rutas de referencia rápida

```text
Portada                http://localhost:8080/          (o doble clic en index.html)
Sesión 0               http://localhost:8080/sesion-0/
XAMPP + WordPress      http://localhost:8080/practica-xampp/
Gutenberg              http://localhost:8080/practica-gutenberg/

Panel XAMPP            http://localhost/
phpMyAdmin             http://localhost/phpmyadmin/
Web alumno             http://localhost/miwordpress/
Panel WP alumno        http://localhost/miwordpress/wp-admin/
Carpeta despliegue     C:\xampp\htdocs\miwordpress\
```

---

## 📄 Licencia y créditos

- **Uso docente interno** — Adaptable a tu centro/certificado
- Diagramas SVG: estilo "manual de taller" (hechos a mano en el HTML)
- Tipografía: pila del sistema (`Segoe UI`, `system-ui`, `-apple-system`) — sin fuentes externas
- Iconos: `assets/svg/` (logo, print, check, info, warn, copy) — SVGs propios
- Guía visual del paso 1 de `sesion-0/`: `assets/svg/encender.svg` — póster de 1440 × 900; dentro de la página se ve en miniatura y se abre a tamaño nativo con el enlace «Abrir la guía ampliada»
- Infografía del paso 2 de `sesion-0/`: `assets/svg/zonas-escritorio.svg` — póster de 1200 × 840 con las 5 zonas del escritorio; se ve en miniatura y se abre a tamaño nativo con el enlace «Abrir la infografía ampliada»
- Ilustración del paso 3 de `sesion-0/`: `assets/svg/raton.svg` — póster de 900 × 560 con la postura de la mano sobre el ratón y el puntero; se ve en miniatura y se abre a tamaño nativo con el enlace «Abrir la ilustración ampliada»
- Ilustración del paso 4 de `sesion-0/`: `assets/svg/teclado.svg` — póster de 900 × 380 con el teclado completo y las 8 teclas de la sesión resaltadas en verde; se ve en miniatura y se abre a tamaño nativo con el enlace «Abrir la ilustración ampliada»
- Ilustración del paso 5 de `sesion-0/`: `assets/svg/navegador.svg` — póster de 900 × 560 con la ventana del navegador, la barra de direcciones y el buscador de Google resaltados en verde; se ve en miniatura y se abre a tamaño nativo con el enlace «Abrir la ilustración ampliada»
- Ilustración del paso 6 de `sesion-0/`: `assets/svg/descargas.svg` — póster de 900 × 560 con la secuencia navegador → diálogo Guardar imagen → Explorador de archivos y las cuatro marcas del proceso; se ve en miniatura y se abre a tamaño nativo con el enlace «Abrir la ilustración ampliada»
- Ilustración del paso 7 de `sesion-0/`: `assets/svg/carpetas.svg` — póster de 1200 × 880 con cuatro ventanas del Explorador (crear la carpeta en Documentos, nombrarla, cortar `gato.jpg` en Descargas y pegarlo dentro) y las cuatro marcas del proceso; se ve en miniatura y se abre a tamaño nativo con el enlace «Abrir la ilustración ampliada»

---

## 📞 Soporte / Dudas

Si algo no funciona en el aula:
1. Revisa la **tabla de incidencias** en `material/guia-docente-xampp-wordpress.md` (sección 6)
2. Verifica que Apache/MySQL están **en verde** en el panel de XAMPP
3. Comprueba que la estructura en `htdocs/miwordpress` es **plana** (sin carpeta `wordpress` intermedia)
4. Si persiste: **para, anota lo que ves, avisa al profesor** — cuanto menos se toque, más fácil arreglarlo

---

*Generado y mantenido para el certificado IFCT0510. Última actualización: octubre 2026.*