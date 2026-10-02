import subprocess

def run_query(sql):
    cmd = ["docker", "exec", "-i", "pi-postgres", "psql", "-U", "pi", "-d", "pi_db", "-c", sql]
    res = subprocess.run(cmd, capture_output=True, text=True, encoding='utf-8')
    if res.returncode != 0:
        print("Error:", res.stderr)
    return res.stdout

print("--- ITENS SIMULACOES 88 & 89 APOS AJUSTE ---")
print(run_query("""
SELECT si."Id", si."IdSimulacao", s."NumeroReferencia", si."IdProduto", si."IdModelo",
       p."Referencia", p."Descricao", p."IdNcm", n."Codigo" as "NcmCodigo"
FROM edc.simulacao_itens si
JOIN edc.simulacoes s ON si."IdSimulacao" = s."Id"
JOIN edc.produtos p ON si."IdProduto" = p."Id"
LEFT JOIN edc.ncms n ON p."IdNcm" = n."Id"
WHERE si."IdSimulacao" IN (88, 89)
ORDER BY si."IdSimulacao", si."Id";
"""))
