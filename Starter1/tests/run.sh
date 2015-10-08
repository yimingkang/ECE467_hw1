#!/bin/bash
echo "=================== TESTING STARTS ===================="
echo ""
for file in ./*.frag; do
    ../compiler467 -Tn "$file" > "$file".out 2>&1
    DIFF=$(diff "$file".out "$file".target)
    if [ "$DIFF" != "" ] 
    then
        printf "diff   %-30s --- \e[1;31mFAILED\e[1;0m\n" "$file"
        echo "*****TEST $file FAILED TO MATCH TARGET*****"
        diff "$file".out "$file".target
    else
        printf "diff   %-30s --- \e[1;32mOK\e[1;0m\n" "$file"
    fi
done

for file in ./*.frag; do
    ../compiler467 -Tn "$file" > "$file".out 2>&1
    OUT=$(python verify.py "$file".out)
    if [ "$OUT" != "" ] 
    then
        printf "verify %-30s --- \e[1;31mFAILED\e[1;0m\n" "$file"
        echo "*****TEST $file FAILED TO PRODUCE CONSITENT TOKEN*****"
        python verify.py "$file".out
    else
        printf "verify %-30s --- \e[1;32mOK\e[1;0m\n" "$file"
    fi
done
rm -f *.out
echo "==================== TESTING ENDS ====================="
