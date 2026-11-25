import os

def fix_encoding(filepath):
    """Fix multiply-encoded UTF-8 with BOM handling"""
    with open(filepath, 'rb') as f:
        content = f.read()
    
    # Remove UTF-8 BOM if present
    if content.startswith(b'\xef\xbb\xbf'):
        content = content[3:]
        print(f"  Removed BOM from {filepath}")
    
    # Decode as latin-1
    text = content.decode('latin-1')
    
    # Try multiple rounds of: encode as latin-1, decode as utf-8
    for round_num in range(5):
        try:
            test_bytes = text.encode('latin-1')
            decoded = test_bytes.decode('utf-8')
            if decoded != text:
                text = decoded
                print(f"  Round {round_num+1}: decoded for {filepath}")
            else:
                break
        except UnicodeEncodeError as e:
            # Handle BOM or other non-latin-1 chars
            if '\ufeff' in text:
                text = text.replace('\ufeff', '')
                continue
            print(f"  Round {round_num+1} encode error: {e}")
            break
        except UnicodeDecodeError:
            break
    
    # Write back as UTF-8 (with BOM for Windows compatibility)
    with open(filepath, 'w', encoding='utf-8-sig') as f:
        f.write(text)
    
    print(f"  Fixed: {filepath}")

# Process all HTML files
root = r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110'
for dirpath, dirnames, filenames in os.walk(root):
    for fname in filenames:
        if fname.endswith('.html'):
            fix_encoding(os.path.join(dirpath, fname))

print("Done!")