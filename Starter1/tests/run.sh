#!/bin/bash
for file in ./*.glsl; do
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
