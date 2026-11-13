# 🌸 Serena Web — Modular Frontend Architecture

Projek web frontend modular untuk **Serena** (*Balance Your Mind, Study & Life*), hasil refactoring bersih dan semantik dari ekspor Figma to HTML.

---

## 📁 Struktur Direktori Folder

Projek telah diatur secara rapi, modular, dan mengikuti *clean code architecture*:

```text
serena-app/
└── serena-web/
    ├── index.html                  # Entry point utama aplikasi (live SPA, interaktif & responsif)
    ├── package.json                # Konfigurasi skrip opsional (dev server)
    ├── README.md                   # Dokumentasi struktur & panduan pemakaian
    │
    ├── assets/
    │   ├── css/
    │   │   ├── variables.css       # Design tokens Figma (warna gradien, font, shadow, radius)
    │   │   ├── base.css            # CSS reset & import Plus Jakarta Sans + Playfair Display
    │   │   └── layout.css          # Frame 390px mobile, ambient glow orbs & scroll container
    │   ├── js/
    │   │   └── app.js              # Routing SPA, Focus Timer, Jam real-time, Grafik statistik dinamis
    │   └── icons/                  # Aset ikon SVG
    │
    ├── components/                 # Komponen modular terpisah (CSS + HTML template)
    │   ├── status-bar/             # Jam 9:41, sinyal seluler 4 bar, indikator baterai
    │   ├── app-header/             # Logo Serena (glassmorphic), notifikasi unread, avatar SA
    │   ├── focus-banner/           # Hero card: "Sedang fokus", timer 18:42, tombol "Jeda Fokus"
    │   ├── daily-stats/            # 3 kartu statistik (Tugas tersisa, Waktu fokus, Selesai)
    │   ├── upcoming-deadline/      # Tenggat Terdekat: progress bar & badge Segera / LMS
    │   ├── daily-agenda/           # Timeline agenda (Kuliah UI/UX Design & Kumpulkan Tugas)
    │   ├── bottom-nav/             # Floating dock navigasi bawah (Beranda, Jadwal, Fokus, Akun)
    │   ├── detail-tugas/           # Detail card tugas (sisa waktu countdown, info grid, catatan)
    │   ├── detail-jadwal/          # Detail card jadwal kuliah (ruang, dosen, pengingat, tugas terkait)
    │   └── statistik-view/         # Grafik statistik interaktif (Harian, Mingguan, Bulanan)
    │
    └── pages/                      # Halaman-halaman mandiri
        ├── home/                   # Halaman Beranda lengkap
        │   ├── index.html
        │   └── home.css
        ├── detail-tugas/           # Halaman mandiri Detail Tugas
        │   └── index.html
        ├── detail-jadwal/          # Halaman mandiri Detail Jadwal Kuliah
        │   └── index.html
        ├── statistik/              # Halaman mandiri Statistik (Harian, Mingguan, Bulanan)
        │   └── index.html
        ├── jadwal/                 # Halaman Jadwal Kuliah & Planner
        │   └── index.html
        ├── fokus/                  # Halaman Mode Sesi Fokus
        │   └── index.html
        └── akun/                   # Halaman Akun & Profil Mahasiswa
            └── index.html
```

---

## 🎯 Aturan Navigasi Interaktif (*Routing Rules*)

Berdasarkan instruksi, semua kartu di Beranda (`home`) dapat diklik untuk langsung mengarahkan pengguna ke halaman/tampilan terkait:

| Elemen di Beranda (Home) | Aksi Klik | Tujuan Tampilan |
|---|---|---|
| **Kartu Tenggat Terdekat** | Klik kartu `Tugas Web Development` | Menuju ke **Detail Tugas** (Sisa waktu 06j 12m, batas waktu, unggah LMS, catatan tugas) |
| **Agenda: Kumpulkan Tugas** | Klik item agenda tugas | Menuju ke **Detail Tugas** |
| **Agenda: Kuliah UI/UX** | Klik item `Kuliah UI/UX Design` | Menuju ke **Detail Jadwal Kuliah** (09:00–11:00, Room E12, Dosen, pengingat, tugas hari ini) |
| **Header / Kartu Statistik** | Klik header `Statistik Harian` atau salah satu dari 3 kartu | Menuju ke **Statistik Belajar** (Grafik dinamis dengan tab Harian, Mingguan, Bulanan) |
| **Tab Navigasi: Jadwal** | Klik tab `Jadwal` di bottom dock | Menuju ke **Dasbor Perencana & Jadwal Mingguan** |
| **Tombol (+) di Jadwal** | Klik ikon `+` di kanan atas header jadwal | Menuju ke form **Tambahkan Tugas Baru** |
| **Tombol [Konfirmasi]** | Klik tombol `Konfirmasi` pada kartu Batas Waktu | Menuju ke alur **Konfirmasi Pengumpulan** & **Terkonfirmasi** |
| **Tombol [Nanti]** | Klik tombol `Nanti` pada kartu tugas | Menuju ke alur **Tunda Tugas** & **Penundaan Tersimpan** |
| **Tombol [Mulai Fokus] / [Lanjutkan]** | Klik tombol fokus pada kartu tugas | Menuju ke mode **Sesi Tugas (Timer Pomodoro Interaktif)** |
| **Tombol Kembali** | Klik tombol `Kembali` atau panah `←` | Kembali secara mulus ke tampilan sebelumnya |

---

## 📊 Fitur Statistik Interaktif (Harian, Mingguan, Bulanan)

Di dalam tampilan Statistik, pengguna dapat berpindah periode:
1. **Harian**: Menampilkan grafik 7 hari (Sel, Rab, Kam, Jum, Sab, Min, Sen) dengan skala 0–6, perbandingan vs hari sebelumnya (0%), tertinggi 6 tugas, rata-rata 4 tugas/hari.
2. **Mingguan**: Menampilkan grafik 6 minggu (29 Sep – 3 Nov) dengan skala 0–9, penurunan 40% vs minggu sebelumnya, tertinggi 7 tugas, rata-rata 5 tugas/minggu.
3. **Bulanan**: Menampilkan grafik 6 bulan (Jun – Nov) dengan skala 0–9, penurunan 43% vs bulan sebelumnya, tertinggi 9 tugas, rata-rata 6,8 tugas/bulan.
4. **Filter Metrik**: Pengguna juga bisa memfilter antara *Tugas tersisa*, *Waktu fokus*, dan *Selesai*.

---

## 🚀 Cara Menjalankan

1. **Buka Langsung di Browser**:
   Cukup klik dua kali file [**`serena-web/index.html`**](file:///C:/Users/~SahaAkiraa~/Documents/Serena/serena-app/serena-web/index.html) melalui Google Chrome atau Microsoft Edge.
2. **Atau Menggunakan Local Server**:
   ```bash
   cd serena-web
   npx serve .
   ```
