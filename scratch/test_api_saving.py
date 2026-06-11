import requests
import psycopg2

url = "http://localhost:5000/api/pi/pis/15"

# 1. Fetch PI 15
print("Fetching PI 15...")
r = requests.get(url)
if r.status_code != 200:
    print(f"Error: {r.status_code}")
    print(r.text)
    exit(1)

pi = r.json()

# 2. Modify first item in first piece to have an observation
if len(pi.get("piItensPecas", [])) > 0:
    peca = pi["piItensPecas"][0]
    if len(peca.get("piItens", [])) > 0:
        item = peca["piItens"][0]
        item["observacao"] = "TEST_API_SAVING_OBS"
        print(f"Modifying item ID {item['id']} inside piece {peca['descricao']}")
    else:
        print("No items in the first piece.")
        exit(1)
else:
    print("No pieces in PI 15.")
    exit(1)

# 3. PUT it back
print("Sending PUT request...")
r_put = requests.put(url, json=pi)
if r_put.status_code == 200:
    print("PUT request successful!")
else:
    print(f"PUT failed with status {r_put.status_code}")
    print(r_put.text)
    exit(1)

# 4. Query DB directly
try:
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    cur.execute("SELECT id, id_pi, observacao FROM pi.pi_item WHERE id_pi = 15")
    rows = cur.fetchall()
    print("Items of PI 15 in database:")
    for r in rows:
        if r[2]:
            print(f"  Item ID: {r[0]} | Obs: {repr(r[2])}")
    cur.close()
    conn.close()
except Exception as e:
    print("DB Error:", e)
