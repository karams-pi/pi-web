import os
from PIL import Image

assets_dir = r"c:\Portifólio\pi-web\backend\Pi.Api\Assets"
for file in os.listdir(assets_dir):
    if file.startswith("logo-"):
        img_path = os.path.join(assets_dir, file)
        try:
            with Image.open(img_path) as img:
                print(f"{file}: {img.width}x{img.height} (Aspect: {img.width/img.height:.2f})")
        except Exception as e:
            print(f"{file}: Error {e}")
