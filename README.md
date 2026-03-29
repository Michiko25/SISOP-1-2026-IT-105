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

### 5. Kendala

Folder venv sebelumnya berada dalam tree soal_2, maka dari itu saya menginstall ulang dan meletakkan folder tersebut di user agar tools tersebut dapat digunakan secara global, kemudian remove folder tersebut untuk menjaga tree sesuai ketentuan soal. 

## Revisi Pengerjaan	
	
### Soal_1	
Hasil output rata-rata usia dibulatkan ke bawah sehingga hasilnya bukan 38 namun 37, sehingga code ```%.0f``` diubah ```%d```	
Hasil output revisi menjadi:	
	
<img width="298" height="60" alt="image" src="https://github.com/user-attachments/assets/b6f0c8ca-ddc8-4add-86e2-961f475cf445" />	
	
### Soal_3	

#### 1. Konfigurasi Path
Mendefinisikan variabel global untuk lokasi file Data,Log, Rekap, dan Sampah untuk memudahkan pemeliharaan kode, jika folder datase berubah, cukup ganti di satu tempat. 

```bash
#!/bin/bash

Data="data/penghuni.csv"
Log="log/tagihan.log"
Rekap="rekap/laporan_bulanan.txt"
Sampah="sampah/history_hapus.csv"
```

#### 2. Cek Tagihan 

```bash
# Cek tagihan
if [[ "$1" == "--cek_tagihan" ]]; then
	timestamp=$(date "+%Y-%m-%d %H:%M:%S")
awk -F, -v t="$timestamp" '$5=="Menunggak" {
	printf "[%s] Tagihan: %s (Kamar %s) menunggak sewa Rp%s\n", t, $1, $2, $3
}' "$Data" >> "$Log"
exit 0
fi
```

Jika skrip dijalankan dengan kode ```--cek_tagihan```, sistem tidak menampilkan menu tetapi menggunakan awk untuk menyaring penghuni yang statusnya "Menunggak" dan mencatatnya ke file log beserta timestamp. Bagian ini dibuat khusus agar bisa dipanggil secara otomatis oleh cron job.

#### 3. Fungsi Show Banner

```bash
show_banner() {
clear
echo "=================================================="
echo "      K O S T   S L E B E W   A M B A T U K A M   "
echo "=================================================="
}
```

#### 4. Opsi 1: Tambah Penghuni

```bash
# opsi 1 (tambah penghuni, simpan data ke csv)
tambah_penghuni() {
show_banner
echo "       TAMBAH PENGHUNI    "
echo "=============================="

read -p "Masukkan nama: " nama
read -p "Masukkan kamar: " kamar

# nomor kamar harus unik
if [[ -f "$Data" ]] && grep -q ",$kamar," "$Data"; then
	echo -e "[X] Kamar $kamar sudah terisi!"
	read -p "Tekan ENTER untuk kembali ke menu"
	return
fi

read -p "Masukkan harga sewa: " harga_sewa
# harga sewa harus (+)
if [[ ! "$harga_sewa" =~ ^[0-9]+$ ]] || [ "$harga_sewa" -le 0 ]; then
	echo -e "[X] Angka harga sewa harus bernilai positif!"
	read -p "Tekan ENTER untuk kembali ke menu"
	return
fi

read -p "Masukkan tanggal masuk (YYYY-MM-DD): " tanggal
# pastiin format tangal sesuai dan tidak lebih dari hari ini
today=$(date +%Y%m%d)
input_date=$(echo "$tanggal" | tr -d '-')
if [[ ! "$tanggal" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || [ "$input_date" -gt "$today" ]; then
	echo -e "Tanggal tidak valid!"
	read -p "Tekan ENTER untuk kembali ke menu"
	return
fi


read -p "Masukkan status awal (Aktif/Menunggak): " status
# pastiin status sesuai (A/M)
if [[ ! "$status" =~ ^(Aktif|Menunggak)$ ]]; then
	echo -e "[X] Status harus "Aktif" atau "Menunggak"! "
	read -p "Tekan ENTER untuk kembali ke menu"
	return
fi

# simpan input ke database csv
echo "$nama,$kamar,$harga_sewa,$tanggal,$status" >> "$Data"
echo -e "[V] Penghuni \"$nama\" berhasil ditambahkan ke Kamar $kamar dengan status $status."
read -p "Tekan ENTER untuk kembali ke menu..."
}
```

```[[ -f "$Data" ]]``` mengecek jika file database sudah ada.

```grep -q ",$kamar,"``` mencari nomor kamar dalam file csv.

```if [[ ! "$harga_sewa" =~ ^[0-9]+$ ]] || [ "$harga_sewa" -le 0 ]``` memastikan input hanya berisi angka dan nilai tidak nol atau negatif.

```tr -d '-'``` menghapus tanda - pada tanggal (misal: 2026-03-29 jadi 20260329) untuk memudahkan logika tanggal yang melebihi tanggal hari ini. Dibandingkan melalui ```-gt "$today"```.

Jika semua input sesuai ketentuan, data digabungkan dan ditambahkan ke baris paling bawah dari file $Data dan ```>>``` memastikan data lama tidak terhapus. 

#### 5. Opsi 2: Hapus Penghuni

```bash
# opsi 2 (pindah ke sampah baru dihapus)
hapus_penghuni() {
show_banner
echo "       HAPUS PENGHUNI    "
echo "=============================="

read -p "Masukkan nama penghuni yang akan dihapus: " nama_hapus

if ! grep -qi "^$nama_hapus," "$Data"; then
	echo -e "[X] Data \"$nama_hapus\" tidak ditemukan!"
	read -p "Tekan ENTER untuk kembali ke menu"
	return
fi

data_lama=$(grep -i "^$nama_hapus," "$Data")
echo "$data_lama,$(date +%Y-%m-%d)" >> "$Sampah"

grep -vi "^$nama_hapus," "$Data" > "data/temp_penghuni.csv"
mv "data/temp_penghuni.csv" "$Data"

echo -e "[V] Data Penghuni \"$nama_hapus\" berhasil dihapus."
read -p "Tekan ENTER untuk kembali ke menu"
}
```

```grep -qi``` mencari nama secara case-insensitive (menganggap huruf kapital dan huruf kecil sama) tanpa menampilkan hasil di layar. 

Mengambil satu baris utuh data penghuni yang akan hapus dan diletakkan pada variabel ```data_lama```. Kemudian data tersebut dipindah ke file history_hapus.csv.

```-v``` (invert match) menyuruh grep mengambil semua baris kecuali baris yang berisi nama yang akan dihapus. Memindahkan salinan yang ingin dihapus ke file sementara (temp_penghuni.csv).

#### 6. Opsi 3: Tampilkan Daftar Penghuni

```bash
# opsi 3 (daftar penghuni)
tampilkan_daftar(){
show_banner
echo "     DAFTAR PENGHUNI KOST    "
echo "=============================="

if [ ! -s "$Data" ]; then
echo "Data penghuni masih kosong!"
read -p "Tekan ENTER untuk kembali ke menu"
return
fi

printf "%-5s | %-15s | %-5s | %-15s | %-12s\n" "No" "Nama" "Kamar" "Harga Sewa" "Status"
echo "------------------------------------------------------------------"
awk -F, 'BEGIN {a=0; m=0} {
printf "%-5s | %-15s | %-5s | Rp%-12s | %-12s\n", NR, $1, $2, $3, $5
if($5=="Aktif") {a++} else {m++}
}

END {
print "-----------------------------------------------------------------"
printf "Total: %d | Aktif %d | Menunggak: %d\n", NR, a, m
}' "$Data"
read -p "Tekan ENTER untuk kembali ke menu"
}
```

Operator ```-s``` untuk mengecek apakah file ada dan memiliki isi.

```BEGIN {a=0; m=0}``` dijalankan satu kali di awal sebelum membaca data, menginisialisasi variabel penghitung jumlah aktif dan menunggak.

```NR, $1, $2, $3, $5``` NR untuk mencetak nomor urut baris. $1, $2, $3, $5 untuk mengambil data nama, kamar, harga, dan status dari file csv.

#### 7. Opsi 4: Update Status

```bash
# opsi 4 (update status a/m)
update_status(){
show_banner
echo "        UPDATE STATUS    "
echo "=============================="
read -p "Masukkan nama penghuni: " update_nama

if ! grep -qi "^$update_nama," "$Data"; then
	echo -e "[X] Data Penghuni \"$update_nama\" tidak ditemukan!"
	read -p "Tekan ENTER untuk kembali ke menu"
	return
fi

read -p "Status baru (Aktif/Menunggak): " new_status

awk -F, -v u="$update_nama" -v n="$new_status" 'BEGIN {OFS=","} {
if(tolower($1) == tolower(u)) { $5=n }
	print $0
}' "$Data" > "data/temp.csv" && mv "data/temp.csv" "$Data"
echo "[V] Status diperbarui!";
read -p "Tekan ENTER untuk kembali ke menu"
}
```

```-v u="$update_nama"``` cara bash mengirim nilai variabel ke dalam awk.

```BEGIN {OFS=","}``` mengatur output field separator. awk akan mengubah spasi jika kita mengedit kolom agar format csv tidak rusak. 

```tolower($1) == tolower(u)``` logika case insensitive untuk meminimalisir error jika salah input.

#### 8. Opsi 5: Cetak Laporan Keuangan

```bash
# opsi 5 (laporan keuangan)
laporan_keuangan() {
show_banner
echo "       LAPORAN KEUANGAN    "
echo "=============================="
awk -F, '
BEGIN {p=0; t=0} {
if($5=="Aktif") p+=$3; else t+=$3
}
END {
printf "Pemasukan (Aktif) : Rp%d\n", p
printf "Tunggakan         : Rp%d\n", t
print "-------------------------------------------"

printf "Laporan %s | Masuk: Rp%d | Tunggak: Rp%d\n", strftime("%Y-%m-%d"), p, t > "rekap/laporan_bulanan.txt"
}' "$Data"

echo "Laporan disimpan di rekap"
read -p "Tekan ENTER untuk kembali ke menu"
}
```

```BEGIN {p=0; t=0}``` sebelum awk membaca, menginisialisasi variabel untuk pemasukan dan tunggakan dimulai dari angka 0. 

```if($5=="Aktif") p+=$3; else t+=$3``` jika status "Aktif", nilai di kolom harga sewa ($3) ditambahkan ke variabel p, jika bukan (Menunggak) ditambahkan ke t.

```strftime``` fungsi internal awk untuk mengambil tanggal sistem saat laporan dicetak. 

#### 9. Opsi 6: Kelola Cron

```bash
# opsi 6 (Kelola Cron (Pengingat tahigan)
kelola_cron() {
while true; do
show_banner
echo "1. Lihat Cron | 2. Tambah | 3. Hapus | 4. Kembali"
read -p "Pilih: " pilih
case $pilih in
1) crontab -l | grep "kost_slebew.sh"
read -p "Tekan ENTER untuk kembali ke menu";;
2) read -p "Jam (0-23): " h; read -p "Menit (0-59): " m
path=$(realpath "$0")
(crontab -l 2>/dev/null | grep -v "$path";
echo "$m $h * * * $path --cek_tagihan") | crontab -
echo "Cron ditambahkan!"
read -p "Tekan ENTER untuk kembali ke menu";;
3) crontab -l | grep -v "kost_slebew.sh" | crontab -
echo "Cron dihapus!"
read -p "Tekan ENTER untuk kembali ke menu" ;;
4) break ;;

esac
done
}
```

```realpath "$0"``` mengambil alamat lengkap dari skrip ```kost_slebew.sh``` agar cron job bisa menemukan file nya. 

```2>/dev/null``` menghilangkan pesan error jika user belum punya jadwal cron sama sekali. 

```| crontab -``` mengirim seluruh teks kembali ke sistem crontab untuk diaktifkan. 

```crontab -l | grep -v "kost_slebew.sh" | crontab -``` mengambil semua jadwal, membuang barus yang mengandung nama skrip, lalu disimpan kembali. 

#### 10. Menu utama dan opsi 7

```bash
while true; do
show_banner
echo " ID | OPTION"
echo "--------------------------------------------------"
echo " 1 | Tambah Penghuni Baru"
echo " 2 | Hapus Penghuni"
echo " 3 | Tampilkan Daftar Penghuni"
echo " 4 | Update Status Penghuni"
echo " 5 | Cetak Laporan Keuangan"
echo " 6 | Kelola Cron (Pengingat tahigan)"
echo " 7 | Exit Program"
echo "--------------------------------------------------"
read -p "Enter option (1-7): " option

case $option in
1) tambah_penghuni ;;
2) hapus_penghuni ;;
3) tampilkan_daftar ;;
4) update_status ;;
5) laporan_keuangan ;;
6) kelola_cron ;;
7) exit 0;;
*) echo "Salah input!"; sleep 1 ;;

esac
done
```

Double semicolon (;;) penanda akhir dari satu blok pilihan agar bash tidak terus menjalankan perintah di bawahnya. 

```7) exit 0;;``` mematikan skrip, angka 0 sebagai kode status standar di Linux yang memberitahu sistem operasi untuk mengentikan program dan tidak ada error yang terjadi. Logika ini sebagai cara untuk break perulangan while true. 

```*) echo "Salah input!"; sleep 1 ;;``` simbol * untuk menangkap semua input selain angka 1-7. sleep 1 untuk memberi jeda 1 detik agar user membaca ```echo "Salah input!"``` sebelum layar dibersihkan oleh ```show_banner```.

#### 11. Hasil output
Hasil output pada opsi 1 jika input sesuai ketentuan:

<img width="422" height="163" alt="Screenshot 2026-03-29 202314" src="https://github.com/user-attachments/assets/bb734e7c-e5f1-4100-86f3-11ab2e7d8c33" />

Hasil output pada opsi 2 jika nama yang ingin dihapus ada di data:

<img width="302" height="105" alt="image" src="https://github.com/user-attachments/assets/197cc97e-0aaa-430b-a009-73dfee086aeb" />

Hasil output opsi 3:

<img width="382" height="165" alt="image" src="https://github.com/user-attachments/assets/2723755b-2c7a-42b4-8e60-a5db88b49857" />

Hasil output opsi 4 jika nama yang ingin di-update ada di data:

<img width="306" height="126" alt="image" src="https://github.com/user-attachments/assets/b536c253-34d8-45c0-846d-061c8b27dd21" />

<img width="378" height="163" alt="image" src="https://github.com/user-attachments/assets/5db3cfce-0e90-4095-8cd5-3c1c4731a6cd" />

Hasil output opsi 5:

<img width="296" height="127" alt="image" src="https://github.com/user-attachments/assets/c86107f2-bef1-4040-8139-84ebcd20ff93" />

Hasil output opsi 6: 

<img width="304" height="115" alt="image" src="https://github.com/user-attachments/assets/c42f6196-be40-4ae0-aed8-a3528439397a" />

<img width="337" height="92" alt="image" src="https://github.com/user-attachments/assets/407fd41e-a2ac-492f-8c9a-c6b86cf34f0a" />

Hasil output cek_tagihan:

Command ```./kost_slebew.sh --check-tagihan```,

<img width="390" height="93" alt="image" src="https://github.com/user-attachments/assets/3b82315c-909f-42e3-92fc-68c31aa7eb8d" />

#### 12. Kendala
