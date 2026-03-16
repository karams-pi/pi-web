import pandas as pd

file_path = r'e:\teste\pi-web\Docs\teste2.xlsx'
output_path = r'e:\teste\pi-web\excel_dump.txt'
try:
    df = pd.read_excel(file_path, header=None)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(f"Columns: {df.columns.tolist()}\n\n")
        f.write("First 50 rows:\n")
        # Use to_string with no max_rows to see everything
        f.write(df.head(50).to_string())
    print(f"Success! Dumped to {output_path}")
except Exception as e:
    print(f"Error: {e}")
