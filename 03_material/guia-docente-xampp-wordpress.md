# Ficha de prácticas · Instalación de XAMPP y WordPress en local

> **Certificado / Módulo:** IFCT0510 · *Gestión de sistemas informáticos*
> **Unidad:** ⟨UD / RA⟩ · **Sesión:** ⟨nº⟩

> 🛈 **Nota de verificación (leer antes de imprimir)**
> El catálogo estatal asigna al código **IFCT0510** la denominación *«Gestión de sistemas informáticos»* con **nivel de cualificación 3** (500-510 h): Junta de Andalucía, Xunta de Galicia y Gobierno de Navarra coinciden. El nivel 1 de la misma familia es **IFCT0108** *«Operaciones auxiliares de montaje y mantenimiento de sistemas microinformáticos»*.
> Si el grupo es realmente de nivel 1, conviene **confirmar con el centro** el código correcto antes de imprimir esta cabecera. El contenido de la práctica no cambia; el documento para el alumnado (`ficha-practica-xampp-wordpress.md`) ya no menciona ningún nivel.
> **Duración estimada:** 120 min (2 sesiones de 60 min)
> **Dificultad:** Inicial · **Modalidad:** Individual en puesto propio
> **Resultado esperado:** un sitio WordPress funcional en `http://localhost/miwordpress/` con acceso al panel de administración.

---

## 1. Objetivos

**Objetivo general**

Instalar y poner en marcha un entorno de servidor web local (Apache + MySQL) y desplegar sobre él una instalación de WordPress accesible desde el navegador, dejando constancia de la configuración realizada.

**Objetivos específicos (medibles)**

Al finalizar la práctica, el alumnado será capaz de:

1. **Instalar** XAMPP seleccionando únicamente los componentes necesarios (Apache, MySQL, phpMyAdmin).
2. **Arrancar y verificar** los servicios Apache y MySQL desde el panel de control, identificando los puertos en uso (80/8080 y 3306).
3. **Desplegar** el código de WordPress en el directorio público del servidor (`htdocs`) con una estructura de carpetas correcta.
4. **Crear** una base de datos vacía en phpMyAdmin y **vincularla** a WordPress mediante el asistente de configuración.
5. **Completar** la instalación creando la cuenta de administrador y **acceder** al escritorio (`wp-admin`).
6. **Diagnosticar** al menos tres incidencias típicas (puerto ocupado, error de conexión a BD, ruta de despliegue incorrecta) aplicando la solución adecuada.

**Competencia transversal:** uso de documentación técnica en inglés/español y verificación por evidencias (capturas + comprobaciones).

---

## 2. Requisitos previos

| Elemento | Detalle |
|---|---|
| Equipo | Windows 10/11 o macOS; **permisos de administrador** (UAC) |
| Disco libre | ≥ 2 GB |
| Red | Acceso a internet para las descargas (≈ 150 MB XAMPP + 25 MB WordPress) |
| Navegador | Chrome, Edge o Firefox actualizados |
| Conocimientos | Manejo de explorador de archivos, descompresión de ZIP, navegación web |

> ⚠️ **Aviso previo:** comprueba que no haya otro servidor web en marcha (IIS, Skype, Teams, otros XAMPP/WAMP). Ocupan el puerto 80 y Apache no arrancará.

---

## 3. Desarrollo de la práctica

La práctica se organiza en **4 hitos**. Cada hito debe quedar **verificado** antes de pasar al siguiente: si la verificación falla, no continúes.

### Hito 1 · Instalar XAMPP (30 min)

1. Descarga XAMPP desde el sitio oficial: <https://www.apachefriends.org/es/index.html>.
2. Ejecuta el instalador (`xampp-windows-x.x.x-installer.exe` o `xampp-osx-x.x.x-installer.dmg`).
3. En Windows acepta el aviso de UAC → **Sí**.
4. **Componentes:** deja marcados solo **Apache**, **MySQL** y **phpMyAdmin**; desmarca el resto (FileZilla, Mercury, Tomcat…).
5. **Carpeta de instalación:** `C:\xampp` (Windows) o `/Applications/XAMPP` (macOS). Evita rutas con espacios, acentos o dentro de OneDrive.
6. **Idioma:** English o Español.
7. Finaliza marcando **Run XAMPP Control Panel** → *Finish*.

**Verificación del hito**

- [ ] El Panel de control de XAMPP abre sin errores.
- [ ] Existe la carpeta `htdocs` dentro de la ruta de instalación.

> 💡 **Por qué:** instalar solo lo necesario reduce superficie de fallo, consumo de recursos y ruido en el panel de control.

---

### Hito 2 · Arrancar Apache y MySQL (15 min)

1. Abre el Panel de control de XAMPP.
2. Pulsa **Start** en **Apache**.
3. Pulsa **Start** en **MySQL**.
4. Observa los puertos asignados: Apache **80** (o 8080), MySQL **3306**.
5. Comprueba en el navegador: `http://localhost/` → debe mostrar la página de bienvenida de XAMPP.

**Verificación del hito**

- [ ] Apache muestra **Stop** en verde y un puerto activo.
- [ ] MySQL muestra **Stop** en verde y el puerto 3306.
- [ ] `http://localhost/` responde (no da error de conexión).

| Síntoma | Causa probable | Solución |
|---|---|---|
| Apache no arranca | Puerto 80 ocupado (IIS, Skype, Teams) | *Config → Apache (httpd.conf)*: `Listen 80` → `Listen 8080`; `ServerName localhost:8080`. Reinicia Apache y usa `http://localhost:8080/` |
| MySQL no arranca | Puerto 3306 ocupado o servicio previo | *Config → my.ini*: `port=3307`; actualiza también la conexión en WordPress |
| El panel pide permisos | UAC | Ejecuta XAMPP como administrador |

---

### Hito 3 · Desplegar WordPress y crear la base de datos (35 min)

**3.1 Descargar y desplegar**

1. Descarga WordPress: <https://wordpress.org/download/> (archivo `.zip`).
2. Entra en `C:\xampp\htdocs` (o `/Applications/XAMPP/htdocs`).
3. Crea la carpeta del proyecto: **`miwordpress`** (sin espacios ni acentos).
4. Descomprime el ZIP **dentro** de `miwordpress`.

> ⚠️ **Error muy frecuente:** al descomprimir se genera `htdocs\miwordpress\wordpress\...`.
> La estructura correcta es `htdocs\miwordpress\wp-admin\`, `htdocs\miwordpress\wp-includes\`, `htdocs\miwordpress\index.php`.
> Si aparece la carpeta intermedia `wordpress`, **mueve su contenido** un nivel arriba.

**3.2 Crear la base de datos**

5. Abre `http://localhost/phpmyadmin/` (o `http://localhost:8080/phpmyadmin/`).
6. Pestaña **Bases de datos**.
7. Nombre: **`wordpress_db`** · Cotejamiento: `utf8mb4_general_ci` → **Crear**.
8. **No crees tablas**: WordPress las genera en el siguiente paso.

**Verificación del hito**

- [ ] `htdocs\miwordpress\index.php` existe.
- [ ] phpMyAdmin lista la base de datos `wordpress_db` (0 tablas).
- [ ] `http://localhost/miwordpress/` ya muestra el asistente de WordPress (o el selector de idioma).

---

### Hito 4 · Configurar WordPress y acceder al panel (40 min)

1. Abre `http://localhost/miwordpress/`.
2. Selecciona el idioma → **Continuar**.
3. Pulsa **¡Vamos allá!** e introduce los datos de conexión:

   | Campo | Valor |
   |---|---|
   | Nombre de la base de datos | `wordpress_db` |
   | Nombre de usuario | `root` |
   | Contraseña | *(vacía)* |
   | Servidor de la base de datos | `localhost` |
   | Prefijo de tabla | `wp_` |

4. **Enviar** → **Ejecutar la instalación**.
5. Rellena la cuenta de administrador:

   | Campo | Valor orientativo |
   |---|---|
   | Título del sitio | `Práctica XAMPP – ⟨tu nombre⟩` |
   | Nombre de usuario | `admin_⟨iniciales⟩` (evita `admin` a secas) |
   | Contraseña | Segura, ≥ 12 caracteres, anotada en tu cuaderno |
   | Correo electrónico | Email real o de aula |

6. **Instalar WordPress** → **Acceder** → inicia sesión.

**Verificación del hito**

- [ ] El sitio carga en `http://localhost/miwordpress/` sin errores PHP.
- [ ] El escritorio abre en `http://localhost/miwordpress/wp-admin/`.
- [ ] En **Ajustes → Generales** aparecen el título y el email introducidos.
- [ ] En **Entradas** puedes crear una de prueba y verla publicada.

> 🔐 **Nota de seguridad (entorno local):** `root` sin contraseña es aceptable **solo** en un equipo de prácticas aislado. Nunca en producción. Como ampliación, crea un usuario específico en phpMyAdmin con permisos únicamente sobre `wordpress_db`.

---

## 4. Checklist de verificación final

Marca cada casilla y adjunta la **evidencia** indicada. La práctica se considera superada con **todas** las casillas marcadas.

| # | Criterio | Cómo verificarlo | Evidencia |
|---|---|---|---|
| 1 | XAMPP instalado con componentes mínimos | Panel de control operativo | Captura del panel |
| 2 | Apache en ejecución en el puerto indicado | Botón en *Stop* + `http://localhost/` | Captura |
| 3 | MySQL en ejecución (3306/3307) | Botón en *Stop* + acceso a phpMyAdmin | Captura |
| 4 | Estructura de despliegue correcta | `htdocs\miwordpress\index.php` y `wp-admin\` visibles | Captura del explorador |
| 5 | Base de datos `wordpress_db` creada y vacía | phpMyAdmin → lista de BD | Captura |
| 6 | `wp-config.php` generado con los datos correctos | Abrir el archivo y localizar `DB_NAME`, `DB_USER`, `DB_HOST` | Captura del fragmento |
| 7 | Asistente de instalación completado | Pantalla de éxito / login | Captura |
| 8 | Acceso al escritorio de administración | `http://localhost/miwordpress/wp-admin/` | Captura |
| 9 | Sitio público visible | `http://localhost/miwordpress/` | Captura |
| 10 | Usuario administrador propio creado | **Usuarios → Todos** | Captura |
| 11 | Entrada publicada de prueba | **Entradas → Todas** | Captura |
| 12 | Incidencias documentadas | Tabla de la sección 6 completada | Documento |

---

## 5. Entregables

1. **Documento de evidencias** (PDF o Markdown) con las capturas de las casillas 1–11.
2. **Tabla de incidencias** (sección 6): al menos **una** incidencia real o simulada y su resolución.
3. **Ficha técnica del entorno:** versión de XAMPP, versión de PHP y MySQL (visibles en `http://localhost/dashboard/`), y ruta final del proyecto.

**Nomenclatura del archivo:** `IFCT0510_practica_xampp_⟨apellidos⟩.pdf`

---

## 6. Diagnóstico de incidencias (a completar por el alumnado)

| Síntoma observado | Comprobación realizada | Causa | Solución aplicada | ¿Resuelto? |
|---|---|---|---|---|
| | | | | |
| | | | | |
| | | | | |

**Banco de incidencias sugeridas para el aula**

- Apache no arranca → puerto 80 ocupado → cambiar a 8080.
- Página en blanco o *«Error al establecer conexión con la base de datos»* → credenciales incorrectas (`root` / contraseña vacía).
- `localhost/miwordpress` devuelve 404 → carpeta fuera de `htdocs` o ruta mal escrita.
- Se abre la página de WordPress pero pide instalar de nuevo → prefijo de tabla distinto al de la instalación previa.
- Error 500 tras editar `wp-config.php` → comilla o punto y coma faltante en PHP.

---

## 7. Rúbrica de evaluación

| Criterio | Peso | Insuficiente (0–4) | Adecuado (5–7) | Excelente (8–10) |
|---|---|---|---|---|
| Instalación y arranque de servicios | 25 % | No arranca o no verifica | Arranca y verifica | Además explica puertos y resuelve conflicto |
| Despliegue y base de datos | 25 % | Estructura o BD incorrectas | Correctas y verificadas | Ajusta cotejamiento y permisos |
| Configuración y acceso a WordPress | 25 % | No llega al panel | Accede y publica | Personaliza título, usuario y entrada |
| Documentación y diagnóstico | 25 % | Sin evidencias | Evidencias completas | Diagnóstico razonado de ≥ 3 incidencias |

---

## 8. Ampliación (alumnado que termina antes)

1. Instalar un **tema** y un **plugin** desde el repositorio oficial.
2. Crear una **página** y asignarla como página de inicio (**Ajustes → Lectura**).
3. Cambiar la **estructura de enlaces permanentes** a `/%postname%/` y comprobar que no da 404.
4. Crear un **usuario con rol Editor** y verificar sus permisos frente al administrador.
5. Exportar la base de datos desde phpMyAdmin (`.sql`) y **restaurarla** en una segunda base (`wordpress_db2`).
6. Investigar qué es `wp-config.php` y qué riesgos tiene publicar el sitio con `WP_DEBUG` activo.

---

## Anexo · Rutas y URL de referencia

```text
Windows   C:\xampp\                     htdocs: C:\xampp\htdocs\miwordpress\
macOS     /Applications/XAMPP/          htdocs: /Applications/XAMPP/htdocs/miwordpress/

Sitio        http://localhost/miwordpress/
Panel        http://localhost/miwordpress/wp-admin/
phpMyAdmin   http://localhost/phpmyadmin/
Dashboard    http://localhost/dashboard/          (versiones de PHP y MySQL)
Documentación oficial  https://wordpress.org/support/
```

*Ficha elaborada a partir de «INSTALACION DE XAMPP Y WORDPRES EN LOCAL», completada con verificación por hitos, criterios de aceptación y diagnóstico de incidencias.*
