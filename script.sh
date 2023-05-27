[[ -n $1 ]] || { echo "missing file name"; exit 1; }

while IFS=',' read -r col1 col2 col3 col4 || [[ -n $col1 ]]
do
    if [[ -n $col1 ]]; then
        # Process the non-empty line
        echo "Column 1: $col1, Column 2: $col2, Column 3: $col3, Column 4: $col4"
    fi
done < $1
