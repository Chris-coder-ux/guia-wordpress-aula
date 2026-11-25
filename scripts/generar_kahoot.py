# -*- coding: utf-8 -*-
"""Genera un cuestionario Kahoot a partir del material IFCD0110.

Produce dos archivos:
  1. kahoot_import.xlsx -> plantilla oficial de Kahoot para importar
                         (Crear -> Importar hoja de cálculo -> Importar hoja de cálculo)
  2. kahoot_quiz.pdf    -> versión imprimible (A4) con preguntas, respuestas y soluciones

El contenido de las preguntas se extrae del material didáctico del repo:
  - material/sesion-0-primeros-pasos.md
  - material/ficha-practica-xampp-wordpress.md
  - material/guia-docente-gutenberg.md

NOTA: Kahoot solo acepta su plantilla oficial de hoja de cálculo (.xlsx).
El PDF es solo para imprimir/consultar respuestas.

Límites de la plantilla oficial de Kahoot:
  - Pregunta: máximo 120 caracteres
  - Respuesta: máximo 75 caracteres
  - Time limit: solo 5, 10, 20, 30, 60 o 120 segundos
  - Correct answer(s): número(s) de respuesta separados por comas (ej: "1" o "1,3")
"""

import os
from fpdf import FPDF
from openpyxl import Workbook

# ---------------------------------------------------------------------------
# Preguntas del cuestionario
# (tema, pregunta, [4 respuestas], índice correcto 1-4, segundos)
# Los textos ya están acotados a los límites de Kahoot (preg ≤120, resp ≤75).
# ---------------------------------------------------------------------------
PREGUNTAS = [
    # ---------------- Sesión 0 - Primeros pasos ----------------
    ("Sesion 0 - Primeros pasos",
     "¿Qué símbolo tiene el botón de encendido del ordenador?",
     ["Circulo con línea", "Un enchufe", "Una bombilla", "Una batería"], 1, 20),
    ("Sesion 0 - Primeros pasos",
     "¿Cómo se abre un programa o carpeta con el ratón?",
     ["Clic simple", "Doble clic (dos toques rápidos)", "Clic derecho", "Arrastrar"], 2, 20),
    ("Sesion 0 - Primeros pasos",
     "¿Qué tecla se usa para confirmar o aceptar?",
     ["Esc", "Retroceso (Borrar)", "Enter (Intro)", "Barra espaciadora"], 3, 20),
    ("Sesion 0 - Primeros pasos",
     "¿Cómo se hace una captura de pantalla en Windows?",
     ["Tecla Windows + Shift + S", "Ctrl + C", "Tecla Windows + Shift + 4", "Alt + F4"], 1, 20),
    ("Sesion 0 - Primeros pasos",
     "¿Qué hace la combinación Ctrl + X?",
     ["Copiar", "Cortar (mover)", "Pegar", "Deshacer"], 2, 20),
    ("Sesion 0 - Primeros pasos",
     "¿Dónde van los archivos que descargas por defecto?",
     ["Escritorio", "Documentos", "Descargas", "Papelera"], 3, 20),
    ("Sesion 0 - Primeros pasos",
     "¿Qué teclas se usan para pegar lo copiado?",
     ["Ctrl + C", "Ctrl + X", "Ctrl + V", "Ctrl + Z"], 3, 20),
    ("Sesion 0 - Primeros pasos",
     "Si un programa se queda colgado, ¿qué haces primero?",
     ["Desenchufar el ordenador", "Esperar 10 segundos",
      "Pulsar el botón de encendido", "Pulsar muchas veces rápido"], 2, 20),

    # ---------------- XAMPP + WordPress ----------------
    ("XAMPP + WordPress",
     "¿Cuáles son los 3 componentes que dejar marcados al instalar XAMPP?",
     ["Apache, MySQL y phpMyAdmin", "Apache, FileZilla y Tomcat",
      "MySQL, Mercury y FileZilla", "Todos los componentes"], 1, 30),
    ("XAMPP + WordPress",
     "¿Qué color indica que Apache y MySQL funcionan en XAMPP?",
     ["Rojo", "Ámbar", "Verde", "Gris"], 3, 20),
    ("XAMPP + WordPress",
     "¿Qué dirección escribes para ver la bienvenida de XAMPP?",
     ["http://localhost/miwordpress/", "http://localhost/phpmyadmin/",
      "http://localhost/", "http://wordpress.local/"], 3, 20),
    ("XAMPP + WordPress",
     "¿Qué significa la palabra localhost?",
     ["Mi propio ordenador", "El servidor de la empresa", "Google", "La nube"], 1, 20),
    ("XAMPP + WordPress",
     "¿En qué carpeta se descomprime WordPress para que funcione?",
     ["C:\\xampp\\htdocs", "C:\\xampp\\htdocs\\miwordpress", "C:\\Documentos",
      "C:\\Descargas"], 2, 30),
    ("XAMPP + WordPress",
     "¿Qué usuario se usa para la base de datos de WordPress en XAMPP?",
     ["admin", "wordpress", "root", "usuario"], 3, 20),
    ("XAMPP + WordPress",
     "¿Qué contraseña se usa para la BD de WordPress en XAMPP?",
     ["1234", "admin", "Vacía (no se escribe nada)", "password"], 3, 20),
    ("XAMPP + WordPress",
     "¿Qué nombre debe tener la BD creada en phpMyAdmin?",
     ["wp_db", "wordpress_db", "miweb", "xampp_db"], 2, 20),
    ("XAMPP + WordPress",
     "¿Qué dirección abres para entrar al panel de WordPress?",
     ["http://localhost/miwordpress/", "http://localhost/miwordpress/wp-admin/",
      "http://localhost/phpmyadmin/", "http://localhost/"], 2, 20),
    ("XAMPP + WordPress",
     "Error 'conexión con la base de datos', ¿qué revisas?",
     ["Usuario root, contraseña vacía y servidor localhost",
      "Que apagues el ordenador", "Que borres la carpeta htdocs",
      "Que reinstales Windows"], 1, 30),

    # ---------------- Gutenberg / WordPress ----------------
    ("Gutenberg - WordPress",
     "¿Qué botón se pulsa para añadir un bloque en Gutenberg?",
     ["+", "-", "=", "*"], 1, 20),
    ("Gutenberg - WordPress",
     "¿Qué son H1, H2, H3 en Gutenberg?",
     ["Tipos de letra", "Encabezados (títulos de distintos tamaños)", "Imágenes",
      "Listas"], 2, 20),
    ("Gutenberg - WordPress",
     "¿En qué menú de WordPress se configura la página de inicio estática?",
     ["Entradas", "Apariencia -> Temas", "Ajustes -> Lectura", "Plugins"], 3, 20),
    ("Gutenberg - WordPress",
     "¿Diferencia entre una Página y una Entrada en WordPress?",
     ["Página = contenido estático, Entrada = blog/artículo",
      "Son lo mismo", "La Página es solo para imágenes",
      "La Entrada es solo para administradores"], 1, 20),
]


def _truncar(texto, max_long):
    """Trunca un texto añadiendo '...' si excede max_long."""
    texto = str(texto)
    if len(texto) <= max_long:
        return texto
    return texto[: max_long - 3] + "..."


def _tiempo_valido(segundos):
    """Devuelve el valor de tiempo límite más cercano permitido por Kahoot."""
    permitidos = [5, 10, 20, 30, 60, 120]
    return min(permitidos, key=lambda t: abs(t - segundos))


def generar_xlsx(ruta):
    """Escribe el Excel con la plantilla oficial de Kahoot."""
    wb = Workbook()
    ws = wb.active
    ws.title = "Sheet1"

    # Encabezados exactos de la plantilla oficial de Kahoot (fila 8 de la plantilla)
    encabezados = [
        "Question - 120 max length",   # A
        "Answer 1 - 75 max length",    # B
        "Answer 2 - 75 max length",    # C
        "Answer 3 - 75 max length",    # D
        "Answer 4 - 75 max length",    # E
        "Time limit",                  # F
        "Correct answer(s)",           # G
    ]
    ws.append(encabezados)

    for tema, pregunta, respuestas, correcta, segundos in PREGUNTAS:
        # Aplicar límites de Kahoot
        preg = _truncar(pregunta, 120)
        resp = [_truncar(r, 75) for r in respuestas]
        # Asegurar al menos 2 respuestas
        while len(resp) < 4:
            resp.append("")
        resp = resp[:4]
        tiempo = _tiempo_valido(segundos)
        correcta_str = str(correcta)

        ws.append([preg, resp[0], resp[1], resp[2], resp[3], tiempo, correcta_str])

    wb.save(ruta)
    print(f"[OK] Excel Kahoot generado: {ruta} ({len(PREGUNTAS)} preguntas)")


class KahootPDF(FPDF):
    def header(self):
        self.set_font("helvetica", "B", 16)
        self.set_text_color(11, 107, 82)
        self.cell(0, 10, "Cuestionario Kahoot - IFCD0110", new_x="LMARGIN", new_y="NEXT", align="C")
        self.set_font("helvetica", "", 9)
        self.set_text_color(71, 89, 90)
        self.cell(0, 6, "Certificado IFCD0110 · Gestión de sistemas informáticos",
                  new_x="LMARGIN", new_y="NEXT", align="C")
        self.cell(0, 6, "Sesion 0 · XAMPP + WordPress · Gutenberg",
                  new_x="LMARGIN", new_y="NEXT", align="C")
        self.ln(4)

    def footer(self):
        self.set_y(-15)
        self.set_font("helvetica", "I", 8)
        self.set_text_color(128, 128, 128)
        self.cell(0, 10, "Página %d - Material docente IFCD0110 (uso interno, imprimible A4)" % self.page_no(),
                  new_x="LMARGIN", new_y="NEXT", align="C")

    def _wrap(self, texto, ancho_mm):
        palabras = str(texto).split()
        lineas = []
        actual = ""
        for palabra in palabras:
            prueba = (actual + " " + palabra).strip()
            if self.get_string_width(prueba) <= ancho_mm:
                actual = prueba
            else:
                if actual:
                    lineas.append(actual)
                actual = palabra
        if actual:
            lineas.append(actual)
        return lineas

    def _texto(self, texto, line_h, ancho_mm, bold=False, size=None, color=None):
        if size is not None:
            self.set_font("helvetica", "B" if bold else "", size)
        elif bold:
            self.set_font("helvetica", "B")
        else:
            self.set_font("helvetica", "")
        if color is not None:
            self.set_text_color(*color)
        for linea in self._wrap(texto, ancho_mm):
            self.cell(ancho_mm, line_h, linea, new_x="LMARGIN", new_y="NEXT")

    def tema(self, nombre):
        self.set_fill_color(229, 241, 236)
        self.set_text_color(11, 107, 82)
        self.set_font("helvetica", "B", 12)
        ancho = self.w - self.l_margin - self.r_margin
        self.cell(ancho, 9, "  Tema: " + nombre, new_x="LMARGIN", new_y="NEXT", fill=True)
        self.ln(2)

    def pregunta(self, num, tema, pregunta, respuestas, correcta, segundos):
        ancho = self.w - self.l_margin - self.r_margin
        self._texto("Pregunta %d  ·  %s  ·  Tiempo: %ds" % (num, tema, segundos), 5, ancho - 6,
                    color=(110, 110, 110))
        self.ln(1)
        self._texto("%d. %s" % (num, pregunta), 7, ancho, bold=True, size=11.5, color=(15, 31, 30))
        self.ln(1)
        letras = ["A", "B", "C", "D"]
        for i, (letra, resp) in enumerate(zip(letras, respuestas)):
            es_correcta = (i + 1) == correcta
            self.set_x(self.l_margin + 6)
            self._texto("   %s) %s" % (letra, resp), 6.5, ancho - 6,
                        bold=es_correcta, size=10.5,
                        color=(11, 107, 82) if es_correcta else (50, 50, 50))
        self._texto(">> Respuesta correcta: %s" % letras[correcta - 1], 6, ancho,
                    bold=True, size=9, color=(11, 107, 82))
        self.ln(5)


def generar_pdf(ruta):
    pdf = KahootPDF(orientation="P", unit="mm", format="A4")
    pdf.set_auto_page_break(auto=True, margin=15)
    pdf.set_margins(15, 15, 15)
    pdf.add_page()

    ancho = pdf.w - pdf.l_margin - pdf.r_margin
    pdf.set_font("helvetica", "B", 12)
    pdf.set_text_color(11, 107, 82)
    pdf.cell(ancho, 8, "Cómo importar este cuestionario en Kahoot", new_x="LMARGIN", new_y="NEXT")
    pdf.set_font("helvetica", "", 9.5)
    pdf.set_text_color(50, 50, 50)
    instrucciones = [
        "1. Abre Kahoot (crear.kahoot.it) y pulsa Crear -> Importar hoja de cálculo.",
        "2. Usa el archivo kahoot_import.xlsx generado junto a este PDF.",
        "3. Sube el archivo y revisa que preguntas y respuestas correctas coincidan.",
        "4. Cada pregunta incluye el tiempo límite y la respuesta correcta indicada.",
        "",
        "Este PDF es la versión de consulta e impresión. El archivo fuente para Kahoot es kahoot_import.xlsx.",
    ]
    for linea in instrucciones:
        pdf._texto(linea, 5.5, ancho)
    pdf.ln(3)

    temas_vistos = []
    for (tema, _, _, _, _) in PREGUNTAS:
        if tema not in temas_vistos:
            temas_vistos.append(tema)

    num = 0
    for tema in temas_vistos:
        pdf.tema(tema)
        for (t, pregunta, respuestas, correcta, segundos) in PREGUNTAS:
            if t == tema:
                num += 1
                pdf.pregunta(num, t, pregunta, respuestas, correcta, segundos)

    pdf.output(ruta)
    print(f"[OK] PDF generado: {ruta} ({num} preguntas)")


if __name__ == "__main__":
    base = os.path.dirname(os.path.abspath(__file__))
    xlsx_path = os.path.join(base, "..", "kahoot_import.xlsx")
    pdf_path = os.path.join(base, "..", "kahoot_quiz.pdf")
    generar_xlsx(xlsx_path)
    generar_pdf(pdf_path)
    print("\nListo. Archivos creados:")
    print("  - kahoot_import.xlsx  (importar en Kahoot: Crear -> Importar hoja de cálculo)")
    print("  - kahoot_quiz.pdf     (imprimir / consultar respuestas)")
