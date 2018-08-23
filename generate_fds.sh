#!/bin/bash

# Get start time.
start_time=$(date +"%Y-%m-%d %H:%M:%S")
timestamp=${start_time// /--}
raw_output="fts_${timestamp}.txt"
final_output="fts_${timestamp}_final.txt"

# Run generation.
python lstm_generate_book.py -em 5 -l 2 -n 200 -N 1833 -S softmax -T 0.05 -E 1 -b 5 -t 0.2 -D results/wuthering-em5-nhu200 data/wuthering.txt results/wuthering-em5-nhu200/list results/${raw_output}

# Post-process.
python postprocess_generated_book.py -N 1833 results/${raw_output} data/wuthering.txt results/${final_output}

# Get end time.
end_time=$(date +"%Y-%m-%d %H:%M:%S")

echo "This book was generated ${start_time} through ${end_time}."
