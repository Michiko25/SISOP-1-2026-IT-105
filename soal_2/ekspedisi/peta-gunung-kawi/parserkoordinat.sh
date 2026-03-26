#!/bin/bash

input="gsxtrack.json"
output="titik-penting.txt"

awk -F'"' '
/"id":/ {id = $4}
/"site_name":/ {name = $4}
/"latitude":/ {
lat = ($4 != "" ? $4 : $3); gsub(/[[:space:]:,]/, "", lat)
}
/"longitude":/{
lon = ($4 != "" ? $4 : $3); gsub(/[[:space:]:,]/, "", lon)
if (id != "") print id "," name "," lat "," lon ","
}
' "$input" | sort > "$output" 
