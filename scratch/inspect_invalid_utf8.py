path = r"c:\Portifólio\pi-web\backend\Pi.Api\Services\PiExportService.cs"

with open(path, 'rb') as f:
    data = f.read()

start = max(0, 13346 - 20)
end = min(len(data), 13346 + 20)
print(f"Bytes U+13346 area: {data[start:end]}")
print(f"Byte at 13346: {data[13346]:02X}")
