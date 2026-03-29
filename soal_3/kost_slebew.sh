#!/bin/bash

Data="data/penghuni.csv"
Log="log/tagihan.log"
Rekap="rekap/laporan_bulanan.txt"
Sampah="sampah/history_hapus.csv"


# Cek tagihan
if [[ "$1" == "--cek_tagihan" ]]; then
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
awk -F, -v t="$timestamp" '$5=="Menunggak" {
printf "[%s] Tagihan: %s (Kamar %s) menunggak sewa Rp%s\n", t, $1, $2, $3
}' "$Data" >> "$Log"
exit 0
fi

show_banner() {
clear
echo "=================================================="
echo "      K O S T   S L E B E W   A M B A T U K A M   "
echo "=================================================="
}

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
