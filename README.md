# SISOP-1-2026-IT-105

## Soal 1
### 1. Download file passenger.csv

<img width="500" height="362" alt="Screenshot 2026-03-18 143011" src="https://github.com/user-attachments/assets/8dfc37a8-5f2b-41e7-af3e-43d857c32895" />


### 2. Membuat program sesuai soal

```bash
BEGIN {
    FS = ","
    opsi = ARGV[2]
    delete ARGV[2]
}

NR > 1 {

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
```

### 3. Analisis hasil
Mencoba hasil output:

<img width="486" height="250" alt="Screenshot 2026-03-20 161431" src="https://github.com/user-attachments/assets/0296989a-c112-4e90-822b-78db8f5f39bb" />

Setelah dicoba hasil outputnya, ternyata pada opsi b menunjukkan bahwa total gerbongnya ada 5. Untuk itu, saya membuat program untuk melihat apa saja isi gerbongnya.

``` bash
else if (opsi == "b") {
    for (nama_gerbong in carriage) {
        printf "- %s\n", nama_gerbong
}
    printf "Jumlah gerbong penumpang KANJ adalah %d", length(carriage)
}
```
<img width="319" height="125" alt="Screenshot 2026-03-20 174008" src="https://github.com/user-attachments/assets/7873a856-10c8-458e-bd58-7b4b90283cfe" />

Pada hasil output terlihat bahwa Gerbong3 terbaca dua kali. Hal ini terjadi karena sistem membaca tiap gerbong dengan akhiran \r kecuali pada baris akhir (Gerbong3). Maka solusi untuk permasalahan tersebut, saya menambahkan kode:

``` bash
gsub (/\r/, "", $0)
```

Sehingga hasil output opsi b menjadi:
<img width="615" height="180" alt="Screenshot 2026-03-20 161517" src="https://github.com/user-attachments/assets/8dda9fab-2b3a-4590-b407-1ea3a9d6155e" />




### 4. Hasil akhir
Hasil akhir untuk program KANJ.sh menjadi:

``` bash
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
    
    # opsi da
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
```
Hasil akhir untuk output menjadi:
<img width="972" height="501" alt="Screenshot 2026-03-20 161431" src="https://github.com/user-attachments/assets/443b6618-6846-451b-a43f-de3911f46c74" />



