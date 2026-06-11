import requests
import time
import sys

def download_export(pi_id, name):
    url = f"http://localhost:5000/api/pi/pis/{pi_id}/excel?currency=EXW&validity=30&lang=PT"
    print(f"Downloading {name} (PI {pi_id}) from {url}...")
    for attempt in range(5):
        try:
            r = requests.get(url, timeout=10)
            if r.status_code == 200:
                filename = f"test_export_{name}_{pi_id}.xlsx"
                with open(filename, "wb") as f:
                    f.write(r.content)
                print(f"Success! Saved to {filename}")
                return
            else:
                print(f"Status {r.status_code}: {r.text}")
        except Exception as e:
            print(f"Error: {e}")
        time.sleep(2)
    print(f"Failed to download {name}")

if __name__ == "__main__":
    time.sleep(3) # Wait for server to be fully ready
    download_export(15, "Ferguile")
    download_export(14, "Koyo")
    download_export(13, "Karams")
