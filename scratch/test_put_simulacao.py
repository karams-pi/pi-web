import urllib.request
import json

base = "http://localhost:5000"

# 1. Fetch simulation 63
req = urllib.request.Request(f"{base}/api/edc/simulacoes/63")
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read().decode())
    print("GET 63 status:", resp.status)
    print("Fetched 63 reference:", data.get("numeroReferencia"))
    print("Number of itens:", len(data.get("itens", [])))
    print("Number of despesas:", len(data.get("despesas", [])))

# 2. Replicate what frontend does in NovoEstudoEdcPage.tsx handleSave
sanitized_itens = []
for item in data.get("itens", []):
    item_copy = dict(item)
    if item_copy.get("idModelo") == 0:
        item_copy["idModelo"] = None
    sanitized_itens.append(item_copy)

payload = dict(data)
if payload.get("idPortoOrigem") == 0: payload["idPortoOrigem"] = None
if payload.get("idPortoDestino") == 0: payload["idPortoDestino"] = None
payload["itens"] = sanitized_itens
payload["id"] = 63

req_put = urllib.request.Request(
    f"{base}/api/edc/simulacoes/63",
    data=json.dumps(payload).encode(),
    headers={"Content-Type": "application/json"},
    method="PUT"
)

try:
    with urllib.request.urlopen(req_put) as resp_put:
        print("PUT 63 status:", resp_put.status)
except urllib.error.HTTPError as e:
    print("PUT 63 ERROR:", e.code, e.read().decode())
except Exception as e:
    print("PUT 63 EXCEPTION:", e)
