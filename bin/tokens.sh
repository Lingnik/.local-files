#!/bin/bash

# Token counter script - approximates LLM token counting
# Usage: tokencount [file] or tokencount < file

# Function to count tokens using a simple approximation
count_tokens() {
    local content="$1"
    
    # Remove extra whitespace and normalize
    content=$(echo "$content" | tr -s ' \t\n\r' ' ' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    # Count words (rough approximation: 1 word ≈ 1.3 tokens)
    local word_count=$(echo "$content" | wc -w | tr -d ' ')
    
    # Count characters for more precise estimation
    local char_count=$(echo "$content" | wc -c | tr -d ' ')
    
    # Simple approximation: ~4 characters per token for English text
    local char_based_tokens=$((char_count / 4))
    
    # Use the higher of the two estimates
    if [ "$word_count" -gt "$char_based_tokens" ]; then
        echo "$word_count"
    else
        echo "$char_based_tokens"
    fi
}

# Function to show usage
show_usage() {
    echo "Usage: tokencount [file]"
    echo "       tokencount < file"
    echo "       echo 'text' | tokencount"
    echo ""
    echo "Counts approximate tokens in text as an LLM would see them."
    echo "This is a rough approximation - for precise counting, use the Python version."
}

# Main logic
if [ $# -eq 0 ]; then
    # No arguments - read from stdin
    if [ -t 0 ]; then
        show_usage
        exit 1
    else
        content=$(cat)
        tokens=$(count_tokens "$content")
        echo "$tokens"
    fi
elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
    exit 0
elif [ -f "$1" ]; then
    # File argument
    content=$(cat "$1")
    tokens=$(count_tokens "$content")
    echo "$tokens"
else
    echo "Error: File '$1' not found" >&2
    exit 1
fi
