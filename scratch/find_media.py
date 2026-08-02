import os

def main():
    root = r"C:\Users\takeda\.gemini\antigravity-ide\brain\7cd4d7f3-228a-441e-abb1-10e8fe3f8601"
    for dirpath, dirnames, filenames in os.walk(root):
        for f in filenames:
            if f.endswith('.png') or f.endswith('.webp'):
                print(os.path.join(dirpath, f))
                
if __name__ == "__main__":
    main()
