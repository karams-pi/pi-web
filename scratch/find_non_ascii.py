path = r"c:\Portifólio\pi-web\backend\Pi.Api\Services\PiExportService.cs"

with open(path, 'rb') as f:
    data = f.read()

# Decode as latin-1 to inspect the raw byte values correctly without decoding errors
text = data.decode('latin-1')

print("Non-ASCII characters found (using hex escapes for output):")
for line_num, line in enumerate(text.splitlines(), 1):
    non_ascii = [(c, ord(c)) for c in line if ord(c) > 127]
    if non_ascii:
        # Avoid printing raw non-ASCII chars directly to stdout
        safe_line = "".join(c if ord(c) < 128 else f"\\u{ord(c):04X}" for c in line)
        print(f"Line {line_num}: {safe_line.strip()}")
        print(f"  Chars: {non_ascii}")
