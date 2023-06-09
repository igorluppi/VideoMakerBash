[[ -n $1 ]] || { echo "missing file name"; exit 1; }

config_file=$1
option_encoder=$2
column1=( )
column2=( )
column3=( )
column4=( )
max=0

while IFS=',' read -r col1 col2 col3 col4 || [[ -n $col1 ]]
do
    column1+=( "$col1" )
    column2+=( "$col2" )
    column3+=( "$col3" )
    column4+=( "$col4" )
    max=$((max+1))
done < $config_file

for (( i=0; i < $max; i++ )); do
    col1=${column1[i]}
    col2=${column2[i]}
    col3=${column3[i]}
    col4=${column4[i]}
    if [[ -n $col1 ]]; then
        echo "Input: $col1, Begin: $col2, End: $col3, Output: $col4"
        # Process the non-empty line
        # example: $col1 = IN.mp4, $col2 = 00:30:00, $col3 = 01:45:00, $col4 = OUT.mp4
        if [[ "$option_encoder" = "melt" ]]; then
            echo "Starting melt..."
            melt ${col1} in=${col2} out=${col3} -consumer avformat:${col4}
        else
            echo "Starting ffmpeg..."
            ffmpeg -i ${col1} -ss "${col2}" -to "${col3}" -c copy -y ${col4}
        fi
    fi
done
