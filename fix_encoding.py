import os

def fix_encoding(filepath):
    """Fix UTF-8 bytes misinterpreted as Latin-1"""
    with open(filepath, 'rb') as f:
        content = f.read()
    
    # Try to decode as latin-1, then encode as utf-8
    try:
        # If it's already valid utf-8, this will work
        text = content.decode('utf-8')
        # Check if there are mojibake patterns
        if 'Ã¡' in text or 'Ã±' in text or 'Ã³' in text or 'Ã©' in text or 'Ã­' in text or 'Ãº' in text or 'Ã¼' in text or 'Ã‘' in text or 'Â¿' in text or 'Â»' in text or 'â€' in text:
            # Re-decode as latin-1 and re-encode
            text = content.decode('latin-1')
            print(f"  Fixed encoding for {filepath}")
        else:
            print(f"  Already UTF-8: {filepath}")
            return
    except UnicodeDecodeError:
        # Force latin-1
        text = content.decode('latin-1', errors='replace')
        print(f"  Force-decoded as latin-1: {filepath}")
    
    # Write back as UTF-8
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(text)

# Process all HTML files
root = r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110'
for dirpath, dirnames, filenames in os.walk(root):
    for fname in filenames:
        if fname.endswith('.html'):
            fix_encoding(os.path.join(dirpath, fname))

print("Done!")