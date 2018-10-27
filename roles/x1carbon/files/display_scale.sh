#!/bin/bash

# Script from https://github.com/burntcustard/x11-fractional-display-scaling

# Modify this to change the default if you don't want to use the
# optional argument. E.g: scale=${1:-1.25} for 1.25x scaling.
scale=${1:-1.4}

echo "Running $(basename $0)"

xdg=$(echo $XDG_SESSION_TYPE)
if [[ $xdg != "x11" ]]; then
    echo "ERROR: Running $xdg display server rather than x11"
    exit 1
fi

if ! [[ $scale =~ ^[1-9](\.[0-9]*)?$ ]]; then
    echo "ERROR: Scaling factor must be 1-10"
    exit 1
fi

xrandr=$(xrandr -q)  # Get current screen properties

monitorCount=$(grep ' connected' <<< $xrandr |
               wc -l)

# TODO Consider detecting this based on the gnome scaling-factor instead of external monitors
# Will need to fix if I get a HiDPI external monitor :)
if [[ $monitorCount == "2" ]] ; then
    echo "Skipping fractional display scaling for external monitor"
    exit 1
fi

# Get the current panning value (i.e. up/down scaled resolution):
currentPan=$(grep -o "current[^,]\+" <<< $xrandr |  # Get "current [pan]" section
             cut -c8- |                             # Remove "current" (first 8 chars)
             tr -d "[:space:]")                     # Remove all whitespace

# Get max res supported by hardware:
res=$(sed '3!d' <<< $xrandr |       # Get line 3 (should be the the correct line...)
      xargs |                       # Remove leading whitespace
      grep -o '^\S*')               # Remove stuff after resolution (starting with 1st ' ')

# Get display identifier:
display=$(sed '2!d' <<< $xrandr |   # Get line 2 (should be the the correct line...)
          grep -o '^\S*')           # Remove stuff after display (starting with 1st ' ')

xRes=$(cut -d "x" -f 1 <<< $res)
yRes=$(cut -d "x" -f 2 <<< $res)
xPan=$(bc <<< "scale=0;($xRes*$scale)/1")
yPan=$(bc <<< "scale=0;($yRes*$scale)/1")
pan=$xPan'x'$yPan
scale=$scale'x'$scale  # Change scale from "1.5" to "1.5x1.5"

echo "Intended scaling:           $scale"
echo "Display identifier:         $display"
echo "Max hardware resolution:    $res"
echo "Current panning resolution: $currentPan"
echo "New panning resolution:     $pan"

if [ "$currentPan" != "$pan" ]; then
    xrandr --output $display --scale $scale --panning $pan
else
    echo "Not changing scaling as current and intended resolutions match."
fi
