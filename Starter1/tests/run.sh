#!/bin/bash
for file in ./*.glsl; do
    ../compiler467 -Tn "$file" > "$file".out
    diff "$file".out "$file".target
done
