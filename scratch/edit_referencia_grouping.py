import os

path = r"c:\Portifólio\pi-web\backend\Pi.Api\Services\PiExportService.cs"

with open(path, 'r', encoding='latin-1') as f:
    content = f.read()

target = """            var modelGroups = brandGroup.Items
                .GroupBy(i => i.ModuloTecido?.Modulo?.Id ?? 0)"""

replacement = """            var modelGroups = brandGroup.Items
                .GroupBy(i => i.ModuloTecido?.Modulo?.Marca?.Id ?? 0L)"""

if target in content:
    content = content.replace(target, replacement)
    print("Replaced model groups grouping successfully.")
else:
    print("Target NOT found in file.")

with open(path, 'w', encoding='latin-1') as f:
    f.write(content)
print("Done!")
