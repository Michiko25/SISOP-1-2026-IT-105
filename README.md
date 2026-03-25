# SISOP-1-2026-IT-105

## Soal_1
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

<img width="307" height="90" alt="Screenshot 2026-03-20 161517" src="https://github.com/user-attachments/assets/8dda9fab-2b3a-4590-b407-1ea3a9d6155e" />

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

<img width="450" height="280" alt="Screenshot 2026-03-25 180848" src="https://github.com/user-attachments/assets/ee0f7e86-52b1-4b81-bd51-438745f70c62" />

Cek tree:

<img width="288" height="110" alt="image" src="https://github.com/user-attachments/assets/006359c2-a2fa-4fcb-bd44-bc3f736cd60f" />


## Soal_2

### 1. Install gdown dan download file pdf

Untuk menginstall tool gdown menggunakan command:
``` bash
sudo apt update
sudo apt install pipx
pipx ensurepath
```

Untuk mendownload file pdf menggunakan command:
``` bash
gdown --id 1q10pHSC3KFfvEiCN3V6PTroPR7YGHF6Q -O peta-ekspedisi-amba.pdf
```
Navigasi file:

<img width="486" height="102" alt="Screenshot 2026-03-23 215137" src="https://github.com/user-attachments/assets/bd0380a5-bbb7-4f00-b52f-ca5d07c51a64" />

### 2. Mencari file dalam file peta-ekspedisi-amba.pdf

Membuka file peta-ekspedisi-amba.pdf secara concatenate, menggunakan command cat dan di akhir isi file terdapat link git

<img width="611" height="142" alt="Screenshot 2026-03-24 211616" src="https://github.com/user-attachments/assets/3139c735-9775-4aed-8a3d-93446f4c5c77" />


Command git clone untuk download link yang telah ditemukan

<img width="506" height="235" alt="Screenshot 2026-03-24 212214" src="https://github.com/user-attachments/assets/944262b2-cfe5-4083-86ae-67ce79509b1d" />

### 3. Shell script parserkoordinat.sh

Mengambil tiga data (id_site, latitude, longitude) dari gsxtrack.json yang didapat melalui repo git sebelumnya dan memindahkan hasil tersebut ke file baru bernama titik-penting.txt

``` bash
# put your parserkoordinat.sh code here dude dont forgeddddd
```

Hasil output dalam file baru (titik-penting.txt)

<img width="462" height="113" alt="Screenshot 2026-03-24 225207" src="https://github.com/user-attachments/assets/33e0a759-51f0-4c88-92e4-b5262ba42039" />

### 4. Menghitung titik tengah diagonal koordinat
Membuat program melalui file nemupusaka.sh untuk menghitung titik tengah dengan rumus yang telah diberikan di soal lalu hasil outputnya diletakkan pada file baru (posisipusaka.txt)

``` bash
# put ur nemupusaka.sh code here y
```

Hasil output dalam file baru (posisipusaka.txt)

<img width="493" height="143" alt="Screenshot 2026-03-25 121410" src="https://github.com/user-attachments/assets/cc1298c0-c2c3-4eb4-95fe-f1d4d24ef5f9" />

Cek tree:

<img width="509" height="222" alt="Screenshot 2026-03-25 125345" src="https://github.com/user-attachments/assets/98382148-fd9f-4c12-95a2-894a518128d6" />

## Soal_3
