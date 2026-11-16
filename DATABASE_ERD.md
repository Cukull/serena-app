# Floréa — Database ERD

> Status: Aktif — 8 tabel `public` setelah migrasi `0002_remove_wellness.sql` (wellness & habit dihapus)
> DB: PostgreSQL (Supabase) | Auth: Supabase Auth (`auth.users`)

## 1. Aturan Global

1. Semua tabel user-data punya `user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE`.
2. Semua tabel pakai `id UUID PRIMARY KEY DEFAULT gen_random_uuid()`.
3. Waktu simpan UTC (`timestamptz`), tampilkan waktu lokal via `intl`.
4. RLS aktif di semua tabel user-data. Policy inti: user hanya CRUD miliknya sendiri.
5. `created_at timestamptz DEFAULT now()`, `updated_at` diupdate via trigger (lihat SCHEMA).

## 2. ERD (Mermaid)

```mermaid
erDiagram
    AUTH_USERS ||--o| PROFILES : has
    PROFILES ||--o{ USER_GOALS : owns
    PROFILES ||--o{ TASK_CATEGORIES : owns
    PROFILES ||--o{ TASKS : owns
    TASK_CATEGORIES ||--o{ TASKS : groups
    PROFILES ||--o{ FOCUS_SESSIONS : owns
    PROFILES ||--o{ NOTIFICATIONS : owns
    PROFILES ||--o{ USER_ACHIEVEMENTS : unlocks
    ACHIEVEMENTS ||--o{ USER_ACHIEVEMENTS : grants

    AUTH_USERS {
        uuid id PK
    }
    PROFILES {
        uuid id PK_FK
        text email
        text full_name
        text avatar_url
        bool onboarding_completed
    }
    USER_GOALS {
        uuid id PK
        uuid user_id FK
        text title
        date target_date
        bool is_completed
    }
    TASK_CATEGORIES {
        uuid id PK
        uuid user_id FK
        text name
        text color
    }
    TASKS {
        uuid id PK
        uuid user_id FK
        uuid category_id FK
        text title
        timestamptz deadline
        text priority
        text status
        int progress
    }
    FOCUS_SESSIONS {
        uuid id PK
        uuid user_id FK
        text mode
        int planned_minutes
        int actual_minutes
        text status
    }
    NOTIFICATIONS {
        uuid id PK
        uuid user_id FK
        text type
        text title
        timestamptz scheduled_for
        bool is_read
    }
    ACHIEVEMENTS {
        uuid id PK
        text code
        text title
    }
    USER_ACHIEVEMENTS {
        uuid user_id FK
        uuid achievement_id FK
        timestamptz unlocked_at
    }
```

## 2a. Gambar ERD untuk Laporan

- **Hasil gambar:** `DATABASE_ERD.png` (3570×1557 px, siap tempel di laporan)
- **Sumber diagram:** `serena/supabase/erd.mmd` (Mermaid)
- **Versi DBML:** `DATABASE_ERD.dbml`
- **Render ulang setelah edit:** `python serena/supabase/render-erd.py`

### Tempat generate gambar relasi

Supabase Studio tidak punya fitur "Designer" seperti phpMyAdmin, jadi pakai salah satu:

| Tool | Cara | Cocok untuk |
|------|------|-------------|
| **dbdiagram.io** | Buka <https://dbdiagram.io/d>, tempel isi `DATABASE_ERD.dbml`, atur posisi tabel, lalu **Export → PNG/PDF** | Paling mirip contoh phpMyAdmin, bisa atur layout |
| **drawsql.app** | Import DBML yang sama, export PNG | Alternatif online |
| **DBeaver** | Connect ke Postgres Supabase → klik schema `public` → **ER Diagram** → export PNG | Langsung dari DB asli |
| **pgAdmin 4** | Klik kanan database → **ERD For Database** | Langsung dari DB asli |
| **Mermaid Live** | Buka <https://mermaid.live>, tempel isi `erd.mmd`, **Actions → PNG** | Cepat, tanpa install |

Untuk DBeaver/pgAdmin, ambil connection string dari Supabase Dashboard → **Project Settings → Database → Connection string** (pakai mode Session/URI + password DB).

## 3. Relasi per Fitur

- **Planner:** profiles → task_categories → tasks. Task tanpa kategori diizinkan (`category_id NULL`).
- **Focus:** langsung ke profiles (tidak ada tabel anak). Statistik via agregasi tanggal.
- **Notification:** milik user, `related_id` opsional menunjuk task (tanpa FK keras agar fleksibel).
- **Achievement:** master `achievements` (seed) + `user_achievements` (composite PK).

## 4. Enums (Postgres)

```text
task_priority: low | medium | high | urgent
task_status: pending | in_progress | completed | cancelled
focus_mode: pomodoro | deep_focus | exam_mode
focus_status: active | paused | completed | cancelled
notification_type: task | deadline | focus_break
```

Dibuat via `CREATE TYPE ... AS ENUM`. Detail kolom lihat `DATABASE_SCHEMA.md`.

## 5. Indeks Wajib

```text
tasks(user_id, deadline)
tasks(user_id, status)
focus_sessions(user_id, started_at DESC)
notifications(user_id, scheduled_for)
```

## 6. Validasi Sebelum Migrasi

- [ ] ERD disetujui tim
- [ ] Enum final (tidak tambah-ubah seenaknya setelah seed)
- [ ] RLS policy per tabel dicek (lihat SCHEMA)
- [ ] Seed `achievements` awal disepakati
