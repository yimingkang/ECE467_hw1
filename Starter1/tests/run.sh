#!/bin/bash
echo "=================== TESTING STARTS ===================="
echo ""
for file in ./*.glsl; do
    ../compiler467 -Tn "$file" > "$file".out
    diff "$file".out "$file".target
done
echo "================+=== TESTING ENDS ==================+=="
