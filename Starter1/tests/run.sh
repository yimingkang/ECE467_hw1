#!/bin/bash
echo "=================== TESTING STARTS ===================="
echo ""
for file in ./*.frog; do
    ../compiler467 -Tn "$file" > "$file".out
    DIFF=$(diff "$file".out "$file".target)
    OUT=$(python verify.py "$file".out)
    if [ "$DIFF" != "" ] 
    then
        echo "*****TEST $file FAILED TO MATCH TARGET*****"
        printf "diff   %-30s --- FAILED\n" "$file"
        diff "$file".out "$file".target
    else
        printf "diff   %-30s --- OK\n" "$file"
    fi

    if [ "$OUT" != "" ] 
    then
        echo "*****TEST $file FAILED TO PRODUCE CONSITENT TOKEN*****"
        printf "verify %-30s --- FAILED\n" "$file"
        python verify.py "$file".out
    else
        printf "verify %-30s --- OK\n" "$file"
    fi
done
rm -f *.out
echo "==================== TESTING ENDS ====================="
