#!/bin/bash

input="titik-penting.txt"
output="posisipusaka.txt"

awk -F',' '
NR == 1 {lat1=$3; lon1=$4}
NR == 3 {lat2=$3; lon2=$4}

END {
mid_lat = (lat1 + lat2) / 2
mid_lon = (lon1 + lon2) / 2

print "Koordinat pusat: "
printf "%.6f, %.6f", mid_lat, mid_lon

# simpan output ke file lain
printf "%.6f, %.6f", mid_lat, mid_lon > "posisipusaka.txt"
}
' "$input"

