# Guía docente · Práctica de extensión: Crear una web con WordPress y Gutenberg

**Certificado:** IFCT0510 · **Módulo:** Publicación web con CMS  
**Duración:** 60 minutos (10 pasos) · **Requiere:** haber superado `practica-xampp` (WordPress instalado y accesible)  
**Alumnado:** Adultos con alfabetización digital básica (ya saben ratón, teclado, navegador, carpetas)  
**Modalidad:** Individual en puesto propio · WordPress ya instalado en local (`http://localhost/miwordpress/`)  
**Material:** Esta guía + `practica-gutenberg/index.html` (versión interactiva) + `ficha-practica-xampp-wordpress.md` (chuletas)

---

## 1. Objetivos

### Objetivo general
Que el alumnado sea capaz de **crear y publicar una web sencilla** usando el editor de bloques **Gutenberg** de WordPress: entrar al panel, crear páginas, componer contenido con bloques, configurar menú, personalizar colores/tipografía y publicar.

### Objetivos específicos (medibles — 10 pasos)

Al finalizar la práctica, el alumnado será capaz de:

1. **Entrar al panel de administración** (`/wp-admin/`) con su usuario/contraseña
2. **Crear páginas** (Inicio, Sobre nosotros) y guardarlas como borrador
3. **Abrir el editor Gutenberg** y reconocer sus zonas (botón +, área de edición, barra lateral)
4. **Identificar y usar bloques básicos**: Párrafo, Encabezado, Imagen, Lista, Espacio
5. **Componer contenido**: escribir título, texto de bienvenida, insertar imagen
6. **Crear y configurar menú de navegación** con las dos páginas
7. **Establecer página de inicio estática** (Inicio) y página de entradas (Sobre nosotros)
8. **Personalizar colores y tipografía** desde el Personalizador
9. **Publicar la página Inicio** y verificar que se ve correctamente
10. **Navegar por la web publicada** y comprobar menú, imágenes, textos

> **Criterio de superación:** 10 de 10 pasos completados y web accesible en `http://localhost/miwordpress/`

---

## 2. Requisitos previos (verificar antes de empezar)

| Requisito | Cómo verificarlo | Quién |
|-----------|------------------|-------|
| **WordPress instalado** en local | `http://localhost/miwordpress/wp-admin/` carga | Profesor (al final de práctica XAMPP) |
| **Usuario/contraseña** funcionando | Alumnado accede al escritorio WP | Alumno (al empezar) |
| **Apache + MySQL** arrancados | Panel XAMPP → ambos en verde (Stop + puertos 80/3306) | Profesor (inicio de sesión) |
| **Navegador** actualizado | Chrome/Edge/Firefox | Profesor |
| **Imagen de prueba** disponible | En `Descargas` o carpeta compartida | Profesor (preparar 1 imagen genérica por alumno) |

> ⚠️ **Si algún alumno no superó la práctica XAMPP:** no empieza esta. Repetir bloques necesarios de XAMPP primero.

---

## 3. Desarrollo por bloques (timing ~60 min)

| Min | Bloque | Pasos | Qué hace el profesor | Qué hace el alumnado | Verificación |
|-----|--------|-------|---------------------|---------------------|--------------|
| 0-5 | **Pre-vuelo** | — | Reparte ficha alumno. Verifica que WP instalado y servicios arrancados | Marcan 5 comprobaciones previas | Todos con ✅ en preflight |
| 5-15 | **A. Panel + Páginas** | 1-3 | Demuestra login, "Páginas → Añadir nueva", "Guardar borrador" | Entran a `/wp-admin/`, crean **Inicio** y **Sobre nosotros** como borrador | 2 páginas en lista con estado "Borrador" |
| 15-35 | **B. Editor Gutenberg** | 4-6 | Demuestra: botón +, bloques básicos, escribir título/texto, añadir imagen | Abren Inicio → Editan → Añaden: Encabezado (título), Párrafo (bienvenida), Imagen (suben imagen) | Página Inicio con título + texto + imagen en previsualización |
| 35-45 | **C. Menú + Inicio estática** | 7-8 | Demuestra: Apariencia → Menús → crear → añadir páginas → ubicación "Menú principal". Luego: Ajustes → Lectura → Página estática | Crean menú "Principal" con Inicio + Sobre nosotros. Configuran Inicio como estática | Menú visible en web + Inicio carga como portada |
| 45-55 | **D. Personalizar + Publicar** | 9-10 | Demuestra: Apariencia → Personalizar → Colores + Tipografía → Publicar. Luego: botón "Publicar" en editor | Eligen color principal + fuente legible. Publican Inicio. Van a `Visitar sitio` | Web publicada con menú, colores, tipografía, contenido |
| 55-60 | **Cierre + Checklist** | — | Repaso chuletas. Entrega evidencias (capturas) | Marcan checklist final. Capturan web publicada + panel | 10/10 en checklist + capturas entregadas |

---

## 4. Detalle de pasos críticos (puntos donde se atasca el alumnado)

| Paso | Qué falla habitualmente | Cómo desbloquear |
|------|------------------------|------------------|
| **1. Login** | Olvidan usuario/contraseña | "Apuntaste en tu ficha XAMPP (punto 6). Búscalo ahí" |
| **2-3. Páginas** | Crean "Entradas" en vez de "Páginas" | "Izquierda: **Páginas** (contenido estático). Entradas = blog. Usa Páginas" |
| **4. Editor Gutenberg** | No ven el botón **+** / no saben que todo es bloque | "Arriba a la izquierda: **+**. Todo es un bloque. Prueba: pulsa + → Párrafo" |
| **5. Bloques** | Confunden Encabezado vs Párrafo / no encuentran Imagen | "Encabezado = título grande (H1/H2). Párrafo = texto normal. Imagen = foto" |
| **6. Imagen** | Suben imagen pero no la ven / la ponen en bloque wrong | "Bloque Imagen → Subir → Seleccionar archivo → Insertar. Aparece en el editor" |
| **7. Menú** | Crean menú pero no asignan ubicación "Menú principal" | "Abajo del todo: **Ubicación del menú** → Marca 'Menú principal' → Guardar" |
| **8. Inicio estática** | No encuentran Ajustes → Lectura / confunden "Página de inicio" con "Página de entradas" | "Ajustes → Lectura → 'Una página estática' → Inicio: **Inicio**, Entradas: **Sobre nosotros**" |
| **9. Colores/Tipografía** | No ven cambios en la web tras Personalizar | "Personalizar → Publicar (arriba). Luego recarga `http://localhost/miwordpress/`" |
| **10. Publicar** | Pulsan "Publicar" una vez y no la segunda confirmación | "Botón 'Publicar' → revisa → vuelve a pulsar 'Publicar' (botón azul)" |

---

## 5. Evaluación (rúbrica)

| Criterio | Peso | Insuficiente (0-4) | Adecuado (5-7) | Excelente (8-10) |
|----------|------|-------------------|----------------|------------------|
| **Panel + Páginas** (login, crear páginas, borrador) | 20 % | No entra o no crea páginas | Crea 2 páginas, estado borrador | Además explica diferencia Página vs Entrada |
| **Editor Gutenberg** (bloques, título, texto, imagen) | 30 % | No usa bloques, imagen no se ve | Título + párrafo + imagen visible | Usa varios bloques (lista, espacio), maqueta limpia |
| **Menú + Inicio estática** | 25 % | Menú no se ve o inicio no cambia | Menú visible, Inicio carga como portada | Configura correctamente ambas opciones |
| **Personalizar + Publicar** | 25 % | No publica o colores no aplican | Publica, web visible con cambios | Elige colores/fuente coherentes, web profesional |

> **Evaluación práctica:** El profesor recorre puestos y verifica **en directo** que la web carga en `http://localhost/miwordpress/` con menú, contenido e imagen.  
> **Evidencia de entrega:** Captura de pantalla de la web publicada + captura del panel `wp-admin` + captura del menú en Personalizador.

---

## 6. Incidencias típicas y soluciones

| Incidencia | Causa | Solución |
|------------|-------|----------|
| "Error al establecer conexión con la base de datos" | MySQL parado o credenciales mal en `wp-config.php` | Profesor: verifica XAMPP → MySQL en verde. Si persiste: revisa `wp-config.php` (DB_NAME, DB_USER=root, DB_PASSWORD='', DB_HOST=localhost) |
| "La web se ve sin estilos / rota" | Tema roto / archivos faltantes en `htdocs/miwordpress` | Verifica paso 8 de XAMPP: estructura plana (wp-admin, wp-content, wp-includes, index.php directamente en miwordpress) |
| "No veo el botón + en Gutenberg" | Editor clásico activo / plugin conflicto | Ajustes → Escritura → "Editor de bloques por defecto". Desactiva plugins si hay |
| "La imagen no se sube / error HTTP" | Permisos carpeta `wp-content/uploads` / PHP `upload_max_filesize` | Profesor: `icacls "C:\xampp\htdocs\miwordpress\wp-content\uploads" /grant Everyone:(OI)(CI)F` / `php.ini` → `upload_max_filesize = 64M` |
| "El menú no aparece" | Ubicación "Menú principal" no marcada / tema sin soporte | Apariencia → Menús → Ubicaciones → Marca "Menú principal". Tema por defecto (Twenty Twenty-Four) lo soporta |
| "Cambios en Personalizar no se guardan" | No pulsó "Publicar" en el Personalizador | "Arriba a la izquierda en Personalizador: botón **Publicar**. Pulsa y espera" |

---

## 7. Ampliación (alumnado que termina antes — opcional)

| Nivel | Qué hacer | Qué aprende |
|-------|-----------|-------------|
| **Fácil** | Cambiar tema en Apariencia → Temas → Activar "Twenty Twenty-Three" | Diferencia tema vs contenido |
| **Medio** | Añadir bloque **Lista** con 5 cosas que le gustan. Añadir **Espacio** entre bloques | Maquetación con bloques estructurales |
| **Avanzado** | Crear **Entrada** (blog) en Entradas → Añadir nueva. Asignar categoría. Ver en web | Diferencia Página vs Entrada, archivo de blog |
| **Avanzado** | Instalar plugin "Contact Form 7" → crear formulario de contacto → poner en página Contacto | Plugins, formularios, shortcodes |
| **Investigación** | Exportar BD desde phpMyAdmin (`.sql`) → importar en `wordpress_db2` → cambiar `wp-config.php` → segunda web | Migración, entornos, BD |

---

## 8. Checklist del profesor (antes / durante / después)

### Antes
- [ ] XAMPP: Apache + MySQL en verde (puertos 80/3306)
- [ ] WordPress instalado y accesible en `http://localhost/miwordpress/wp-admin/`
- [ ] Usuario/contraseña de cada alumno funcionando (o lista maestra)
- [ ] Imagen de prueba en carpeta compartida / `Descargas` de cada equipo
- [ ] Proyector con `practica-gutenberg/index.html` abierto
- [ ] Fichas alumno (`ficha-practica-xampp-wordpress.md` tiene chuletas Gutenberg al final)

### Durante
- [ ] Login de todos verificado (paso 1)
- [ ] Páginas creadas como **borrador** (no publicadas aún) — pasos 2-3
- [ ] Editor Gutenberg: título + párrafo + imagen en página **Inicio** — paso 6
- [ ] Menú creado, ubicación "Menú principal" marcada — paso 7
- [ ] Ajustes → Lectura → Página estática configurada — paso 8
- [ ] Personalizar → Colores + Tipografía → **Publicar** — paso 9
- [ ] Página Inicio **Publicada** (doble clic en botón) — paso 10
- [ ] Web visitada y verificada: menú, colores, imagen, textos

### Después
- [ ] Recoge evidencias: 3 capturas por alumno (web publicada, panel wp-admin, personalizador)
- [ ] Anota quién no llegó a 10/10 → refuerzo en siguiente sesión
- [ ] Actualiza esta guía con incidencias nuevas del grupo

---

## 9. Chuletas de referencia rápida (para proyectar / repartir)

```
BLOQUES BÁSICOS GUTENBERG
+ → Párrafo      (texto normal)
+ → Encabezado   (H1, H2, H3... títulos)
+ → Imagen       (foto/ilustración)
+ → Lista        (viñetas o numerada)
+ → Espacio      (separación entre bloques)

ATAJOS ÚTILES
Ctrl + Z    Deshacer
Ctrl + S    Guardar borrador (en editor)
Ctrl + P    Imprimir (en navegador)
⊞ + Shift + S   Captura pantalla

RUTAS CLAVE
http://localhost/miwordpress/          → Web publicada
http://localhost/miwordpress/wp-admin/ → Panel administración
http://localhost/phpmyadmin/           → Base de datos
http://localhost/                      → Panel XAMPP
```

---

## 10. Enlaces y versión

- **Versión interactiva alumno:** `practica-gutenberg/index.html` (progreso localStorage, toggle fuente, imprimible A4)
- **Ficha alumno (chuletas incluidas):** `ficha-practica-xampp-wordpress.md` (final del documento)
- **Práctica previa (requisito):** `practica-xampp/index.html` + `guia-docente-xampp-wordpress.md`
- **Sesión 0 (si hace falta):** `sesion-0/index.html` + `guia-docente-sesion-0.md`

---

## 11. Notas de versión

- **v1.0** (octubre 2026): Estructurada a partir de `practica-gutenberg/index.html` y `guia-docente-xampp-wordpress.md`
- **Diferencia con guía XAMPP:** Esta es **extensión** (contenido/maquetación), no instalación. Requiere WP ya funcionando
- **Mantenimiento:** Revisar cada curso — actualizar capturas si cambia Gutenberg/WP, añadir bloques nuevos (Patrones, Columnas, etc.)

---

*Guía viva: anota en margen incidencias de tu grupo y actualízala al cierre del curso.*