#!/bin/bash
echo "=================== TESTING STARTS ===================="
echo ""
for file in ./*.frog; do
    ../compiler467 -Tn "$file" > "$file".out
    DIFF=$(diff "$file".out "$file".target)
    if [ "$DIFF" != "" ] 
    then
        echo "*****TEST $file FAILED*****"
        diff "$file".out "$file".target
    else
        echo "OK"
    fi
done
echo "================+=== TESTING ENDS ==================+=="
