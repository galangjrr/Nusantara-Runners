# Product Requirement Document (PRD)
## Roblox Indonesia Marathon Runner — "Nusantara Runner" (Working Title)

Versi: 2.0 (Revisi)
Status: Draft untuk pengembangan Agentic AI
Platform: Roblox (PC, Mobile, Console)

---

## 1. Ringkasan Eksekutif

**Genre**: Arcade Sports Simulator + Pet Collection, dibungkus tema budaya & geografi Indonesia.

**Core Fantasy**: Pemain berperan sebagai pelari yang berkeliling Nusantara — dari Jakarta, Yogyakarta, Bali, Sumatra, hingga Papua — mengikuti event lari (5K s.d. Ultra 100K), melatih stat lewat gym & app training, serta berburu satwa endemik liar di jalur trail/gunung.

**Target Audience**: Pemain Roblox usia 8–15 tahun (primer), dengan daya tarik sekunder ke pemain yang menyukai game "simulator" (Pet Simulator, Gym Simulator) dan game lari/geografi edukatif ringan.

**Perbedaan dari draft sebelumnya**: PRD ini menambahkan bagian yang sebelumnya tidak ada — target device/performance, retensi & KPI, keamanan ekonomi, kepatuhan kebijakan Roblox, sensitivitas budaya, dan risiko IP — karena bagian-bagian ini yang paling sering menjadi blocker saat submission/review Roblox atau saat scaling player count.

---

## 2. Tujuan Produk & Metrik Sukses (KPI)

| Metrik | Target Fase MVP | Catatan |
|---|---|---|
| D1 Retention | ≥ 25% | Standar genre simulator Roblox |
| D7 Retention | ≥ 8% | |
| Avg. Session Length | ≥ 12 menit | Didorong oleh 1 race loop + 1 gym loop |
| Playable FPS (mobile low-end) | ≥ 30 FPS | Wajib di-test di device Android RAM 2GB |
| Server Crash Rate | < 0.5% sesi | Dipantau lewat error log DataStore & Remote |

Catatan: angka di atas adalah target perencanaan, bukan jaminan — perlu divalidasi ulang dengan data playtest internal.

---

## 3. Struktur Dunia Game

### 3.1 Main Hub — GBK Senayan
Pusat sosial: Gym, Toko Gear, Warung Sol (upgrade sepatu), Gacha Pet, Terminal Travel (Bus/Bandara sebagai portal ke Sub-Place).

### 3.2 Sub-Places (Reserved Servers per event agar hub tidak overload)
| # | Sub-Place | Jarak | Tema Budaya |
|---|---|---|---|
| 1 | Monas & GBK | 5K | Jakarta urban |
| 2 | Borobudur & Prambanan | 10K | Jawa Tengah, heritage |
| 3 | Bali Coastal & Toba | 21K | Bali, Sumatra Utara |
| 4 | Suramadu & Ampera | 42K | Jawa Timur/Madura, Sumsel |
| 5 | Trail Bromo & Rinjani | Trail | Jawa Timur, NTB (pet hunting zone) |
| 6 | Raja Ampat & Labuan Bajo | Ultra 100K | Papua Barat, NTT |

**Rekomendasi teknis**: setiap Sub-Place di-load sebagai tempat terpisah (`TeleportService:TeleportToPlaceInstance`) supaya memory & part count tidak menumpuk pada satu server — ini WAJIB dipertegas karena draft awal tidak menyebut apakah teleport ini multi-place Roblox sesungguhnya atau sekadar pindah folder Map di server yang sama. Untuk MVP, gunakan **single-place dengan folder Map berbeda + StreamingEnabled**, baru pindah ke multi-place architecture di Fase 3 saat jumlah aset sudah besar (menghindari kompleksitas TeleportService & data-passing di MVP).

---

## 4. Sistem Inti

### 4.1 Stravi App (parodi Strava)
- KOM/QOM Segment per rute (mis. Segment Sprint Monas 200m).
- Crown Buff: +15% speed di segment tsb bagi pemegang rekor — **harus di-cap durasi/ scope-nya** (misal hanya aktif di segment itu saja, expire saat direbut pemain lain) agar tidak menjadi buff permanen yang timpang.
- Give Kudos: interaksi sosial ringan, +1 Cash per kudos ke pemegang rekor — beri **cooldown per pemain per hari** (mis. maksimal 20 kudos/hari) agar tidak jadi vektor farming multi-akun.

### 4.2 AI Training Coach App
- Efficiency Multiplier 1.0x (tanpa app) s.d. 2.5x (VIP).
- Daily Workout Quest → reward Rubies & Chest Gem.
- **Catatan desain**: multiplier training sebaiknya memengaruhi *stat gain per sesi*, bukan *kecepatan progres tak terbatas* — perlu daily/weekly cap XP agar pemain non-VIP tidak merasa mustahil mengejar.

### 4.3 Wild Pet Hunting
Minigame umpan & lasso di zona trail/gunung. Rarity: Common → Secret (Garuda Emas).
- **Catatan**: rate legendary/secret (5%/1%) termasuk kategori yang harus mengikuti kebijakan Roblox soal **pengungkapan peluang (odds disclosure)** untuk sistem acak berbayar — lihat bagian 9 (Kepatuhan).

### 4.4 Race System
Checkpoint berbasis `Magnitude` di server (`Heartbeat`), bukan `Touched`. Validasi anti-cheat wajib (lihat bagian 10).

---

## 5. Progression & Ekonomi

### 5.1 Currency
- **Cash**: earning cepat, dipakai untuk konsumsi (sol sepatu, konsumable).
- **Rubies**: earning lambat/quest, dipakai untuk gacha & item premium.
- **Trophies**: non-tradable, murni prestise leaderboard.

### 5.2 Formula (revisi dari draft awal — lihat bagian 11 untuk detail & alasan perubahan)

### 5.3 Gear & Outfit
Sepatu parodi brand (lihat bagian 8 soal risiko nama) + outfit budaya per daerah (Jawa, Bali, Sumatra, Papua, Dayak, Bugis, NTT/NTB).

**Catatan sensitivitas budaya (penting)**: Item seperti mahkota bulu Cendrawasih (Papua) atau atribut adat lain berpotensi berasal dari benda yang punya makna sakral/adat di komunitas aslinya. Rekomendasi:
- Desain sebagai versi **stilisasi/fantasi ringan** (bukan reproduksi presisi atribut upacara adat), dengan warna dan bentuk yang jelas "game-ified".
- Sertakan kredit budaya singkat di deskripsi item (mis. "terinspirasi busana tradisional Papua") agar terasa merayakan, bukan mengeksploitasi.
- Hindari asosiasi pet legendary/secret dengan simbol yang punya makna religius/nasional sensitif (Garuda perlu hati-hati — sebagai lambang negara, sebaiknya pet ini didesain jelas fiksi/burung mitologis generik, bukan replika Lambang Garuda Pancasila).

---

## 6. Race Events (14 total)
Sama seperti draft awal — dikelompokkan per jarak: 5K (2), 10K (2), 21K (2), 42K (2), Trail (4), Ultra 100K (2). Detail nama & lokasi lihat lampiran `03_ROADMAP_EXECUTION_CHECKLIST.md`.

---

## 7. UI/UX Requirement (tambahan dari draft awal)
- **Onboarding**: tutorial wajib 60–90 detik pertama kali join (cara lari, cara ikut race pertama, cara ke gym) — draft awal tidak menyebutkan onboarding sama sekali, padahal ini krusial untuk retensi D1.
- **Localization**: UI mendukung Bahasa Indonesia sebagai default + English sebagai opsi (banyak player Roblox Indonesia justru terbiasa UI Inggris).
- **Mobile-first layout**: Karena Roblox mayoritas mobile, seluruh HUD (Stats, Stravi Widget, Coach Widget) wajib pakai `UDim2` scale-based + `AnchorPoint` teruji di aspect ratio 19.5:9 dan 4:3.
- **Accessibility**: opsi colorblind-safe untuk Cadence Bar (Green/Red Zone) — tambahkan indikator bentuk/ikon, jangan hanya warna.

---

## 8. Risiko IP / Parody Brand (penting — bukan nasihat hukum)

Nama seperti "Niko VaporFly", "Adidos Carbon", "Pumaa Fast-R", "Hoka-Hoka Run", "Salomonster Trail", "Garming" secara fonetik & visual sangat dekat dengan merek asli (Nike, Adidas, Puma, Hoka, Salomon, Garmin). Beberapa catatan (bukan nasihat hukum, sebaiknya dikonsultasikan ke pihak legal sebelum monetisasi skala besar):

- Kemiripan nama yang disengaja untuk "menyindir" merek tidak otomatis aman hanya karena ejaan diubah — risiko trademark/passing-off tetap ada, terutama jika logo/desain sepatu juga meniru bentuk khas (garis Swoosh, tiga garis Adidas, dll).
- **Rekomendasi produk**: perbesar jarak kreatif — ganti ke nama fiksi penuh yang tidak jadi permainan kata dari merek asli (mis. "Garuda Sprint Pro" alih-alih "Niko VaporFly"), dan desain ulang siluet sepatu agar tidak meniru logo asli. Ini mengurangi risiko takedown/DMCA yang bisa menghentikan monetisasi mendadak.
- Statistik gameplay (+30% Speed dsb.) aman untuk dipertahankan; yang berisiko adalah *branding & visual identity*-nya.

---

## 9. Kepatuhan Kebijakan Roblox

- **Random Items (Gacha/Pet)**: Roblox mewajibkan pengungkapan odds untuk pembelian barang virtual acak berbayar. Jika Gacha Pet bisa dibeli dengan Robux/Rubies premium, UI wajib menampilkan tabel persentase (lihat bagian 14 di draft awal — matrix ini harus tampil ke pemain, bukan hanya dokumentasi internal).
- **Moderasi Chat/Social**: fitur "Give Kudos" & feed sosial Stravi harus lewat `TextService:FilterStringAsync` bila menampilkan nama/teks buatan pemain.
- **Age-appropriate**: karena target usia termasuk anak-anak, hindari mekanik yang menyerupai perjudian eksplisit (no "spin to win" dengan visual mesin slot).

---

## 10. Keamanan & Anti-Cheat (Server-Authoritative)
- Validasi `Magnitude`/detik untuk cegah speedhack & teleport hack.
- `RemoteEvent` sensitif (Train, BuyGear, CatchPet, RaceCheck) wajib divalidasi ulang di server — client value tidak pernah dipercaya mentah-mentah.
- Rate limiting per RemoteEvent (mis. `TrainEvent` maksimal 1 request/detik) untuk cegah remote-spam exploit.
- `ProcessReceipt` wajib idempotent (tidak boleh double-grant saat retry).

---

## 11. Formula Teknis (Revisi)

### 11.1 WalkSpeed
```
WalkSpeed = clamp(
  BaseSpeed(16) + (PaceStat * 0.25),
  16, 60  -- hard cap server-side, cegah stacking buff jadi speedhack tak terdeteksi
) * ShoeMultiplier * CrownMultiplier * PetMultiplier
```
Perubahan dari draft awal: menambahkan **hard cap** sebelum dikalikan multiplier, karena tanpa cap, stacking Shoe(1.3) × Crown(1.15) × Pet(1.5) pada PaceStat tinggi bisa menghasilkan speed yang di luar rentang wajar dan mudah disalahartikan sebagai exploit oleh sistem anti-cheat lain.

### 11.2 Stamina Drain
```
StaminaDrain = max(0.5, (BaseDrain(5.0) - CushionSaver) / CadenceQuality)
```
Ditambahkan `max(0.5, ...)` agar stamina drain tidak pernah menyentuh nol/negatif dari kombinasi cushion tinggi + cadence sempurna (mencegah stamina infinite yang tidak diinginkan).

### 11.3 Gym Training XP
```
StatGain = min(BaseXP(10) * CadenceAccuracyMultiplier * CoachEfficiency, DailyXPCap)
```
`DailyXPCap` per stat per hari mencegah pemain VIP+bot script melakukan grinding stat tanpa batas dalam sekali sesi panjang.

---

## 12. Monetisasi
- Gamepass: `2x Speed`, `Auto-Train` (harus tetap dibatasi rate server meski auto), `VIP Senayan Gym`, `Stravi Premium Pro`.
- Prinsip: monetisasi mempercepat progres (time-saver), bukan membuka konten yang tidak bisa diakses gratis sama sekali (agar tidak pay-to-win ekstrem dan lebih aman dari sisi kebijakan Roblox/App Store anak-anak).

---

## 13. Roadmap Fase
Lihat `03_ROADMAP_EXECUTION_CHECKLIST.md` untuk checklist tugas per fase secara berurutan. Ringkasan:
- **Fase 0**: Setup proyek, tooling, folder skeleton.
- **Fase 1 (MVP)**: Hub, gerak & stamina, 1 race (5K Monas), Stravi basic, Coach basic, shop dasar.
- **Fase 2**: Ekspansi sub-place (10K, 21K), pet hunting trail, dual leaderboard.
- **Fase 3**: Ultra 100K, multi-place architecture penuh, Stravi Crown global, VIP expansion.

---

## 14. Lampiran Referensi
- Skema DataStore (JSON): lihat `05_ARCH_SYSTEM_AND_DATASTORE.md` §5.
- Remote Event contract: lihat `05_ARCH_SYSTEM_AND_DATASTORE.md` §6.
- Pet Catching Matrix: dipindahkan ke `03_ROADMAP_EXECUTION_CHECKLIST.md` (data konten, bukan keputusan produk).
