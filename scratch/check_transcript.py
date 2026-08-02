import json

def main():
    path = r"C:\Users\takeda\.gemini\antigravity-ide\brain\7cd4d7f3-228a-441e-abb1-10e8fe3f8601\.system_generated\logs\transcript.jsonl"
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            obj = json.loads(line)
            if 'tool_calls' in obj:
                for tc in obj['tool_calls']:
                    if tc.get('name') == 'browser_subagent':
                        print(f"Step {obj.get('step_index')}: browser_subagent call args:")
                        print(json.dumps(tc.get('arguments'), indent=2))
                        
if __name__ == "__main__":
    main()
