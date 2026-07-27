# ROADMAP_TASKS.md
## Checklist Tugas Berurutan — Nusantara Runner

Gunakan file ini sebagai papan progres. Tandai `[x]` hanya setelah lolos Self-Test Checklist di `01_AGENT_RULES.md` §4. Kerjakan berurutan dari atas ke bawah dalam satu fase — jangan lompat.

---

## Fase 0 — Setup Proyek

- [x] Inisialisasi repo + Rojo project file (`default.project.json`).
- [x] Buat struktur folder sesuai `02_ARCHITECTURE.md` §1.
- [x] Buat `shared/Constants.lua` kosong dengan kategori komentar (Movement, Economy, Stamina, Coach, Stravi, Pet).
- [x] Buat `shared/Types.lua` dengan tipe `PlayerProfile` awal.
- [x] Install/setup ProfileService di `server/Data/`.
- [x] Buat `CHANGELOG.md` kosong.

---

## Fase 1 — MVP

### 1.1 Data & Ekonomi Inti
- [x] Definisikan schema DataStore final (§5 di `05_ARCH_SYSTEM_AND_DATASTORE.md`) + default profile pemain baru.
- [x] Implementasi `EconomySystem.Grant/Deduct` + logging `reason`.
- [x] Test: profile baru tersimpan & termuat ulang tanpa data hilang (simulasi rejoin).

### 1.2 Movement & Stamina
- [x] Implementasi `MovementController` dengan formula WalkSpeed (§11.1 PRD) termasuk hard cap.
- [x] Implementasi `StaminaSystem` (drain/regen, cadence quality).
- [x] Implementasi `CadenceBarGui` client (Green/Red zone) dengan indikator non-warna untuk aksesibilitas.
- [x] Test: stamina tidak pernah negatif/infinite pada kombinasi ekstrem cushion+cadence.

### 1.3 Main Hub (GBK Senayan) — Blockout
- [x] Blockout part primitif: area gym, shop, gacha, terminal travel.
- [x] Tag `Treadmill` pada part latihan.
- [x] Tag `ShopVendor` pada booth toko.
- [x] Test: pemain bisa spawn, jalan, interaksi dasar tanpa error console.

### 1.4 Race System (1 race: 5K Monas)
- [x] Buat map Sub-Place 1 blockout (Monas & GBK).
- [x] Tag `RaceCheckpoint` di titik checkpoint rute 5K.
- [x] Implementasi `RaceSystem` validasi checkpoint via Heartbeat + Magnitude (bukan Touched).
- [x] Implementasi `RaceHUD` client (CheckpointTracker, LiveLeaderboard read-only).
- [x] Test: dua pemain simulasi race bersamaan, checkpoint tidak bisa di-skip lewat exploit teleport sederhana.

### 1.5 Stravi App — Basic
- [x] Tag `KOMSegmentStart`/`KOMSegmentEnd` pada Segment Sprint Monas 200m.
- [x] Implementasi `StraviSystem`: rekam waktu segment, tentukan KOM holder, apply Crown buff (scoped, bukan permanen).
- [x] Implementasi `Give Kudos` dengan cap harian (`MAX_KUDOS_PER_DAY`).
- [x] Implementasi `StraviWidget` client (KOM badge, tombol kudos).
- [x] Test: rebut KOM oleh pemain lain otomatis mencabut buff dari pemegang lama.

### 1.6 AI Coach App — Basic
- [x] Implementasi `CoachSystem`: efficiency multiplier (1.0x/1.5x), daily quest tracking, `DailyXPCap`.
- [x] Implementasi `CoachWidget` client (efficiency badge, progress quest harian).
- [x] Test: XP gain berhenti bertambah setelah cap harian tercapai, reset esok hari (simulasi ubah waktu server/testing clock).

### 1.7 Shop Dasar
- [x] Katalog awal: 1 sepatu generik + Pokari Swat (atau nama hasil rebrand, lihat §8 PRD) sebagai consumable.
- [x] Implementasi `ShopSystem`: validasi saldo, deduct `Cash`, berikan item ke profile `Inventory`.
- [x] Implementasi `BuyGearEvent` (C->S).
- [x] Test: beli barang tanpa uang = ditolak. Beli berhasil = item masuk ke profile & cash berkurang.

### 1.8 UI State Machine
- [x] Buat `UIStateController` di client, memastikan *mutually exclusive* (hanya 1 menu besar yang aktif).
- [x] Rombak/rapikan hierarchy StarterGui sesuai `ARCH_SYSTEM_AND_DATASTORE.md` (§7).

### 1.9 Onboarding (Tutorial)
- [ ] Tutorial 60–90 detik: gerak dasar → ikut race pertama → kunjungi gym.
- [ ] Integrasikan `UIStateController` agar HUD tidak tumpang tindih dengan tutorial.
- [ ] Test dengan pemain baru (akun kosong) end-to-end tanpa dead-end UI.

### 1.10 QA Fase 1
- [ ] Jalankan seluruh Self-Test Checklist (`01_AGENT_RULES.md` §4) untuk setiap sistem di atas.
- [ ] Playtest mobile low-end (cek FPS, cek UI tidak terpotong).
- [ ] Review manusia untuk item §8 PRD (parody brand name final) sebelum lanjut Fase 2.

---

## Fase 2 — Ekspansi Sub-Place & Pet Hunting

### 2.1 Sub-Place Baru
- [x] Blockout Sub-Place 2 (Borobudur & Prambanan, 10K).
- [ ] Blockout Sub-Place 3 (Bali Coastal & Toba, 21K).
- [ ] Replikasi RaceSystem/StraviSystem ke race baru (pastikan `RaceId` unik per race, bukan hardcode single race).

### 2.2 Pet Hunting System
- [x] Blockout Sub-Place 5 (Trail Bromo & Rinjani).
- [x] Tag `PetSpawnZone`.
- [x] Implementasi `PetSystem`: spawn by zone, roll probabilitas sesuai matrix di bawah, minigame umpan & lasso server-validated.
- [x] UI odds disclosure (wajib, lihat `00_PRD.md` §9) ditampilkan di layar sebelum pemain "menangkap".
- [x] Test: `TimingScore` yang dimanipulasi client tidak menaikkan catch rate melebihi base rate.

#### Pet Catching Matrix (data konten, dipindah dari draft awal)

| Pet | Rarity | Lokasi Spawn | Base Catch Rate | Buff |
|---|---|---|---|---|
| Monyet Emas | Common | Bromo Trail | 75% | +5% Stamina |
| Elang Jawa | Rare | Gede Pangrango | 40% | +10% Speed |
| Harimau Sumatra | Epic | Danau Toba Trail | 15% | +20% Acceleration |
| Komodo | Legendary | Labuan Bajo | 5% | +25% Speed & +25% Stamina |
| Garuda Emas* | Secret | Rinjani Summit | 1% | +50% All Stats & Gold Aura |

\*Desain visual final Garuda Emas wajib lolos review §3 `04_ASSET_GUIDELINES.md` sebelum dirilis.

### 2.3 Dual Leaderboard
- [ ] Implementasi `LeaderboardSystem`: All-Time (OrderedDataStore) + Weekly Reset (reset Senin 00:00 WIB via scheduled check, bukan asumsi server selalu hidup tepat jam 00:00 — gunakan pengecekan "sudah lewat waktu reset?" saat server start/loop).
- [ ] Reward Rank 1 mingguan: Gold Aura, title tag, Rubies, buff sementara (dengan expiry jelas).

### 2.4 QA Fase 2
- [ ] Self-Test Checklist untuk semua sistem baru.
- [ ] Review manusia untuk desain final Garuda Emas & atribut budaya Sub-Place baru.

---

## Fase 3 — Ultra & VIP Expansion

- [ ] Evaluasi keputusan multi-place architecture (lihat `02_ARCHITECTURE.md` §8) — butuh review manusia sebelum eksekusi.
- [ ] Blockout Sub-Place 4 (Suramadu & Ampera, 42K) dan Sub-Place 6 (Raja Ampat & Labuan Bajo, Ultra 100K).
- [ ] Stravi KOM Crown System Global (leaderboard lintas semua segment).
- [ ] Gamepass VIP (`Stravi Premium Pro`, `VIP Senayan Gym`) + `ProcessReceipt` idempotent.
- [ ] Full regression test seluruh 14 race event + seluruh pet + seluruh leaderboard sebelum general release.

---

## 14 Race Events (referensi konten)

| # | Nama Race | Jarak | Lokasi | Sub-Place |
|---|---|---|---|---|
| 1 | GBK Senayan Fun Run | 5K | Jakarta | 1 |
| 2 | Monas Car Free Day | 5K | Jakarta | 1 |
| 3 | Borobudur Heritage Run | 10K | Magelang | 2 |
| 4 | Prambanan Sunset Race | 10K | Yogyakarta | 2 |
| 5 | Bali Beach Run (Kuta–Sanur) | 21K | Bali | 3 |
| 6 | Danau Toba | 21K | Sumut | 3 |
| 7 | Suramadu Bridge | 42K | Surabaya–Madura | 4 |
| 8 | Ampera Bridge | 42K | Palembang | 4 |
| 9 | Gunung Bromo | Trail | Jawa Timur | 5 |
| 10 | Gunung Rinjani Summit | Trail | Lombok | 5 |
| 11 | Gunung Gede Pangrango | Trail | Jawa Barat | 5 |
| 12 | Gunung Merbabu Savana | Trail | Jawa Tengah | 5 |
| 13 | Raja Ampat Karst | Ultra 100K | Papua Barat | 6 |
| 14 | Labuan Bajo Komodo | Ultra 100K | NTT | 6 |
