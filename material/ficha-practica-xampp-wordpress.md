# Ficha de prácticas · Crea tu propia web en el ordenador

**Con XAMPP y WordPress, paso a paso y sin prisa**

> **Certificado:** IFCD0110 · ⟨nombre según tu centro⟩
> **Módulo / Unidad:** ⟨…⟩ · **Sesión:** ⟨…⟩
> **Tiempo:** 3 sesiones de 60 minutos (no hace falta correr)
> **Nivel de la práctica:** desde cero.
> **Qué vas a conseguir:** abrir una web tuya en el navegador y entrar en su panel de control.

> 🖐️ **¿Nunca has usado un ordenador?**
> Haz primero la **Sesión 0 · Primeros pasos** (archivo `sesion-0-primeros-pasos.md`). Allí aprendes a usar el ratón, el teclado y las carpetas. Después vuelve aquí.

---

## 1. ¿Qué vas a hacer? (en 5 líneas)

Vas a montar una **página web** dentro de tu ordenador. No en internet: **dentro de tu ordenador**. Solo la verás tú.

Para eso usarás dos programas:

- **XAMPP**: hace que tu ordenador se comporte como si fuera un servidor de internet.
- **WordPress**: es el programa con el que se escribe la web (el mismo que usan millones de webs reales).

Al terminar, escribirás una dirección en el navegador y verás **tu web funcionando**.

> **Tranquilidad:** aquí no se puede "romper" nada. Si algo sale mal, se borra y se vuelve a empezar.

---

## 2. Cuatro palabras raras (y qué significan)

| Palabra | Qué es, en fácil | Símil |
|---|---|---|
| **Servidor** | Un ordenador que guarda una web y la entrega cuando alguien la pide | El almacén del supermercado |
| **Apache** | El programa que "entrega" las páginas cuando las pides | El repartidor del supermercado |
| **MySQL** | El programa que guarda los textos, usuarios y fotos de la web | La despensa del supermercado |
| **WordPress** | El programa con el que escribes la web sin programar | El mostrador donde colocas los productos |

**XAMPP** es solo una caja que trae los tres juntos (Apache, MySQL y uno más para ver la despensa: **phpMyAdmin**).

**No hace falta memorizar esto.** Vuelve a esta tabla si te pierdes.

---

## 3. Antes de empezar: 5 comprobaciones (5 minutos)

Marca cada casilla cuando la tengas:

- [ ] **Estoy en un ordenador con Windows** (si es Mac, avisa al profesor).
- [ ] **Sé hacer doble clic** con el botón izquierdo del ratón.
- [ ] **Tengo internet** (puedo abrir una página web cualquiera).
- [ ] **Queda espacio en el ordenador** (2 GB libres, como mínimo).
- [ ] **Tengo permisos**: si el ordenador es del centro, pide al profesor que te deje instalar programas.

### Dónde se guarda lo que descargas

Cuando pulsas "Descargar", el archivo **no aparece en el escritorio**. Va a una carpeta llamada **Descargas** (*Downloads*).

Para llegar a ella:

1. Abre **Explorador de archivos** (el icono de una carpeta amarilla en la barra de abajo).
2. En la columna de la izquierda, pulsa **Descargas**.

> **Consejo:** si no encuentras un archivo, casi siempre está en **Descargas**. Búscalo ahí antes de preguntar.

---

## 4. Las partes de la pantalla que vamos a nombrar

| Nombre | Cómo reconocerlo |
|---|---|
| **Escritorio** | La pantalla del fondo, donde están los iconos |
| **Icono** | Un dibujito con un nombre debajo. Se abre con **doble clic** |
| **Ventana** | El recuadro del programa. Se cierra con la **X** de arriba a la derecha |
| **Barra de direcciones** | La franja blanca de arriba del navegador donde se escribe la dirección de una web |
| **Botón** | Un recuadro con texto que se pulsa **una vez** |
| **Captura de pantalla** | Una foto de lo que se ve en la pantalla (lo veremos en el punto 8) |

---

# La práctica, paso a paso

Hay **4 partes**. Cuando termines una, para y revisa: **si la revisión no sale bien, no sigas adelante**.

---

## PARTE A · Instalar XAMPP

### Paso 1. Descargar XAMPP

1. Abre el navegador (Chrome, Edge o Firefox).
2. Haz **un clic** en la barra de direcciones.
3. Escribe exactamente esto y pulsa **Enter**:

   ```text
   https://www.apachefriends.org/es/index.html
   ```

4. Baja un poco con la rueda del ratón hasta ver un botón que dice **XAMPP for Windows**.
5. Pulsa ese botón. La descarga empieza sola.
6. Espera. Abajo en el navegador verás una barra o un aviso de descarga.

> **Cuidado con los anuncios:** en los buscadores, los primeros resultados a veces son publicidad. Escribe la dirección tal cual, no busques "descargar xampp".

**Comprueba:** en la carpeta **Descargas** hay un archivo que empieza por `xampp-windows` y termina en `.exe`.

---

### Paso 2. Abrir el instalador

1. Abre **Descargas** (punto 3).
2. Haz **doble clic** en el archivo `xampp-windows-...exe`.
3. Windows preguntará: *"¿Quieres permitir que esta aplicación haga cambios en el dispositivo?"* → pulsa **Sí**.
4. Si el antivirus avisa → pulsa **Permitir** o **Ejecutar de todos modos**.

> **Si Windows no te deja y dice que hace falta un administrador:** llama al profesor. No intentes saltarte el aviso.

**Comprueba:** aparece una ventana con un dibujo y el botón **Next**.

---

### Paso 3. Instalar (solo hay que pulsar "Next")

Vas a ver varias pantallas. En casi todas solo hay que pulsar **Next** (= *siguiente*).

1. Primera pantalla → **Next**.
2. Pantalla de **componentes** (una lista con casillas y nombres en inglés):
   - Deja marcados **solo** estos tres: **Apache**, **MySQL**, **phpMyAdmin**.
   - Desmarca los demás si están marcados.
   - Pulsa **Next**.
3. Pantalla de **carpeta de instalación**: déjala como viene (`C:\xampp`). Pulsa **Next**.
4. Pantalla de **idioma**: elige **English** o **Español**. Pulsa **Next**.
5. Pulsa **Next** otra vez si aparece. Espera a que la barra llegue al final.
6. Al final, deja marcada la casilla **"Do you want to start the Control Panel now?"** y pulsa **Finish**.

**Comprueba:** se abre una ventana llamada **XAMPP Control Panel**, con una lista de nombres y botones **Start**.

> **Si no se abrió:** abre el menú **Inicio** de Windows, escribe `xampp` y pulsa en **XAMPP Control Panel**.

---

## PARTE B · Encender el servidor

### Paso 4. Arrancar Apache y MySQL

En la ventana del **XAMPP Control Panel**:

1. En la fila **Apache**, pulsa el botón **Start** (*encender*).
2. En la fila **MySQL**, pulsa el botón **Start**.
3. Espera unos segundos.

**Comprueba:** los dos botones ahora dicen **Stop** (*parar*) y el nombre se pone **en verde**. Además aparece un número de **puerto**: Apache **80** y MySQL **3306**.

> **Qué significa "puerto":** es como el número de puerta por donde entra la información. No hay que hacer nada con él, solo saber que tiene que aparecer un número.

### Paso 5. Comprobar que funciona

1. Abre el navegador.
2. Escribe en la barra de direcciones: `http://localhost/` y pulsa **Enter**.

**Comprueba:** sale una página de bienvenida de XAMPP. **Si sale, ¡ya tienes un servidor!**

> **`localhost` significa "mi propio ordenador".** Es una dirección que solo funciona en tu equipo.

**Si no sale nada:**

| Lo que ves | Qué pasa | Qué hacer |
|---|---|---|
| Apache no se pone verde y se apaga | Otra cosa ocupa la "puerta 80" | Llama al profesor: se cambia a la puerta 8080 |
| La página no carga | Apache está apagado | Vuelve al panel y pulsa **Start** |
| MySQL no arranca | La puerta 3306 está ocupada | Llama al profesor |

---

## PARTE C · Descargar WordPress y crear su "despensa"

### Paso 6. Descargar WordPress

1. En el navegador, escribe: `https://wordpress.org/download/` y pulsa **Enter**.
2. Pulsa el botón **Download WordPress**.
3. Espera a que termine la descarga.

**Comprueba:** en **Descargas** hay un archivo llamado `wordpress` que termina en `.zip`.

> **Qué es un `.zip`:** una caja comprimida. Dentro hay muchos archivos. Hay que **descomprimirla** para poder usarlos.

---

### Paso 7. Crear una carpeta para tu web

1. Abre **Explorador de archivos**.
2. Ve a la unidad **C:** → carpeta **xampp** → carpeta **htdocs**.

   La ruta completa es: `C:\xampp\htdocs`

3. Dentro de **htdocs**, haz **clic derecho** en un espacio vacío → **Nuevo** → **Carpeta**.
4. Escribe el nombre: `miwordpress` (todo junto, sin espacios, sin tildes) y pulsa **Enter**.

> **`htdocs` es la carpeta donde el servidor busca las webs.** Todo lo que pongas dentro se podrá ver en el navegador.

**Comprueba:** existe `C:\xampp\htdocs\miwordpress` y está vacía.

---

### Paso 8. Descomprimir WordPress dentro de la carpeta

1. Abre **Descargas**.
2. Haz **clic derecho** sobre el archivo `wordpress.zip` → **Extraer todo…**
3. En la ventana que se abre, pulsa **Examinar** y elige la carpeta `C:\xampp\htdocs\miwordpress`.

   ⚠️ **Importante:** elige la carpeta `miwordpress`, **no** `htdocs`.

4. Pulsa **Extraer**.

**Comprueba — esto es lo más importante de toda la práctica:**

Entra en `C:\xampp\htdocs\miwordpress`. Debes ver **directamente** estas cosas:

```text
📁 wp-admin
📁 wp-content
📁 wp-includes
📄 index.php
📄 wp-config-sample.php
```

> ⚠️ **Error muy frecuente:** si dentro de `miwordpress` solo ves **otra carpeta llamada `wordpress`**, está mal. La solución es:
> 1. Abre esa carpeta `wordpress`.
> 2. Selecciona todo (`Ctrl` + `E`), corta (`Ctrl` + `X`).
> 3. Vuelve a `miwordpress`, pega (`Ctrl` + `V`).
> 4. Borra la carpeta vacía `wordpress`.
>
> Si no te aclaras, llama al profesor **antes** de seguir: si esto está mal, nada funcionará después.

---

### Paso 9. Crear la "despensa" (la base de datos)

1. En el navegador, escribe: `http://localhost/phpmyadmin/` y pulsa **Enter**.
2. Arriba, pulsa la pestaña **Bases de datos**.
3. En la casilla **Nombre de la base de datos**, escribe: `wordpress_db`
4. Pulsa el botón **Crear**.
5. **No toques nada más.** No hay que crear tablas: WordPress las crea solo.

**Comprueba:** en la lista de la izquierda aparece **`wordpress_db`**.

---

## PARTE D · Instalar WordPress y entrar

### Paso 10. Abrir el instalador de WordPress

1. En el navegador, escribe: `http://localhost/miwordpress/` y pulsa **Enter**.
2. Elige **Español** y pulsa **Continuar**.
3. Pulsa el botón **¡Vamos allá!**

**Comprueba:** aparece un formulario que pide datos de la base de datos.

---

### Paso 11. Rellenar los datos de conexión

Copia estos datos **exactamente**:

| Campo del formulario | Qué escribir |
|---|---|
| Nombre de la base de datos | `wordpress_db` |
| Nombre de usuario | `root` |
| Contraseña | **nada, déjala vacía** |
| Servidor de la base de datos | `localhost` |
| Prefijo de tabla | `wp_` (déjalo como está) |

Pulsa **Enviar** y después **Ejecutar la instalación**.

**Comprueba:** sale una pantalla que pide el título del sitio, un usuario y una contraseña.

> **Si sale un error rojo** que habla de "conectar con la base de datos": revisa que escribiste `root`, que la contraseña está vacía y que el servidor es `localhost`. Es el fallo más común.

---

### Paso 12. Crear tu usuario de administrador

Rellena:

| Campo | Qué escribir |
|---|---|
| Título del sitio | El nombre de tu web, por ejemplo: `La web de Ana` |
| Nombre de usuario | Algo tuyo, por ejemplo: `ana` (evita `admin`) |
| Contraseña | Una que recuerdes. **Apúntala en el punto 6 de esta ficha** |
| Correo electrónico | Tu correo, o el que te diga el profesor |

Pulsa **Instalar WordPress** y espera.

**Comprueba:** aparece una pantalla con un botón **Acceder**.

---

### Paso 13. Entrar en tu web

1. Pulsa **Acceder**.
2. Escribe tu usuario y tu contraseña.
3. Pulsa **Entrar**.

**Comprueba:** ves el **escritorio** de WordPress (un panel con menús a la izquierda).

---

### Paso 14. Ver tu web como la vería un visitante

1. Arriba a la izquierda, pasa el ratón por el nombre de tu web.
2. Pulsa **Visitar sitio**.

**Comprueba:** ves tu web publicada. **Ya está: tienes una web funcionando.**

---

## 5. La próxima vez que quieras entrar

El servidor **se apaga** cuando apagas el ordenador. Para volver a entrar:

1. Abre **XAMPP Control Panel**.
2. Pulsa **Start** en **Apache** y **Start** en **MySQL**.
3. Abre el navegador y escribe `http://localhost/miwordpress/wp-admin/`.

> **No apagues el ordenador de golpe mientras Apache y MySQL estén en verde.** Primero pulsa **Stop** en los dos.

---

## 6. Hoja de progreso (rellénala con lápiz o en el ordenador)

| ✔ | Paso | Lo he conseguido |
|---|---|---|
| ☐ | 1. Descargar XAMPP | |
| ☐ | 2. Abrir el instalador | |
| ☐ | 3. Instalar XAMPP | |
| ☐ | 4. Encender Apache y MySQL | |
| ☐ | 5. Ver la página de XAMPP | |
| ☐ | 6. Descargar WordPress | |
| ☐ | 7. Crear la carpeta `miwordpress` | |
| ☐ | 8. Descomprimir **bien** (sin carpeta de más) | |
| ☐ | 9. Crear la base de datos `wordpress_db` | |
| ☐ | 10. Abrir el instalador de WordPress | |
| ☐ | 11. Rellenar los datos de conexión | |
| ☐ | 12. Crear mi usuario | |
| ☐ | 13. Entrar en el escritorio | |
| ☐ | 14. Ver mi web publicada | |

**Mis datos (apúntalos aquí, los vas a necesitar):**

- Dirección de mi web: `http://localhost/miwordpress/`
- Dirección de mi panel: `http://localhost/miwordpress/wp-admin/`
- Mi usuario: ______________________
- Mi contraseña: ______________________
- Nombre de la base de datos: `wordpress_db`

---

## 7. Si algo va mal

| Lo que ves | Qué significa | Qué haces |
|---|---|---|
| Apache se apaga solo | Otra "puerta" está ocupada | Avisa al profesor |
| "Error al establecer una conexión con la base de datos" | Los datos del paso 11 están mal | Usuario `root`, contraseña vacía, servidor `localhost` |
| Al abrir mi web sale "404" o "no encontrado" | La carpeta no está donde debe | Comprueba que está en `C:\xampp\htdocs\miwordpress` |
| Veo la web pero me pide instalarla otra vez | Se instaló antes con otro nombre de tablas | Avisa al profesor |
| La web se ve sin colores ni diseño | Falta algún archivo | Revisa el paso 8 |
| Se me ha olvidado la contraseña | — | Avisa al profesor; se puede cambiar desde la base de datos |

**Regla de oro:** si algo no sale, **para**. No sigas pulsando cosas. Anota lo que ves y avisa. Cuanto menos toques, más fácil es arreglarlo.

---

## 8. Qué tienes que entregar

**Tres cosas**, en un solo documento (Word, o fotos pegadas):

1. **Capturas de pantalla** de:
   - el panel de XAMPP con Apache y MySQL **en verde**;
   - la carpeta `miwordpress` abierta, con los archivos a la vista;
   - `wordpress_db` en phpMyAdmin;
   - tu **web publicada**.
2. **Una frase** explicando qué es `localhost`, con tus palabras.
3. **Una incidencia**: algo que te haya salido mal y cómo lo arreglaste (o "no me ha salido nada mal" si es el caso).

### Cómo se hace una captura de pantalla (Windows)

1. Pulsa a la vez las teclas **Windows** + **Shift** + **S**.
2. La pantalla se oscurece. Arrastra el ratón para rodear lo que quieres fotografiar.
3. La foto ya está copiada. Abre Word y pega con **Ctrl** + **V**.

> En Mac: **Cmd** + **Shift** + **4** y arrastra.

**Nombre del archivo:** `practica_web_tu_nombre.docx`

---

## 9. Si acabas antes

Nada de esto es obligatorio. Son cosas para probar sin miedo:

1. Cambia el **título** de tu web en **Ajustes → Generales**.
2. Escribe una **entrada** nueva y publícala. Mírala en tu web.
3. Elige otro **tema** (los colores y el diseño) en **Apariencia → Temas**.
4. Escribe en el navegador `http://localhost/miwordpress/wp-admin/` desde otro momento del día y comprueba que sigue ahí.

---

## 10. Diccionario de la práctica

| Palabra | Significado en fácil |
|---|---|
| **Descargar** | Traer un archivo de internet a tu ordenador |
| **Instalar** | Meter un programa en el ordenador para poder usarlo |
| **Descomprimir** | Abrir una caja `.zip` para sacar los archivos de dentro |
| **Carpeta** | Un sitio donde se guardan archivos, como un cajón |
| **Ruta** | El "camino" hasta un archivo. Ejemplo: `C:\xampp\htdocs` |
| **Navegador** | El programa para ver internet (Chrome, Edge, Firefox) |
| **Dirección / URL** | Lo que se escribe en la barra de arriba: `http://localhost/` |
| **Servidor** | Ordenador que guarda webs y las entrega |
| **Base de datos** | La "despensa": donde se guardan textos, usuarios y datos |
| **Local** | En tu propio ordenador, sin internet |
| **Administrador** | El usuario con todos los permisos de la web |
| **Captura de pantalla** | Una foto de la pantalla |

---

## Anexo · Chuleta de direcciones

Copia y pega estas direcciones en el navegador:

```text
Panel de XAMPP          http://localhost/
phpMyAdmin              http://localhost/phpmyadmin/
Mi web                  http://localhost/miwordpress/
Mi panel de control     http://localhost/miwordpress/wp-admin/
Carpeta de las webs     C:\xampp\htdocs
```

---

**Ficha elaborada a partir de «INSTALACION DE XAMPP Y WORDPRES EN LOCAL».**
La versión técnica con objetivos, rúbrica y diagnóstico avanzado está en `guia-docente-xampp-wordpress.md`.
