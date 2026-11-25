import os

def fix_encoding_bytes(filepath):
    with open(filepath, 'rb') as f:
        content = f.read()
    
    # Remove BOM
    if content.startswith(b'\xef\xbb\xbf'):
        content = content[3:]
        print(f"  Removed BOM from {filepath}")
    
    # Direct byte-level fix: repeatedly decode as latin-1, encode as utf-8
    # until stable
    current = content
    for round_num in range(10):
        try:
            # Decode current bytes as latin-1
            text = current.decode('latin-1')
            # Encode as utf-8
            next_bytes = text.encode('utf-8')
            if next_bytes == current:
                print(f"  Stable after round {round_num+1} for {filepath}")
                break
            current = next_bytes
            print(f"  Round {round_num+1}: changed for {filepath}")
        except Exception as e:
            print(f"  Round {round_num+1} error: {e}")
            break
    
    # Write back with BOM
    with open(filepath, 'wb') as f:
        f.write(b'\xef\xbb\xbf' + current)
    
    print(f"  Fixed: {filepath}")

# Process main files
main_files = [
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\index.html',
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\practica-xampp\index.html',
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\practica-gutenberg\index.html',
    r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110\sesion-0\index.html',
]

for f in main_files:
    fix_encoding_bytes(f)

print("Done!")