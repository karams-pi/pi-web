import requests
import openpyxl
import sys
import time

def test_export(pi_id):
    url = f"http://localhost:5000/api/pi/pis/{pi_id}/excel?currency=EXW&validity=30&lang=PT"
    print(f"Requesting export for PI {pi_id} from {url}...")
    
    for attempt in range(5):
        try:
            r = requests.get(url, timeout=10)
            if r.status_code == 200:
                print("Success! Export retrieved.")
                filename = f"test_export_{pi_id}.xlsx"
                with open(filename, "wb") as f:
                    f.write(r.content)
                break
            else:
                print(f"Server returned status {r.status_code}: {r.text}")
        except Exception as e:
            print(f"Connection failed: {e}")
        time.sleep(2)
    else:
        print("Could not connect to the API. Make sure the backend is running.")
        sys.exit(1)

if __name__ == "__main__":
    pi_id = int(sys.argv[1]) if len(sys.argv) > 1 else 15
    test_export(pi_id)
