# Serena — Design System

Sumber kebenaran tampilan Serena. Semua layar baru mengikuti dokumen ini.
Referensi visual asli ada di `referensi/`:

- `profile (1).html` → tab **Profil**
- `info-pribadi.html` → halaman **Info Pribadi**
- `keamanan-privasi.html` → halaman **Keamanan & Privasi**

Implementasi token: `lib/core/theme/app_colors.dart`,
`lib/core/theme/app_typography.dart`, `lib/core/theme/app_spacing.dart`.
Komponen bersama: `lib/core/widgets/app_ui.dart`.

---

## 1. Arah desain

- **Tenang, lembut, personal.** Latar gradien lavender → biru → mint dengan
  dua blob warna yang di-blur. Tidak ada garis tegas; pemisah memakai
  permukaan putih dan bayangan tipis.
- **Satu aksen kuat per layar.** Violet untuk aksi, biru untuk angka/skor,
  hijau untuk status aman, merah hanya untuk zona bahaya.
- **Kartu, bukan tabel.** Semua informasi dikelompokkan dalam kartu putih
  radius 20 dengan judul bagian huruf kapital di atasnya.
- **Font:** Plus Jakarta Sans untuk seluruh UI, DM Serif Display hanya untuk
  judul halaman turunan (Info Pribadi, Keamanan & Privasi).

---

## 2. Warna

### 2.1 Inti

| Token | Hex | Pemakaian |
|---|---|---|
| `primary` | `#7C6BF0` | Aksi, tautan, switch aktif, item nav aktif |
| `primaryDark` | `#5A49C9` | Teks di atas tint violet |
| `primaryTint` | `#EDE9FE` | Latar chip/tile violet |
| `secondary` | `#4F9BE8` | Angka skor, aksen dingin |
| `secondaryDark` | `#2F6DB5` | Teks pill Edit |
| `secondaryTint` | `#E3F0FD` | Latar pill Edit, tile biru |
| `accent` | `#2BAE8E` | Status aman, progress aman |
| `accentDark` | `#1F7A58` | Teks status aman |
| `accentTint` | `#DFF3EA` | Latar status aman |
| `danger` | `#E5646B` | Tombol destruktif, label zona bahaya |
| `dangerDark` | `#C2444C` | Teks tombol/baris destruktif |

### 2.2 Teks

| Token | Hex | Pemakaian |
|---|---|---|
| `textPrimary` | `#1B2340` | Judul, nilai field |
| `textStrong` | `#2B3A67` | Teks tebal sekunder (ikon shield) |
| `textMuted` | `#6B7391` | Subjudul, label field, ikon pasif |
| `textFaint` | `#8C93AE` | Judul bagian, caption |
| `textOnGradient` | `#FFFFFF` | Teks di atas gradien |

### 2.3 Permukaan

| Token | Hex | Pemakaian |
|---|---|---|
| `white` | `#FFFFFF` | Kartu, sheet, nav |
| `glassInput` | `#FAFBFF` | Latar input |
| `glassBadge` | `#F1F3FA` | Tombol tutup, tombol ghost |
| `divider` | `#E6E9F5` | Garis antar baris, track netral |
| `bgCream` | `#F5F3FF` | Scaffold (fallback latar) |

### 2.4 Status & chip

| Kelompok | Latar | Border | Teks |
|---|---|---|---|
| Aman | `#D6F2E4` | `#B5E3CE` | `#1F7A58` |
| Peringatan | `#FFE9D6` | `#F8CDB0` | `#B5581F` |
| Chip biru | `#E3F0FD` | `#BBD8F7` | `#2F6DB5` |
| Chip violet | `#EDE9FE` | `#D2C8FA` | `#5A49C9` |
| Chip hijau | `#DFF3EA` | `#B5E3CE` | `#1F7A58` |
| Chip peach | `#FFEBDD` | `#F8CDB0` | `#B5581F` |
| Zona bahaya | `#FFF6F6` | `#F6CFD2` | `#C2444C` |

Tile ikon: biru `#E7EEFD`, violet `#EDE9FE`, peach `#FFEBDD`,
hijau `#DFF3EA`, merah `#FFE3E5`.

### 2.5 Gradien

| Token | Nilai | Pemakaian |
|---|---|---|
| `gradientBackground` | `#F5F3FF` → `#EAF4FD` (38%) → `#EFFAF4`, atas→bawah | Latar semua layar |
| `profileGradient` | `#8B5CF6` → `#5B8DEF` (52%) → `#2DD4BF`, kiri-atas→kanan-bawah | Kartu hero profil |
| `avatarGradient` | `#FFB88C` → `#E58AB8` | Avatar inisial |
| `avatarRingGradient` | `#FFB88C` → `#8FB8F5` | Ring avatar Info Pribadi |
| `primaryGradient` | `#6FB4F2` → `#7C6BF0`, kiri-atas→kanan-bawah | Tombol utama, nav aktif |
| `progressGradient` | `#4F9BE8` → `#34C3A8` | Bar skor keamanan |

Blob latar: violet `#C9BDFB` (opacity 0.7, kanan atas, 240px) dan
cyan `#B7E6F4` (opacity 0.55, kiri tengah, 220px), memakai radial gradient
ke transparan.

---

## 3. Tipografi

Plus Jakarta Sans (400/500/600/700/800) + DM Serif Display (400).

| Peran | Ukuran | Berat | Token |
|---|---|---|---|
| Judul tab ("Profil") | 26 | 800 | `AppTypography.h1` |
| Judul halaman turunan | 27 | 400 serif | `AppTypography.pageTitle` |
| Judul sheet | 20 | 800 | `h3.copyWith(fontSize: 20)` |
| Nama di kartu hero | 21 | 800 | `h3.copyWith(fontSize: 21)` |
| Nama di Info Pribadi | 19 | 800 | `fieldValue.copyWith(fontSize: 19)` |
| Judul baris / kartu | 15–16 | 700 | `fieldValue`, `cardTitle` |
| Label field | 12–13 | 400/700 | `fieldLabel`, `label` |
| Subjudul baris | 13 | 400 | `subtitle` |
| Judul bagian | 12 | 700, tracking 0.96 | `sectionLabel` (HURUF KAPITAL) |
| Tautan aksi | 13 | 700 | `actionLink` (violet) |
| Chip | 13 | 600 | `chipLabel` |
| Angka statistik | 18–20 | 800 | `statBig` |
| Teks tombol | 15 | 800 | `button` |

Aturan:
- Huruf kapital hanya untuk judul bagian (`INFO DASAR`, `KEAMANAN AKUN`,
  `ZONA BAHAYA`).
- Jangan pakai serif di dalam kartu — serif hanya judul halaman.
- Maksimal tiga ukuran teks per kartu.

---

## 4. Spasi, radius, bayangan

**Spasi** (kelipatan 2): 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 28.
Padding layar: 20 kiri-kanan, 14–20 atas, 40 bawah (daftar panjang: 120
karena nav mengambang). Jarak antar bagian: 20–22.

**Radius**

| Elemen | Radius |
|---|---|
| Kartu, baris menu, sheet-list | 20 |
| Kartu statistik | 18 |
| Tombol utama / input | 18 / 14 |
| Kartu hero profil | 44 kiri-atas & kanan-bawah, 18 lainnya |
| Pill Edit / status | 19 / 14 |
| Chip | 12 |
| Nav mengambang / sheet | 30 |
| Tile ikon | 11–12 |
| Switch | 16 |

**Bayangan**

| Elemen | Nilai |
|---|---|
| Kartu | `0 4 14 rgba(60,70,130,.07)` → `Color(0x123C4682)` |
| Baris menu / icon button | `0 2 8 rgba(60,70,130,.10)` |
| Nav mengambang | `0 10 28 rgba(60,70,130,.14)` |
| Hero profil | `0 16 32 rgba(91,141,239,.35)` |
| Tombol utama | `0 8 16 rgba(124,107,240,.30)` |
| Nav aktif | `0 8 16 rgba(124,107,240,.35)` |

Tidak ada border pada kartu biasa. Border hanya untuk zona bahaya,
pill, chip, tombol keluar, dan input.

---

## 5. Komponen

### 5.1 Latar (`SerenaBackground`)
Gradien vertikal + dua blob radial. Semua layar memakai widget ini, bukan
`Scaffold` warna solid.

### 5.2 Header halaman
- **Tab:** judul `h1` + subjudul 14 muted di kiri, tombol bulat putih 44
  dengan ikon pensil di kanan.
- **Halaman turunan:** tombol kembali bulat 44 + judul serif `pageTitle`
  (mengisi sisa lebar) + opsional pill `Edit` (38 tinggi, radius 19,
  `#E3F0FD`, border `#CFE3F8`, teks `#2F6DB5` 13/700).

### 5.3 Kartu hero profil
Gradien `profileGradient`, radius asimetris 44/18, padding 28×22, teks putih
tengah. Sorot putih radial di kanan atas. Isi: avatar 84 (gradien
`avatarGradient`, border putih 3, inisial 30/800), badge kamera putih 30,
nama 21/800, email 14 (putih 92%), lalu 3 kotak mini
(`rgba(255,255,255,.22)`, border `rgba(255,255,255,.4)`, radius 16,
nilai 18/800, label 11.5).

### 5.4 Kartu daftar
Putih, radius 20, padding horizontal 14, vertikal 2. Baris: tile 42 + gap 14
+ (judul 15/700, subjudul 13 muted) + trailing. Garis `divider` 1px antar
baris, kecuali baris terakhir. Seluruh baris dapat diklik bila ada aksi.

Trailing: chevron 22 `textMuted`, badge (`Atur` peringatan / `Aktif` aman),
atau `AppSwitch`. Baris statis pakai switch; baris beraksi pakai chevron.

### 5.5 Tile ikon
42×42, radius 12, latar tint, isi emoji 18 atau ikon Lucide 18–22.
Menu utama boleh memakai tile gradien 44×44 radius 11 dengan ikon putih.

### 5.6 Chip minat
Radius 12, padding 7×12, border 1px, teks 13/600. Warna berputar
biru → violet → hijau → peach. Mode edit menampilkan `✕` di kanan chip.
Kartu pembungkus: putih radius 20, padding 14, `Wrap` gap 8.

### 5.7 Switch
52×32, track `#CDD2E4` → `primary` saat aktif, thumb putih 26 dengan
bayangan `0 2 4 rgba(0,0,0,.2)`, animasi 200 ms.

### 5.8 Tombol
| Varian | Tampilan |
|---|---|
| Primary | tinggi 52, radius 18, gradien `primaryGradient`, teks putih 15/800, bayangan violet |
| Ghost | tinggi 52, radius 18, latar `#F1F3FA`, teks `textPrimary` |
| Danger | tinggi 52, radius 18, latar `#E5646B`, teks putih |
| Keluar | tinggi 52, radius 20, latar `#FFF1F2`, border 1.5 `#F2A2AA`, teks `#C2444C` 15/800 |

### 5.9 Kartu ringkasan skor
Kartu putih padding 16. Baris atas: judul 15/800 + angka 28/800 `secondary`
+ `/100` 13 muted. Bar 8px radius 4, track `#E8EDF7`, isi gradien
`progressGradient` selebar skor. Checklist: lingkaran 22 border 2 (hijau
`✓` / oranye `!`), teks 14/600; item gagal memakai `#B5581F`.

### 5.10 Bottom sheet
Putih, radius atas 30, padding 12/20/24 + inset keyboard, overlay
`rgba(27,35,64,.45)`, animasi naik 250 ms. Isi: grabber 40×5 `#E6E9F5`,
judul 20/800 + tombol tutup bulat 40 `#F1F3FA`, lalu konten dan tombol.

### 5.11 Nav bawah mengambang
Putih, radius 30, margin 16, padding 10×12, bayangan nav. Lima item sama
lebar; item aktif memakai gradien `primaryGradient`, radius 20, teks/ikon
putih; pasif `textMuted`. Ikon 22, label 11/600.

### 5.12 Toast
Snackbar gelap `#1B2340`, teks putih 14/600, radius 16, durasi 2,2 detik.
Selalu menggantikan toast sebelumnya.

---

## 6. Layar

### 6.1 Profil (tab)
Urutan: header → kartu hero → judul bagian "Pengaturan" → dua baris menu
berikon gradien ("Pengaturan profil", "Keamanan & privasi") → tombol
"Keluar dari akun" → sheet konfirmasi keluar.

Statistik hero: `12` Tugas selesai · `14j` Waktu fokus · `12` Hari beruntun.

### 6.2 Info Pribadi
Urutan: header (kembali, serif, pill Edit/Simpan) → avatar 104 dengan ring
gradien + badge kamera 32 → nama 19/800 → "Mahasiswa · Jurusan" → tautan
"Ganti foto" → tiga kartu statistik → tiga bagian:
`INFO DASAR` (nama, email, telepon, tanggal lahir),
`INFO AKADEMIK` (universitas, jurusan, NIM),
`MINAT & VIBES` (chip + "+ Tambah").

Mode edit: nilai berubah menjadi input; semua judul bagian menampilkan
"Ubah"; pill header menjadi "Simpan"; tombol `Simpan perubahan` + `Batal` di
bawah. Validasi: nama wajib, email berpola `nama@email.com`, telepon
`^\+?[0-9\s-]{8,16}$`. Gagal simpan → pesan di bawah field terkait.

### 6.3 Keamanan & Privasi
Urutan: header (kembali + serif) → hero (shield 78, judul, penjelasan, pill
"Skor keamanan: 85/100") → kartu ringkasan (angka, bar, checklist) →
`KEAMANAN AKUN` (ubah kata sandi, verifikasi dua langkah, login biometrik,
sesi aktif) → `ZONA BAHAYA` (nonaktifkan akun, hapus akun).

Skor: kata sandi 25 + email 25 + biometrik 20 + dua langkah 15 +
privasi 15 = maksimal 100. ≥ 75 dianggap aman (pill hijau, judul
"Akunmu aman"), di bawahnya peringatan.

Aksi: ubah kata sandi (sheet 3 field + validasi minimal 8 karakter),
verifikasi dua langkah (sheet switch), sesi aktif (sheet daftar perangkat),
nonaktifkan/hapus akun (sheet konfirmasi destruktif).

---

## 7. Gerak & aksesibilitas

- Durasi transisi 180–250 ms, kurva default; tidak ada animasi dekoratif
  berulang.
- Target sentuh minimal 44×44. Baris kartu minimal 68 tinggi.
- Setiap tombol ikon punya `semanticLabel`; switch memakai `Semantics`
  bertanda `toggled`.
- Kontras teks utama `#1B2340` di atas putih ≥ 12:1; teks muted hanya untuk
  informasi sekunder ≥ 13px.
- Hormati `prefers-reduced-motion`: jangan tambah animasi yang tidak perlu.

---

## 8. Peta implementasi

| Bagian | Berkas |
|---|---|
| Token warna & gradien | `lib/core/theme/app_colors.dart` |
| Skala teks | `lib/core/theme/app_typography.dart` |
| Latar, kartu, baris, switch, tombol, sheet, toast | `lib/core/widgets/app_ui.dart` |
| Tab Profil | `lib/features/profile/profile_page.dart` |
| Info Pribadi | `lib/features/profile/edit_profile_page.dart` |
| Keamanan & Privasi | `lib/features/profile/settings_page.dart` |
| Nav bawah mengambang | `lib/app/main_shell.dart` |
| Tema global Material | `lib/core/theme/app_theme.dart` |

## 9. Jangan

- Jangan hardcode hex di widget; tambah token di `app_colors.dart`.
- Jangan pakai `Card`/`ListTile` bawaan Material — pakai `AppCard` dan
  `AppCardRow` agar radius, padding, dan bayangan konsisten.
- Jangan menaruh dua tombol utama bersebelahan; satu primary per layar.
- Jangan memakai warna bahaya untuk hal yang tidak destruktif.
- Jangan menambah gradien baru di luar daftar token.

## 10. Batasan saat ini

- Data profil, minat, dan status keamanan masih lokal di halaman
  (`shortcut:` di kode). Sambungkan ke Supabase saat repository tersedia.
- Tombol "Ganti foto", nonaktifkan akun, dan hapus akun baru menampilkan
  toast/sheet — belum memanggil backend.
