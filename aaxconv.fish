function aaxconv
    # Check if the input file is provided
    if test (count $argv) -ne 2
        echo "Usage: aaxconv <activation_bytes> <input.aax>"
        return 1
    end

    # Extract arguments
    set activation_bytes $argv[1]
    set input_file $argv[2]

    # Ensure the input file exists
    if not test -f $input_file
        echo "Error: File '$input_file' not found!"
        return 1
    end

    # Get the base name without extension
    set output_file (basename $input_file .aax).m4b

    # Run the ffmpeg command
    ffmpeg -y -activation_bytes $activation_bytes -i $input_file -map_metadata 0 -id3v2_version 3 -codec:a copy -vn $output_file

    # Check if the conversion was successful
    if test $status -eq 0
        echo "Conversion complete: $output_file"

        # Create the "done" folder if it doesn't exist
        if not test -d done
            mkdir done
        end

        # Move the original .aax file to the "done" folder
        mv $input_file done/
        echo "Moved $input_file to 'done/' folder."
    else
        echo "Error during conversion."
        return 1
    end
end
