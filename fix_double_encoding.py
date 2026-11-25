import os

def fix_double_encoding(filepath):
    """Fix double-encoded UTF-8 (latin-1 -> utf-8 -> latin-1 -> utf-8)"""
    with open(filepath, 'rb') as f:
        content = f.read()
    
    # Decode as latin-1 first (this gets us the intermediate state)
    text = content.decode('latin-1')
    
    # Check for double-encoding patterns
    if 'ÃÂ' in text or 'ÃÂ' in text:
        # It's double-encoded: decode the text as latin-1 again to get original bytes
        # then decode as utf-8
        try:
            # The text is currently latin-1 decoded utf-8 bytes
            # We need to encode back to latin-1 to get the utf-8 bytes, then decode as utf-8
            original_bytes = text.encode('latin-1')
            text = original_bytes.decode('utf-8')
            print(f"  Fixed DOUBLE encoding for {filepath}")
        except:
            # Fallback: try single decode
            try:
                text = content.decode('utf-8')
                print(f"  Fallback to single UTF-8: {filepath}")
            except:
                text = content.decode('latin-1', errors='replace')
                print(f"  Fallback to latin-1: {filepath}")
    elif 'Ã¡' in text or 'Ã±' in text or 'Ã³' in text or 'Ã©' in text or 'Ã­' in text or 'Ãº' in text or 'Ã¼' in text:
        # Single encoding issue
        try:
            original_bytes = text.encode('latin-1')
            text = original_bytes.decode('utf-8')
            print(f"  Fixed SINGLE encoding for {filepath}")
        except:
            text = content.decode('utf-8', errors='replace')
            print(f"  Fallback UTF-8: {filepath}")
    else:
        # Try to decode as utf-8 directly
        try:
            text = content.decode('utf-8')
            print(f"  Already OK: {filepath}")
            return
        except:
            text = content.decode('latin-1', errors='replace')
            print(f"  Force latin-1: {filepath}")
    
    # Write back as UTF-8
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(text)

# Process all HTML files
root = r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110'
for dirpath, dirnames, filenames in os.walk(root):
    for fname in filenames:
        if fname.endswith('.html'):
            fix_double_encoding(os.path.join(dirpath, fname))

print("Done!")