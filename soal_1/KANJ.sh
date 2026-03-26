BEGIN {
FS = ","
opsi = ARGV[2]
delete ARGV[2]
}

NR > 1 {
gsub (/\r/, "", $0)

# opsi a
count_passenger++

# opsi b
carriage[$4]++

# opsi c
if ($2 > oldest) {
oldest = $2
name = $1
}

# opsi d
sum += $2

# opsi e
if ($3 == "Business") {
business_passenger++
}

}

END {
if (opsi == "a") {
printf "Jumlah seluruh penumpang KANJ adalah %d orang", count_passenger
}

else if (opsi == "b") {
printf "Jumlah gerbong penumpang KANJ adalah %d", length(carriage)
}

else if (opsi == "c") {
printf "%s adalah penumpang kereta tertua dengan usia %d", name, oldest
}

else if (opsi == "d") {
printf "Rata-rata usia penumpang adalah %.0f tahun", sum/count_passenger
}

else if (opsi == "e") {
printf "Jumlah penumpang business class ada %d orang", business_passenger
}

else {
print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
print "Contoh penggunaan: awk -f file.sh data.csv a"
}

}
