import os

def fix_triple_encoding(filepath):
    """Fix multiply-encoded UTF-8"""
    with open(filepath, 'rb') as f:
        content = f.read()
    
    # Decode as latin-1 (get the intermediate string representation)
    text = content.decode('latin-1')
    
    # Try multiple rounds of: encode as latin-1, decode as utf-8
    for round_num in range(5):
        try:
            # Encode current text as latin-1 to get bytes
            test_bytes = text.encode('latin-1')
            # Try to decode as utf-8
            decoded = test_bytes.decode('utf-8')
            # If successful and different from current, continue
            if decoded != text:
                text = decoded
                print(f"  Round {round_num+1}: decoded for {filepath}")
            else:
                break
        except UnicodeDecodeError:
            break
        except UnicodeEncodeError:
            break
    
    # Final verification
    try:
        text.encode('utf-8')
    except:
        text = text.encode('latin-1', errors='replace').decode('utf-8', errors='replace')
    
    # Write back
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(text)
    
    print(f"  Final fix applied: {filepath}")

# Process all HTML files
root = r'C:\Users\Christian\Desktop\Wokflows\Practicas_Docencia\IFCD0110'
for dirpath, dirnames, filenames in os.walk(root):
    for fname in filenames:
        if fname.endswith('.html'):
            fix_triple_encoding(os.path.join(dirpath, fname))

print("Done!")