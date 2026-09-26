#!/Users/tm/.pyenv/versions/token-counter/bin/python3

"""
Accurate token counter using tiktoken (OpenAI's tokenizer)
Usage: tokencount-python [file_or_folder] or tokencount-python < file
Auto-detects whether argument is a file or folder
"""

import sys
import tiktoken
import argparse
import os
from pathlib import Path

def count_tokens(text, model="gpt-4"):
    """Count tokens using tiktoken for the specified model"""
    try:
        encoding = tiktoken.encoding_for_model(model)
        return len(encoding.encode(text))
    except KeyError:
        # Fallback to cl100k_base encoding if model not found
        encoding = tiktoken.get_encoding("cl100k_base")
        return len(encoding.encode(text))

def get_files_in_folder(folder_path):
    """Recursively get all files in a folder"""
    files = []
    folder = Path(folder_path)
    
    if not folder.exists():
        raise FileNotFoundError(f"Folder '{folder_path}' not found")
    
    if not folder.is_dir():
        raise NotADirectoryError(f"'{folder_path}' is not a directory")
    
    for file_path in folder.rglob('*'):
        if file_path.is_file():
            files.append(file_path)
    
    return files

def main():
    parser = argparse.ArgumentParser(
        description="Count tokens in text as an LLM would see them",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  tokencount-python file.txt
  tokencount-python /path/to/directory
  tokencount-python < file.txt
  echo "Hello world" | tokencount-python
  tokencount-python --model gpt-3.5-turbo file.txt
        """
    )
    parser.add_argument("path", nargs="?", help="File or folder to count tokens in (or read from stdin)")
    parser.add_argument("--model", "-m", default="gpt-4", 
                       help="Model to use for tokenization (default: gpt-4)")
    parser.add_argument("--list-models", action="store_true",
                       help="List available models and exit")
    
    args = parser.parse_args()
    
    if args.list_models:
        print("Available models:")
        print("- gpt-4 (default)")
        print("- gpt-3.5-turbo")
        print("- text-davinci-003")
        print("- text-davinci-002")
        print("- text-davinci-001")
        print("- text-curie-001")
        print("- text-babbage-001")
        print("- text-ada-001")
        print("- code-davinci-002")
        print("- code-cushman-001")
        return
    
    # Handle stdin input (pipe support)
    if not args.path:
        if sys.stdin.isatty():
            print("No path specified and no input from stdin. Use --help for usage.", file=sys.stderr)
            sys.exit(1)
        text = sys.stdin.read()
        try:
            token_count = count_tokens(text, args.model)
            print(token_count)
        except Exception as e:
            print(f"Error counting tokens: {e}", file=sys.stderr)
            sys.exit(1)
        return
    
    # Auto-detect if path is file or folder
    path = Path(args.path)
    
    if not path.exists():
        print(f"Error: Path '{args.path}' not found", file=sys.stderr)
        sys.exit(1)
    
    if path.is_dir():
        # Handle folder input
        try:
            files = get_files_in_folder(args.path)
            total_tokens = 0
            
            for file_path in files:
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        text = f.read()
                    token_count = count_tokens(text, args.model)
                    # Get relative path from the folder
                    relative_path = file_path.relative_to(path)
                    print(f"{relative_path} {token_count}")
                    total_tokens += token_count
                except (UnicodeDecodeError, PermissionError) as e:
                    # Skip files that can't be read as text
                    relative_path = file_path.relative_to(path)
                    print(f"{relative_path} 0  # Error: {e}", file=sys.stderr)
                    continue
                except Exception as e:
                    relative_path = file_path.relative_to(path)
                    print(f"{relative_path} 0  # Error: {e}", file=sys.stderr)
                    continue
            
            # Print total
            print(f"TOTAL {total_tokens}")
            
        except Exception as e:
            print(f"Error processing folder: {e}", file=sys.stderr)
            sys.exit(1)
    else:
        # Handle single file input
        try:
            with open(args.path, 'r', encoding='utf-8') as f:
                text = f.read()
            token_count = count_tokens(text, args.model)
            print(token_count)
        except FileNotFoundError:
            print(f"Error: File '{args.path}' not found", file=sys.stderr)
            sys.exit(1)
        except Exception as e:
            print(f"Error reading file: {e}", file=sys.stderr)
            sys.exit(1)

if __name__ == "__main__":
    main()
