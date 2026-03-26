#1/bin/bash

Data="data/penghuni.csv"
Log="log/tagihan.log"
Rekap="rekap/laporan_bulanan.txt"
Sampah="sampah/history_hapus.csv"

show banner() {
clear
echo "=================================================="
echo "      K O S T   S L E B E W   A M B A T U K A M   "
echo "=================================================="
}

# Looping pilihan
while true; do
show_banner
echo " ID | OPTION"
echo "--------------------------------------------------"
echo " 1 | Tambah Penghuni Baru"
echo " 2 | Hapus Penghuni"
echo " 3 | Tampilkan Daftar Penghuni"
echo " 4 | Update Status Penghuni"
echo " 5 | Cetak Laporan Keuangan"
echo " 6 | Kelola Corn (Pengingat tahigan)"
echo " 7 | Exit Program"
echo "--------------------------------------------------"
read -p "Enter option (1-7): " option

# opsi 1 (tambah penghuni, simpan data ke csv
tambah_penghuni() {
show_banner
echo "       TAMBAH PENGHUNI    "
echo "=============================="

read -p "Masukkan nama: " nama

read -p "Masukkan kamar: " kamar
# nomor kamar harus unik
if [[ -f "$Data"]] && grep -q ",$kamar," "$Data"; then
echo -e "[X] Kamar $kamar sudah terisi!"
read -p "Tekan ENTER untuk kembali ke menu"
return
fi

read -p "Masukkan harga sewa: " harga_sewa
# harga sewa harus (+)
if [[ ! "$harga_sewa" =~ ^[0-9]+$ ]] || [ "$harga_sewa" -le 0]; then
echo -e "[X] Angka harga sewa harus bernilai positif!"
read -p "Tekan ENTER untuk kembali ke menu"
return
fi

read -p "Masukkan tanggal masuk (YYYY-MM-DD): " tanggal
# pastiin format tangal sesuai dan tidak lebih dari hari ini
if [[ !  "$tanggal" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
echo -e "[X] Format tanggal harus sesuai (YYYY-MM-DD)!"
read -p "Tekan ENTER untuk kembali ke menu"
return
fi
today+$(date +%Y%m%d)
input_date=$(echo "$tanggal" | tr -d '-')
if [ $"$input_date" -gt "$today"]; then
echo -e "[X] Tanggal tidak boleh lebih dari tanggal hari ini!"
read -p "Tekan ENTER untuk kembali ke menu"
return
fi

readi -p "Masukkan status awal (Aktif/Menunggak): " status
# pastiin status sesuai (A/M)
if [[ ! "$status" =~ ^(Aktif|Menunggak)$ ]]; then
echo -e "[X] Status harus "Aktif" atau "Menunggak"! "
read -p "Tekan ENTER untuk kembali ke menu"
return
fi

# simpan input ke database csv
echo "$nama,$kamar,$harga_sewa,$tanggal,$status" >> "$Data"
echo -e "[V] Penghuni \"$nama\" berhasil ditambahkan ke Kamar $kamar dengan status $status."
read -p "Tekan [ENTER] untuk kembali ke menu..."
}

case $option in
1) tambah penghuni ;;
2) 
