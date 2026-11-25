import os
import re

def fix_encoding(filepath):
    with open(filepath, 'rb') as f:
        content = f.read()
    
    # Remove BOM
    if content.startswith(b'\xef\xbb\xbf'):
        content = content[3:]
        print(f"  Removed BOM from {filepath}")
    
    # Decode as latin-1
    text = content.decode('latin-1')
    
    # Round 1: decode
    try:
        test_bytes = text.encode('latin-1')
        text = test_bytes.decode('utf-8')
        print(f"  Round 1: decoded for {filepath}")
    except Exception as e:
        print(f"  Round 1 error: {e}")
    
    # Protect non-latin-1 chars for subsequent rounds
    special_chars = {}
    def protect_special(m):
        char = m.group()
        placeholder = f"__SPECIAL_{len(special_chars)}__"
        special_chars[placeholder] = char
        return placeholder
    
    text = re.sub(r'[^\x00-\xff]', protect_special, text)
    
    # Round 2+: continue decoding
    for round_num in range(2, 6):
        try:
            test_bytes = text.encode('latin-1')
            decoded = test_bytes.decode('utf-8')
            if decoded != text:
                text = decoded
                print(f"  Round {round_num}: decoded for {filepath}")
            else:
                break
        except Exception as e:
            print(f"  Round {round_num} error: {e}")
            break
    
    # Restore special chars
    for placeholder, char in special_chars.items():
        text = text.replace(placeholder, char)
    
    # Write back as UTF-8 with BOM
    with open(filepath, 'w', encoding='utf-8-sig') as f:
        f.write(text)
    
    print(f"  Fixed: {filepath}")

# Process main files
main_files = [
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\index.html',
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\practica-xampp\index.html',
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\practica-gutenberg\index.html',
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\sesion-0\index.html',
]

for f in main_files:
    fix_encoding(f)

print("Done!")