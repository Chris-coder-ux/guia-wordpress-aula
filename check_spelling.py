import re
import os

def check_spelling(content, filename):
    common_errors = [
        # acentos comunes faltantes
        ('mas ', 'más '),
        ('tambien ', 'también '),
        ('pagina ', 'página '),
        ('instalacion ', 'instalación '),
        ('configuracion ', 'configuración '),
        ('aplicacion ', 'aplicación '),
        ('opcion ', 'opción '),
        ('seccion ', 'sección '),
        ('leccion ', 'lección '),
        ('practica ', 'práctica '),
        ('teoria ', 'teoría '),
        ('basico ', 'básico '),
        ('facil ', 'fácil '),
        ('dificil ', 'difícil '),
        ('rapido ', 'rápido '),
        ('despues ', 'después '),
        ('asi ', 'así '),
        (' si ', ' sí '),
        (' esta ', ' está '),
        (' estas ', ' estás '),
        (' estan ', ' están '),
        ('donde ', 'dónde '),
        ('cuando ', 'cuándo '),
        ('como ', 'cómo '),
        (' que ', ' qué '),
        ('quien ', 'quién '),
        ('cual ', 'cuál '),
        ('cuales ', 'cuáles '),
        ('cuanto ', 'cuánto '),
        ('cuantos ', 'cuántos '),
        ('porque ', 'por qué '),
        ('ademas ', 'además '),
        ('tambien ', 'también '),
        ('segun ', 'según '),
        ('contrasena ', 'contraseña '),
        ('electronico ', 'electrónico '),
        ('electtronico ', 'electrónico '),
        ('buzon ', 'buzón '),
        ('reenvio ', 'reenviar '),
        ('iniciar sesion ', 'iniciar sesión '),
        ('cerrar sesion ', 'cerrar sesión '),
        ('autenticacion ', 'autenticación '),
        ('codigo ', 'código '),
        ('exito ', 'éxito '),
        ('solucion ', 'solución '),
        ('guia ', 'guía '),
        ('leccion ', 'lección '),
        ('modulo ', 'módulo '),
        ('practica ', 'práctica '),
        ('evaluacion ', 'evaluación '),
        ('calificacion ', 'calificación '),
        ('recuperacion ', 'recuperación '),
        ('matricula ', 'matrícula '),
        ('inscripcion ', 'inscripción '),
        ('titulo ', 'título '),
        ('master ', 'máster '),
        ('investigacion ', 'investigación '),
        ('publicacion ', 'publicación '),
        ('articulo ', 'artículo '),
        ('comunicacion ', 'comunicación '),
        ('poster ', 'póster '),
        ('introduccion ', 'introducción '),
        ('metodologia ', 'metodología '),
        ('discusion ', 'discusión '),
        ('bibliografia ', 'bibliografía '),
        ('apendice ', 'apéndice '),
        ('indice ', 'índice '),
        ('terminos ', 'términos '),
        ('imagenes ', 'imágenes '),
        ('menu ', 'menú '),
        ('menus ', 'menús '),
        ('direccion ', 'dirección '),
        ('raton ', 'ratón '),
    ]

    lines = content.split('\n')
    errors = []

    for i, line in enumerate(lines):
        for wrong, right in common_errors:
            pattern = re.escape(wrong.strip()) + r'(?=[\s\.,;:!?)\]]|$)'
            if re.search(pattern, line, re.IGNORECASE):
                errors.append({
                    'file': filename,
                    'line': i + 1,
                    'wrong': wrong.strip(),
                    'right': right.strip(),
                    'context': line.strip()[:120]
                })

    return errors

files = [
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\index.html',
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\sesion-0\index.html',
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\practica-xampp\index.html',
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\practica-gutenberg\index.html'
]

all_errors = []
for f in files:
    with open(f, 'r', encoding='utf-8') as fp:
        content = fp.read()
    errors = check_spelling(content, os.path.basename(f))
    all_errors.extend(errors)

print(f"Total possible issues found: {len(all_errors)}")
for e in all_errors:
    try:
        print(f"{e['file']}:{e['line']} - \"{e['wrong']}\" -> \"{e['right']}\" | {e['context']}")
    except UnicodeEncodeError:
        # Replace problematic chars
        context = e['context'].encode('ascii', 'replace').decode('ascii')
        print(f"{e['file']}:{e['line']} - \"{e['wrong']}\" -> \"{e['right']}\" | {context}")