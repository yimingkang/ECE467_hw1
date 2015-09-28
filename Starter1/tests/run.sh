#!/bin/bash
for filename in ./*.glsl; do
    ../compiler467 -Tn "$filename" > "$filename".out
    cmp --silent "$filename".out "$filename".target || echo "Files are different.\nTEST FAILS!!!!!!"
done
