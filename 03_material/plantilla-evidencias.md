# Plantilla de evidencias — Práctica XAMPP + WordPress + Gutenberg

**Certificado:** IFCT0510 · **Alumno:** ___________________________________  
**Grupo:** ______ · **Fecha de entrega:** _______________ · **Firma profesor:** _______________

---

## 📋 Instrucciones

1. **Rellena esta plantilla** (en el ordenador o impresa) con tus capturas de pantalla
2. **Nombra los archivos** como: `apellidos_nombre_evidencia_N.png` (ej: `garcia_ana_evidencia_1.png`)
3. **Entrega** en la carpeta compartida / USB / plataforma del centro antes de la fecha límite
4. **Tres capturas obligatorias** + frase `localhost` + incidencia = práctica completa

---

## 1️⃣ Evidencias obligatorias (capturas de pantalla)

| # | Qué capturar | Cómo hacerlo | Nombre archivo | ✅ |
|---|--------------|--------------|----------------|----|
| **1** | **Panel XAMPP** con **Apache y MySQL en verde** (botones "Stop" + puertos 80 y 3306) | `⊞+Shift+S` → selecciona panel XAMPP → pega en Word → guarda como imagen | `apellidos_nombre_evidencia_1.png` | ☐ |
| **2** | **Carpeta `miwordpress` abierta** en Explorador: se ve `wp-admin`, `wp-content`, `wp-includes`, `index.php`, `wp-config-sample.php` **directamente** (sin carpeta `wordpress` intermedia) | `⊞+Shift+S` → selecciona ventana Explorador → pega en Word | `apellidos_nombre_evidencia_2.png` | ☐ |
| **3** | **phpMyAdmin** mostrando la base de datos **`wordpress_db`** en la lista de la izquierda | `⊞+Shift+S` en `http://localhost/phpmyadmin/` → pega en Word | `apellidos_nombre_evidencia_3.png` | ☐ |
| **4** | **Tu web publicada** en `http://localhost/miwordpress/` (se ve menú, título, imagen, texto) | `⊞+Shift+S` en tu web → pega en Word | `apellidos_nombre_evidencia_4.png` | ☐ |
| **5** | **Panel de WordPress** (`wp-admin`) con tu usuario logado (se ve menú izquierdo: Entradas, Páginas, Apariencia…) | `⊞+Shift+S` en `http://localhost/miwordpress/wp-admin/` | `apellidos_nombre_evidencia_5.png` | ☐ |

> 💡 **Tip:** Haz las capturas con `⊞ + Shift + S` (Windows) o `Cmd + Shift + 4` (Mac). Pégalo en Word (`Ctrl+V`) → clic derecho en la imagen → "Guardar como imagen…" → PNG.

---

## 2️⃣ Frase `localhost` (explicación con tus palabras)

> **Escribe aquí, con tus propias palabras, qué significa `http://localhost/` y por qué solo funciona en tu ordenador:**

________________________________________________________________________________
________________________________________________________________________________
________________________________________________________________________________

> *Ejemplo de respuesta esperada:* "`localhost` significa 'mi propio ordenador'. Es una dirección que apunta al servidor que tengo instalado en mi equipo (Apache). No está en internet, solo yo la veo desde mi navegador."

---

## 3️⃣ Incidencia documentada (algo que te salió mal y cómo lo arreglaste)

| Qué pasó (síntoma) | Qué comprobaste | Qué hiciste para arreglarlo | ¿Se resolvió? |
|--------------------|-----------------|----------------------------|---------------|
| ___________________ | _______________ | __________________________ | ☐ Sí / ☐ No |
| ___________________ | _______________ | __________________________ | ☐ Sí / ☐ No |

> **Si no te salió nada mal:** escribe **"No me ha salido ninguna incidencia"** en la primera fila.

**Banco de incidencias frecuentes (para inspirarte si no se te ocurre):**
- Apache no arrancaba → puerto 80 ocupado → cambié a 8080 en `httpd.conf`
- "Error al establecer conexión con la base de datos" → usuario `root`, contraseña vacía, servidor `localhost`
- `localhost/miwordpress` daba 404 → la carpeta estaba fuera de `htdocs` o mal escrita
- La web me pedía instalar de nuevo → se había instalado antes con otro prefijo de tabla
- La web se veía sin colores → faltaban archivos (paso 8 mal: carpeta `wordpress` intermedia)

---

## 4️⃣ Datos de tu instalación (copia de tu ficha — punto 6)

| Dato | Valor |
|------|-------|
| **Dirección de mi web** | `http://localhost/miwordpress/` |
| **Dirección de mi panel (wp-admin)** | `http://localhost/miwordpress/wp-admin/` |
| **Mi usuario de WordPress** | ______________________________ |
| **Mi contraseña de WordPress** | ______________________________ |
| **Nombre de la base de datos** | `wordpress_db` |
| **Versión XAMPP** | ______________________________ |
| **Versión PHP** (en `http://localhost/dashboard/`) | ______________________________ |
| **Versión MySQL** (en `http://localhost/dashboard/`) | ______________________________ |

---

## 5️⃣ Checklist final de entrega (el profesor marca)

| ✅ | Qué se entrega | Profesor |
|----|----------------|----------|
| ☐ | 5 capturas de pantalla (PNG, nombres correctos) | |
| ☐ | Frase `localhost` explicada con palabras propias | |
| ☐ | Incidencia documentada (o "ninguna") | |
| ☐ | Datos de instalación completados | |
| ☐ | Archivo único (Word / PDF / carpeta comprimida) | |

---

## 6️⃣ Rúbrica de evaluación (el profesor rellena)

| Criterio | Peso | 0-4 Insuficiente | 5-7 Adecuado | 8-10 Excelente | Nota |
|----------|------|------------------|--------------|----------------|------|
| **Instalación y arranque XAMPP** (Apache/MySQL verdes, localhost responde) | 25 % | | | | ___/10 |
| **Despliegue y base de datos** (estructura correcta, `wordpress_db` creada) | 25 % | | | | ___/10 |
| **Configuración y acceso WordPress** (login, publicación, entrada prueba) | 25 % | | | | ___/10 |
| **Documentación y diagnóstico** (capturas, frase localhost, incidencia razonada) | 25 % | | | | ___/10 |
| **TOTAL** | 100 % | | | | **___/10** |

**Observaciones del profesor:**

________________________________________________________________________________
________________________________________________________________________________

**Firma alumno:** _______________________  **Firma profesor:** _______________________  **Fecha:** ___________

---

## 📎 Cómo se hace una captura de pantalla (recordatorio)

| Sistema | Teclas | Qué pasa |
|---------|--------|----------|
| **Windows** | `⊞ Windows` + `Shift` + `S` | Pantalla se oscurece → arrastras → sueltas → **copiada al portapapeles** → pega en Word (`Ctrl+V`) |
| **Mac** | `Cmd` + `Shift` + `4` | Cursor en cruz → arrastras → sueltas → **archivo en Escritorio** → arrastra a Word |

---

## 📂 Nombre del archivo final

**Entrega un solo archivo** (Word `.docx`, PDF `.pdf`, o carpeta comprimida `.zip`) con nombre:

> **`IFCT0510_practica_xampp_APELLIDOS_NOMBRE.docx`**  
> (ej: `IFCT0510_practica_xampp_GARCIA_ANA.docx`)

---

*Plantilla v1.0 — octubre 2026 — Certificado IFCT0510*