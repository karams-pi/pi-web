path = r"c:\Portifólio\pi-web\backend\Pi.Api\Services\PiExportService.cs"

with open(path, 'rb') as f:
    data = f.read()

idx = data.find(b"PARAN")
while idx != -1:
    print(f"Found PARAN at index {idx}. Bytes: {data[idx:idx+12]}")
    idx = data.find(b"PARAN", idx + 1)
