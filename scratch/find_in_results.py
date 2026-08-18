with open("scratch/inspection_results.txt", "r", encoding="utf-8") as f:
    content = f.read()

import re
matches = [m.start() for m in re.finditer("FILE:", content)]
for i, m in enumerate(matches):
    start = m
    end = matches[i+1] if i+1 < len(matches) else len(content)
    snippet = content[start:start+500]
    print(f"Match {i}: pos {start}, snippet:\n{snippet}\n")
