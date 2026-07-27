# LIVEOPS_AND_LAUNCH.md
## Telemetry, Soft-Launch, & Kalender Konten Pasca-Rilis — Nusantara Runner

---

## 1. Mengapa Dokumen Ini Penting

Kualitas kode dan arsitektur (lihat `02_ARCHITECTURE.md`) menentukan apakah game *bisa* jalan dengan benar. Dokumen ini menentukan apakah game *bertahan hidup* setelah rilis — mayoritas game simulator Roblox mati bukan karena bug, tapi karena tidak ada data untuk tahu di mana pemain drop, tidak ada rencana konten setelah minggu pertama, dan rilis "big bang" ke semua region sekaligus tanpa validasi.

---

## 2. Telemetry Taxonomy (Event Logging)

### 2.1 Prinsip
- Setiap event funnel penting dicatat dengan **nama event konsisten** dan **payload minimal tapi cukup** untuk analisis funnel.
- Event dikirim dari **server**, bukan client (client bisa dimanipulasi/di-skip).
- Gunakan `AnalyticsService` bawaan Roblox (Roblox Engagement/Funnel/Economy events) sebagai lapisan dasar, ditambah custom event via `AnalyticsService:LogCustomEvent` untuk hal spesifik game ini yang tidak tercakup event bawaan.

### 2.2 Skema Nama Event
```
<Kategori>_<Aksi>
Contoh:
Onboarding_Started
Onboarding_TutorialCompleted
Race_Started
Race_Finished
Race_Abandoned
Gym_TrainCompleted
Shop_PurchaseAttempted
Shop_PurchaseCompleted
Pet_CatchAttempted
Pet_CatchSucceeded
Stravi_KOMClaimed
Monetization_GamepassPurchased
```

### 2.3 Funnel Wajib Dilacak (Fase 1 MVP)

| Funnel | Event Berurutan | Tujuan Analisis |
|---|---|---|
| Onboarding | `Onboarding_Started` → `Onboarding_TutorialCompleted` → `Race_Started` (race pertama) | Deteksi di step mana pemain baru drop sebelum race pertama |
| First Session Value | `Race_Finished` (race pertama) → `Gym_TrainCompleted` (pertama) → `Shop_PurchaseAttempted` (pertama, termasuk yang gratis) | Apakah pemain baru sempat menyentuh 2 loop utama sebelum leave |
| D1/D7 Retention | `Session_Start` dengan `UserId` + timestamp, dibandingkan lintas hari | Data mentah untuk KPI di `00_PRD.md` §2 |
| Economy Health | `Shop_PurchaseCompleted` (currency & amount), `Race_Finished` (reward granted) | Deteksi inflasi/deflasi currency (lihat §5 di bawah) |

### 2.4 Payload Standar per Event
```lua
{
	UserId = player.UserId,
	Timestamp = os.time(),
	SessionId = sessionId, -- generate per join, untuk grouping event dalam 1 sesi
	-- field spesifik event, mis. untuk Race_Finished:
	RaceId = "5K_Monas",
	DurationSeconds = 1423,
	Rank = 4,
}
```

### 2.5 Dashboard Minimum (Fase 1)
- Funnel onboarding (drop-off per step).
- DAU/D1/D7 retention curve.
- Distribusi waktu sesi (histogram, bukan cuma rata-rata — rata-rata menyembunyikan bimodal "quit cepat" vs "main lama").
- Economy sink vs source ratio harian (lihat §5).

**Catatan implementasi**: dashboard bisa mulai dari export data mentah ke Google Sheets/Studio Analytics bawaan Roblox untuk MVP; tooling BI penuh (mis. custom backend) baru relevan setelah DAU cukup besar untuk butuh query lebih kompleks.

---

## 3. Strategi Soft-Launch (Rilis Bertahap)

Jangan publish langsung ke publik dengan traffic penuh. Urutan yang direkomendasikan:

### Tahap A — Private/VIP Server Testing (internal)
- Undang tim internal + beberapa playtester tepercaya lewat VIP Server / Private Server link.
- Fokus: crash, exploit dasar, data loss saat rejoin, checklist teknis di `01_AGENT_RULES.md` §4.
- **Kriteria lulus**: 0 crash server dalam sesi 2 jam, 0 kasus data hilang dalam 20x simulasi rejoin.

### Tahap B — Soft Launch Terbatas (public, tanpa promosi)
- Publish ke publik TAPI tanpa aktivitas marketing apa pun (tidak di-share, icon/thumbnail bisa sengaja "biasa saja" dulu).
- Traffic organik kecil dari algoritma Roblox Discover akan tetap masuk — cukup untuk validasi funnel & retention dengan sampel nyata.
- **Durasi**: minimal 3–7 hari, atau sampai terkumpul ≥ 200–500 sesi unik untuk data funnel yang cukup bermakna secara statistik.
- **Kriteria lulus**: D1 retention mendekati target `00_PRD.md` §2 (≥ 25%), tidak ada funnel drop-off ekstrem (>70% loss) di satu step tertentu.

### Tahap C — Icon/Thumbnail A/B Test
- Roblox mendukung split-testing thumbnail & icon secara native (Creator Hub → Analytics → A/B testing) — jalankan sebelum spend UA (User Acquisition) berbayar, karena CTR icon/thumbnail adalah pengganda terbesar untuk traffic organik gratis.
- Uji minimal 2–3 variasi thumbnail (fokus pada "hook" berbeda: aksi lari vs pet vs kostum budaya) untuk lihat mana yang CTR tertinggi.

### Tahap D — Full Launch + UA (opsional, berbayar)
- Baru setelah Tahap B & C lolos, pertimbangkan Roblox Ads/Sponsored untuk mendorong traffic tambahan.
- Mulai dengan budget kecil dan ukur **cost per D1-retained-user**, bukan cuma cost per klik/visit — traffic murah tapi tidak retain adalah pemborosan.

### 3.1 Kriteria Rollback
Jika di Tahap B ditemukan:
- Crash rate > 1% sesi, atau
- Data loss terkonfirmasi pada akun nyata, atau
- Exploit ekonomi ditemukan (grinding currency tak wajar)

→ **Tarik kembali ke Private Server**, perbaiki, ulangi Tahap A–B. Jangan lanjut ke Tahap C/D dengan bug kelas ini masih terbuka.

---

## 4. Kalender Konten Pasca-Rilis (LiveOps Cadence)

Game simulator Roblox yang bertahan lama hidup dari ritme update yang bisa diprediksi pemain. Rekomendasi cadence:

| Cadence | Jenis Konten | Contoh |
|---|---|---|
| **Mingguan** | Reset leaderboard otomatis (sudah ada di sistem) + 1 micro-event ringan | "Weekend Double Cash", limited-time outfit warna berbeda |
| **2 Mingguan** | 1 quest/challenge musiman kecil | "Tantangan Kejar KOM Baru di Segment X" |
| **Bulanan** | 1 konten besar: race baru, pet baru, atau Sub-Place baru (sesuai roadmap Fase 2/3) | Rilis Trail Merbabu, pet baru non-legendary |
| **Musiman (3–4 bulan)** | Event tematik terikat momen nyata Indonesia | Event "Hari Kemerdekaan" (17 Agustus) dengan kostum/leaderboard spesial — **harus melalui review sensitivitas simbol nasional, lihat `04_ASSET_GUIDELINES.md` §3** |

### 4.1 Prinsip Desain Update
- Setiap update harus punya **1 alasan untuk pemain lama kembali** (item baru, event waktu terbatas, leaderboard reset) — bukan sekadar bugfix silent.
- Jangan reset progres inti pemain (Stats/Inventory) demi event musiman — event sebaiknya menambah lapisan (leaderboard sementara, item kosmetik terbatas), bukan mengganggu progression permanen.
- Umumkan update lewat channel yang sudah ada di game (feed Stravi in-game bisa dipakai sebagai "News Feed" event, karena sistemnya sudah ada) sebelum bergantung pada channel eksternal.

---

## 5. Economy Health Monitoring (Sink vs Source)

Karena game ini punya banyak sumber currency (race reward, kudos, quest harian) dan banyak sink (shop, sol sepatu, gacha), wajib dipantau agar tidak terjadi inflasi (currency terlalu mudah didapat → item jadi tidak berarti) atau deflasi (currency terlalu sulit → pemain frustrasi/churn).

### 5.1 Metrik Wajib
- **Source per pemain per hari** (rata-rata Cash/Rubies didapat).
- **Sink per pemain per hari** (rata-rata dibelanjakan).
- **Rasio Sink/Source** — idealnya mendekati 1 dalam jangka menengah; kalau source jauh > sink dalam waktu lama, currency mulai kehilangan makna (harga barang terasa murah/tidak berarti).
- **Rich player ratio** — persentase pemain dengan saldo currency di atas 10x median; jika naik terus tanpa sink baru, pertimbangkan sink baru (bukan menaikkan harga barang lama, yang terasa tidak adil bagi pemain baru).

### 5.2 Tindakan Korektif
- Jika inflasi terdeteksi: tambah sink baru (kosmetik premium, upgrade lanjutan) daripada memotong reward existing secara tiba-tiba (nerf reward yang sudah dijanjikan terasa buruk bagi pemain).
- Jika deflasi/pemain kesulitan progres: tambah quest/reward ringan tambahan, bukan menurunkan harga item secara drastis (bisa merasa tidak konsisten bagi early adopter yang sudah beli mahal).

---

## 6. Checklist Sebelum Full Launch

- [ ] Semua event telemetry §2.3 sudah terpasang & terverifikasi datanya masuk dashboard.
- [ ] Tahap A (private test) lolos kriteria §3.
- [ ] Tahap B (soft launch) lolos kriteria retention & funnel §3.
- [ ] A/B thumbnail sudah dijalankan minimal 1 putaran (§3 Tahap C).
- [ ] Kalender konten 3 bulan pertama sudah disusun (minimal draft mingguan/bulanan sesuai §4).
- [ ] Baseline economy health (§5) sudah direkam sebelum full launch, sebagai pembanding setelah traffic naik.
