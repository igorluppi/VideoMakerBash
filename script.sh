[[ -n $1 ]] || { echo "missing file name"; exit 1; }

config_file=$1
option_encoder=$2
edit_metadata=( )
n_files=0

# Read the file line by line
while IFS=',' read -r col1 col2 col3 col4 || [[ -n $col1 ]]
do
    # Save the line into an array
    # Somehow if the data is used directly from the file, it will be consumed incorrectly
    edit_metadata+=( "$col1" "$col2" "$col3" "$col4" )
    n_files=$((n_files+1))
done < $config_file

for (( i=0; i < $n_files; i++ )); do
    input_video=${edit_metadata[i*4]}
    cut_start=${edit_metadata[i*4+1]}
    cut_end=${edit_metadata[i*4+2]}
    output_video=${edit_metadata[i*4+3]}
    if [[ -n $input_video ]]; then
        echo "Input: $input_video, Begin: $cut_start, End: $cut_end, Output: $output_video"
        if [[ "$option_encoder" = "melt" ]]; then
            echo "Starting melt..."
            melt ${input_video} in=${cut_start} out=${cut_end} -consumer avformat:${output_video}
        else
            echo "Starting ffmpeg..."
            ffmpeg -i ${input_video} -ss "${cut_start}" -to "${cut_end}" -c copy -y ${output_video}
        fi
    fi
done
