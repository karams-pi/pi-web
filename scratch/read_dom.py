import json

def main():
    path = r"C:\Users\takeda\.gemini\antigravity-ide\brain\7cd4d7f3-228a-441e-abb1-10e8fe3f8601\.system_generated\logs\transcript_full.jsonl"
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            obj = json.loads(line)
            # Find browser_subagent step execution outputs
            if 'content' in obj and 'verify_karams_table' in str(obj.get('tool_calls')):
                content = obj['content']
                if 'DOM' in content or 'page_source' in content or 'html' in content.lower():
                    # Print part of the DOM if it's there
                    print("Found browser_subagent DOM output. Length:", len(content))
                    # Let's save it to a text file to read
                    with open(r"c:\Portifólio\pi-web\scratch\dom_output.txt", "w", encoding="utf-8") as out:
                        out.write(content)
                    print("Saved to scratch/dom_output.txt")
                    
if __name__ == "__main__":
    main()
