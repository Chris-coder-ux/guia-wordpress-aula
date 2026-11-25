import os

def fix_encoding(filepath):
    with open(filepath, 'rb') as f:
        content = f.read()
    
    # Remove BOM
    if content.startswith(b'\xef\xbb\xbf'):
        content = content[3:]
        print(f"  Removed BOM from {filepath}")
    
    # Decode as latin-1
    text = content.decode('latin-1')
    
    # First, protect non-latin-1 chars by replacing them with placeholders
    import re
    special_chars = {}
    def protect_special(m):
        char = m.group()
        placeholder = f"__SPECIAL_{len(special_chars)}__"
        special_chars[placeholder] = char
        return placeholder
    
    # Find all non-latin-1 chars
    text = re.sub(r'[^\x00-\xff]', protect_special, text)
    
    # Now do the encoding rounds
    for round_num in range(5):
        try:
            test_bytes = text.encode('latin-1')
            decoded = test_bytes.decode('utf-8')
            if decoded != text:
                text = decoded
                print(f"  Round {round_num+1}: decoded for {filepath}")
            else:
                break
        except Exception as e:
            print(f"  Round {round_num+1} error: {e}")
            break
    
    # Restore special chars
    for placeholder, char in special_chars.items():
        text = text.replace(placeholder, char)
    
    # Write back as UTF-8 with BOM
    with open(filepath, 'w', encoding='utf-8-sig') as f:
        f.write(text)
    
    print(f"  Fixed: {filepath}")

# Process only the main files (not backups)
main_files = [
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\index.html',
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\practica-xampp\index.html',
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\practica-gutenberg\index.html',
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\sesion-0\index.html',
]

for f in main_files:
    fix_encoding(f)

print("Done!")