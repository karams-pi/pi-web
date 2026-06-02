import psycopg2

def inspect_submod_for_mod():
    conn = psycopg2.connect("host=localhost port=5432 dbname=pi_db user=pi password=pi123")
    cur = conn.cursor()
    
    mod_ids = (5224, 5225, 5294, 5295)
    cur.execute("SELECT id, id_modulo, codigo, descricao_produto, volume_m3 FROM sub_modulo WHERE id_modulo IN %s", (mod_ids,))
    rows = cur.fetchall()
    print("Submodulos for target modules:")
    for r in rows:
        print(f"SubmodId={r[0]} | ModId={r[1]} | Codigo={r[2]} | Desc={r[3]} | Volume={r[4]}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    inspect_submod_for_mod()
