#!/bin/zsh

# Define the directory where the video segments will be saved
readonly SAVE_DIR="$HOME/Videos/Aiya"

# Create the directory if it doesn't exist
mkdir -p "$SAVE_DIR"

# Function to extract video ID and timestamp from a YouTube URL
extract_id_and_time() {
    local url="$1"
    local video_id=""
    local timestamp=""

    # Match youtu.be URLs
    if [[ "$url" == *youtu.be/* ]]; then
        video_id="${url##*youtu.be/}"
        video_id="${video_id%%\?*}"  # Remove query params if any
    elif [[ "$url" == *youtube.com* ]]; then
        video_id="${url##*v=}"
        video_id="${video_id%%&*}"   # Remove additional params
    else
        echo "Error: Unable to extract video ID from URL: $url"
        exit 1
    fi

    # Extract the timestamp (t=275 or t=275s)
    if [[ "$url" == *\?*t=* || "$url" == *\&*t=* ]]; then
        timestamp="${url##*t=}"
        timestamp="${timestamp%%[^0-9]*}"  # Remove trailing "s" or any non-numeric chars
    else
        echo "Error: Unable to extract timestamp from URL: $url"
        exit 1
    fi

    echo "$video_id" "$timestamp"
}

# Function to shift and trim WebVTT subtitles
shift_and_trim_vtt_subtitles() {
    local input_subs="$1"
    local output_subs="$2"
    local shift_seconds="$3"
    local duration="$4"

    awk -v shift="$shift_seconds" -v duration="$duration" '
    function time_to_seconds(h, m, s, ms) {
        return h * 3600 + m * 60 + s + ms / 1000
    }
    function seconds_to_time(t) {
        h = int(t / 3600)
        m = int((t % 3600) / 60)
        s = int(t % 60)
        ms = int((t - int(t)) * 1000)
        return sprintf("%02d:%02d:%02d.%03d", h, m, s, ms)
    }
    BEGIN { header_done = 0 }
    {
        if (!header_done) {
            print
            if ($0 == "") {
                header_done = 1
            }
            next
        }
    }
    /^[0-9]+$/ { print; next }  # Cue number (optional)
    /-->/ {
        split($1, start, "[:,.]")
        split($3, end, "[:,.]")

        start_sec = time_to_seconds(start[1], start[2], start[3], start[4]) - shift
        end_sec = time_to_seconds(end[1], end[2], end[3], end[4]) - shift

        if (start_sec < 0) start_sec = 0
        if (end_sec < 0) end_sec = 0

        # Skip subtitles that are out of the desired time window
        if (start_sec > duration) next
        if (end_sec > duration) end_sec = duration

        print seconds_to_time(start_sec) " --> " seconds_to_time(end_sec)
        next
    }
    { print }  # Text lines
    ' "$input_subs" > "$output_subs"
}

# Check if two arguments are provided
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <YouTube URL with start timestamp> <YouTube URL with end timestamp>"
    exit 1
fi

# Extract video ID and timestamps from the provided URLs
start_url="$1"
end_url="$2"

start_info=($(extract_id_and_time "$start_url"))
end_info=($(extract_id_and_time "$end_url"))

start_video_id="${start_info[1]}"
start_time="${start_info[2]}"

end_video_id="${end_info[1]}"
end_time="${end_info[2]}"

# Check if the video IDs match
if [[ "$start_video_id" != "$end_video_id" ]]; then
    echo "Error: The provided URLs refer to different videos."
    exit 1
fi

# Calculate the duration of the segment
duration=$((end_time - start_time))

if [[ $duration -le 0 ]]; then
    echo "Error: The end time must be greater than the start time."
    exit 1
fi

# Create a download-sections argument: "*start-end"
section_arg="*${start_time}-${end_time}"

# Construct the output filename
output_file="$SAVE_DIR/${start_video_id}_segment_${start_time}s_to_${end_time}s.%(ext)s"

# Download the specified segment using yt-dlp --download-sections
yt-dlp \
    --download-sections "$section_arg" \
    --force-keyframes-at-cuts \
    --remux-video mkv \
    --write-subs \
    --sub-format "vtt" \
    -f "bv*[height=1080][vbr<=7000]+ba/b" \
    -o "$output_file" \
    "https://www.youtube.com/watch?v=$start_video_id"

echo "Downloaded segment saved to: $SAVE_DIR"

# Find the subtitle file (.vtt)
subs_file="$(ls "$SAVE_DIR/${start_video_id}_segment_${start_time}s_to_${end_time}s"*.vtt 2>/dev/null | head -n 1)"

if [[ -f "$subs_file" ]]; then
    shifted_subs_file="${subs_file%.vtt}_shifted_trimmed_${start_time}s.vtt"
    echo "Shifting and trimming subtitles by ${start_time} seconds, duration ${duration} seconds..."
    shift_and_trim_vtt_subtitles "$subs_file" "$shifted_subs_file" "$start_time" "$duration"
    echo "Shifted and trimmed subtitles saved to: $shifted_subs_file"

    # Delete the original subtitle file
    echo "Deleting original subtitle file: $subs_file"
    rm "$subs_file"
else
    echo "No subtitle file found to shift/trim."
fi

