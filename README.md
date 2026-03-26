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

Program tersebut menggunakan metode awk untuk mengolah data. 
Rule BEGIN dijalankan sekali sebelum awk membaca isi file. ```FS = ","``` menetapkan Field Separator menjadi koma, memberi tanda bahwa tiap data dipisah oleh koma sesuai format csv. 
```opsi = ARGV[2]``` mengambil argumen kedua (dihitung mulai nol) dari input "awk -f file.sh data.csv a". ```delete ARGV[2]```, argumen tersebut dihapus dari daftar file agar awk tidak menganggap argumen tersebut sebagai nama file yang harus dibuka. 
Built NR > 1 dijalankan untuk setiap baris dalam file kecuali baris pertama (judul kolom). 

Rule END juga dijalankan sekali setelah seluruh file dibaca. Skrip tiap opsi (a-e) di awal dicek menggunakan percabangan if-else. 

Opsi a: Setelah dihitung satu persatu menggunakan ```count_passenger++``` kemudian ditampilkan total penumpangnya.

Opsi b: Dari ```carriage[$4]++``` (associative array) jika nama gerbong baru muncul, awk akan menambahkannya ke array. Kemudian ditampilkan jumlah gerbongnya menggunakan fungsi ```lenghr(carriage)``` yang menghitung berapa banyak gerbong yang array carriage isi.

Opsi c: Dengan logika ```if ($2 > oldest)```, mencari nilai maksimum pada kolom usia dan simpan usianya serta namanya. 

Opsi d: Menghitung rata-rata usia dan menggunakan ```%.0f``` untuk pembulatan. 

Else: Logika ini dibuat jika pengisian input tidak sesuai format.

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
Penggunaan gsub (global substitution) sebagai fungsi bawaan awk untuk mencari dan mengganti teks. Mengganti semua kemunculan pola ```/\r/``` (carriage return tersembunyi), ```""``` untuk menghapus, dan ```$0``` sebagai target data yang harus dibaca awk (semua baris).

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
```

Logika: 
``` bash
input="gsxtrack.json"
output="titik-penting.txt"
```
Data parser yang menggunakan awk untuk mengambil informasi spesifik dari file json dan mengubahnya menjadi format csv yang rapi.
```-F'"'``` sebagai parameter pembatas antar kolom dengan tanda ".
```/"id":/ {id = $4}``` jika pada file json mengandung teks "id", simpan isi kolom ke-4 ke dalam variabel id. Contoh dalam file json tersebut:
"id": "node_001",
Artinya isi kolom ke-4 (node_001) yang disimpan.

```lat = ($4 != "" ? $4 : $3);```
Logika tersebut berfungsi sebagai pengaman bila kolom ke 4 kosong maka isi kolom ke 3 yang disimpan.
```gsub(/[[:space:]:,]/, "", lat)```
Penggunaan gsub di sini berfungsi untuk menghapus semua karakter yang tidak diperlukan seperti spasi (```:space:]```), titik dua (```:```), dan koma (```,```) agar variabel ```lat``` hanya berisi angka murni.

Hasil akhir awk dipindah ke perintah ```sort``` agar urutan node berurutan sebelum disimpan ke file output. 

Hasil output dalam file baru (titik-penting.txt)

<img width="462" height="113" alt="Screenshot 2026-03-24 225207" src="https://github.com/user-attachments/assets/33e0a759-51f0-4c88-92e4-b5262ba42039" />

### 4. Menghitung titik tengah diagonal koordinat
Membuat program melalui file nemupusaka.sh untuk menghitung titik tengah dengan rumus yang telah diberikan di soal lalu hasil outputnya diletakkan pada file baru (posisipusaka.txt)

``` bash
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
```

Jika dilihat dari angka koordinat dari file ```titik-penting.txt```, maka ```NR == 1``` sebagai node_001 dan ```NR == 3``` sebagai node_003 dapat digunakan untuk menghitung diagonal persegi karena tidak ada nilai latitide ($3) dan longitude ($4) yang sama. 

Rule END menandakan bahwa logika matematika titik tengah hanya bisa dilakukan setelah awk membaca seluruh file dan mendapatkan nilai yang dibutuhkan untuk mengitung titik tengah. 
```%.6f``` memastikan agar program menampilkan 6 angka di belakang koma sebagai angka koordinat. 

Hasil output dalam file baru (posisipusaka.txt)

<img width="493" height="143" alt="Screenshot 2026-03-25 121410" src="https://github.com/user-attachments/assets/cc1298c0-c2c3-4eb4-95fe-f1d4d24ef5f9" />

Cek tree:

<img width="509" height="222" alt="Screenshot 2026-03-25 125345" src="https://github.com/user-attachments/assets/98382148-fd9f-4c12-95a2-894a518128d6" />

### Kendala

Folder venv sebelumnya berada dalam tree soal_2, maka dari itu saya remove folder tersebut untuk menjaga tree sesuai ketentuan soal, kemudian menginstall ulang dan meletakkan folder tersebut di user agar tools tersebut dapat digunakan secara global. 

## Soal_3
