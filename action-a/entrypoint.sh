#!/bin/sh -l
echo "Running github action"
echo "Working directory: $(pwd)"
echo "Workspace contents:"
ls -la

make pdf

echo "Output directory contents:"
ls -la output/ 2>&1

# Show ConTeXt logs if PDFs are missing
for log in output/context_*.log; do
    [ -f "$log" ] && echo "=== $log ===" && cat "$log"
done
