vol=$(pactl get-source-volume "@microphone@" | grep -o '[0-9]\+%' | head -n1 | tr -d '%')
if [ "$vol" -eq 0 ]; then
    @playOn@
    pactl set-source-volume "@microphone@" 100%
else
    @playOff@
    pactl set-source-volume "@microphone@" 0%
fi
