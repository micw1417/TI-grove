#!/usr/bin/env bash
# fix_makefile.sh
# Scans a Makefile for common copy-paste corruption and fixes it
# Usage: ./fix_makefile.sh [Makefile]

FILE="${1:-Makefile}"

if [[ ! -f "$FILE" ]]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

echo "🔍 Scanning $FILE for common corruption..."

FIXED=0

# Fix 1: $  at end of compile rule (should be $<)
if grep -qP '\$\s*$' "$FILE"; then
    sed -i -E 's/\$[[:space:]]*$/\$</g' "$FILE"
    echo "✅ Fixed: bare '$' at end of line → '\$<'"
    FIXED=1
fi

# Fix 2: missing tab indentation (spaces instead of tab on recipe lines)
# Make REQUIRES tabs, not spaces, before recipe commands
if grep -qP '^    \$\(' "$FILE"; then
    sed -i 's/^    \$(CC)/\t$(CC)/g' "$FILE"
    sed -i 's/^    \$(OBJCOPY)/\t$(OBJCOPY)/g' "$FILE"
    sed -i 's/^    @/\t@/g' "$FILE"
    echo "✅ Fixed: spaces before recipe lines → tabs"
    FIXED=1
fi

# Fix 3: Windows CRLF line endings (breaks make on MINGW/bash)
if file "$FILE" | grep -q CRLF; then
    sed -i 's/\r//' "$FILE"
    echo "✅ Fixed: CRLF line endings → LF"
    FIXED=1
fi

if [[ $FIXED -eq 0 ]]; then
    echo "✅ No issues found in $FILE"
else
    echo ""
    echo "🎉 Done! Run 'make' again."
fi