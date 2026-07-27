# GDD_ONE_PAGER.md
## Nusantara Runner — Ringkasan Satu Halaman untuk Stakeholder

*(Dokumen ini untuk investor/stakeholder non-teknis. Untuk detail lengkap lihat `00_PRD.md` dan dokumen teknis lainnya.)*

---

**Judul**: Nusantara Runner (Working Title)
**Platform**: Roblox (PC, Mobile, Console)
**Genre**: Arcade Sports Simulator + Pet Collection
**Target Pemain**: Usia 8–15 tahun, penggemar genre "simulator" Roblox

---

## Konsep dalam Satu Kalimat
Pemain berlari keliling landmark ikonik Nusantara — dari Monas sampai Raja Ampat — sambil melatih stat, bersaing di leaderboard sosial ala Strava, dan berburu satwa endemik langka.

## Kenapa Ini Bisa Berhasil
- Menggabungkan 2 genre yang sudah terbukti populer di Roblox: **social fitness competition** (KOM/leaderboard) dan **pet collection** (koleksi & rarity).
- Diferensiasi lewat identitas budaya Indonesia yang belum banyak digarap kompetitor besar di genre ini.
- Loop inti (Train → Race → Hunt → Upgrade) sederhana untuk dipahami dalam < 2 menit pertama.

## Loop Gameplay Inti
```
Latihan di Gym (naikkan stat)
      ↓
Ikut Race / Kejar Rekor Segment
      ↓
Berburu Pet Langka di Trail
      ↓
Menang Cash/Rubies → Upgrade Gear
      ↓ (kembali ke atas)
```

## Monetisasi
Gamepass time-saver (2x Speed, Auto-Train, VIP Gym) — bukan pay-to-win ekstrem; konten inti tetap bisa diakses gratis, monetisasi mempercepat progres saja.

## Konten di Peluncuran (MVP)
1 Hub utama + 1 race (5K Monas) + sistem sosial dasar (Stravi) + sistem training (Coach App) + toko dasar. Ekspansi bertahap (10 race tambahan, pet hunting, ultra marathon) di fase-fase berikutnya — lihat roadmap fase di `05_ROADMAP_TASKS.md`.

## Target Metrik Awal (indikatif, perlu validasi data nyata)
- D1 Retention ≥ 25%, D7 ≥ 8%
- Sesi rata-rata ≥ 12 menit
- (Detail lengkap & metodologi pengukuran: `00_PRD.md` §2, `06_LIVEOPS_AND_LAUNCH.md` §2)

## Risiko Utama yang Sudah Diidentifikasi & Mitigasi
| Risiko | Mitigasi |
|---|---|
| Kemiripan nama brand parody dengan merek asli (risiko IP) | Perbesar jarak kreatif nama/desain sebelum monetisasi skala besar — bukan nasihat hukum, disarankan konsultasi legal |
| Representasi budaya yang kurang sensitif | Panduan desain budaya + proses review manusia untuk daerah tertentu (lihat `09_ART_BIBLE.md`) |
| Ekonomi in-game timpang (inflasi/deflasi) | Monitoring sink/source berkelanjutan (lihat `06_LIVEOPS_AND_LAUNCH.md` §5) |
| Rilis langsung ke traffic besar tanpa validasi | Soft-launch bertahap sebelum full launch (`06_LIVEOPS_AND_LAUNCH.md` §3) |

## Status Dokumentasi Proyek
Dokumen pendukung lengkap tersedia untuk tim produksi: PRD detail, arsitektur teknis, standar kode, pedoman aset, roadmap tugas, strategi live-ops, pipeline CI/CD, strategi testing, dan art bible.
