[[ -n $1 ]] || { echo "missing file name"; exit 1; }

while IFS=',' read -r col1 col2 col3 col4 || [[ -n $col1 ]]
do
    if [[ -n $col1 ]]; then
        # Process the non-empty line
        echo "Input: $col1, Begin: $col2, End: $col3, Output: $col4"
        # example: $col1 = IN.mp4, $col2 = 00:30:00, $col3 = 01:45:00, $col4 = OUT.mp4
        melt $col1 in=$col2 out=$col3 -consumer avformat:$col4
    fi
done < $1
