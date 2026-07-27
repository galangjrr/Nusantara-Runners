# UI_UX_SPEC.md
## Spesifikasi UI/UX Detail — Nusantara Runner

Melengkapi `02_ARCHITECTURE.md` §7 (state machine) dan `09_ART_BIBLE.md` §6 (tipografi umum) dengan **spesifikasi implementasi persis** yang bisa langsung dipakai agent untuk membangun tiap Frame di Roblox Studio.

---

## 1. Design Tokens (Nilai Baku, Jangan Improvisasi per Screen)

### 1.1 Warna (simpan di `shared/UIConstants.lua`, bukan hardcode di tiap Frame)
```lua
return {
	Colors = {
		Primary = Color3.fromRGB(255, 92, 0),      -- oranye energik (aksen tombol utama, CTA)
		Secondary = Color3.fromRGB(0, 153, 255),    -- biru (info, badge netral)
		Success = Color3.fromRGB(46, 204, 113),     -- hijau (Cadence Green Zone, sukses beli)
		Danger = Color3.fromRGB(231, 76, 60),       -- merah (Cadence Red Zone, error)
		Gold = Color3.fromRGB(255, 215, 0),         -- emas (Crown/KOM badge, rarity Legendary+)
		BackgroundDark = Color3.fromRGB(30, 30, 36),-- latar panel/modal
		BackgroundLight = Color3.fromRGB(245, 245, 248), -- latar card/list item
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(180, 180, 190),
	},
}
```

### 1.2 Tipografi
| Elemen | Font | Ukuran (mobile baseline) | Weight |
|---|---|---|---|
| Judul menu (Shop, Coach, dsb.) | `Gotham Bold` / `SourceSansBold` | 28 | Bold |
| Label stat (Cash, Rubies) | `GothamMedium` | 18 | Medium |
| Body/deskripsi item | `SourceSans` | 14 | Regular |
| Angka besar (Timer, Pace) | `GothamBlack` | 32 | Black/ExtraBold |

Skala responsif: kalikan ukuran font dengan `UIScale` yang menyesuaikan `Camera.ViewportSize` — jangan pakai ukuran piksel absolut tanpa `UIScale` agar tetap terbaca di layar kecil maupun besar.

### 1.3 Spacing & Radius
- Grid spacing dasar: kelipatan **8px** (padding, gap antar elemen: 8, 16, 24, 32).
- Corner radius: `UICorner` 12px untuk card/button, 20px untuk modal/panel besar, 999px (full round) untuk badge/avatar.
- Shadow: gunakan `ImageLabel` drop-shadow tipis (opacity rendah ±0.25) di belakang card, bukan `UIStroke` tebal — kesan modern/ringan.

### 1.4 Ikon
Gunakan 1 set ikon konsisten (line-style atau flat-style, pilih salah satu, jangan campur) untuk: Cash (koin), Rubies (permata), Stamina (petir/hati), Pace (sepatu kecil), Trophy, Kudos (jempol/hati).

---

## 2. State Machine UI (Implementasi dari `02_ARCHITECTURE.md` §7)

```lua
-- client/UI/UIStateController.lua
export type MenuState = "None" | "Shop" | "Coach" | "Stravi" | "RaceHUD"

-- Signal/Event: StateChanged(newState: MenuState)
-- Setiap Frame Menu subscribe ke StateChanged, tampil hanya jika newState == nama dirinya
-- HUD (StatsFrame, StraviWidget, CoachWidget) TIDAK terpengaruh state ini — selalu visible
```

**Aturan wajib**: hanya 1 Menu aktif dalam satu waktu (mutually exclusive). Membuka Shop otomatis menutup Coach/Stravi jika sedang terbuka — dikontrol terpusat di `UIStateController`, bukan tiap Frame mengatur `Visible` miliknya sendiri secara independen.

---

## 3. Spesifikasi per Screen

### 3.1 HUD — StatsFrame (selalu tampil)
```
Posisi: AnchorPoint (0, 0), Position UDim2.new(0, 16, 0, 16)  -- pojok kiri atas
Ukuran: UDim2.new(0, 220, 0, 90)  -- fixed size, scaled via UIScale
Isi (top-to-bottom, gap 4px):
  - Baris 1: Ikon Cash + angka (kiri), Ikon Rubies + angka (kanan) — 1 baris horizontal
  - Baris 2: Stamina Bar (ProgressBar horizontal, warna Success saat >50%, Danger saat <20%)
  - Baris 3: Pace kecil (angka + label "Pace")
Update trigger: RemoteEvent `EconomyUpdated` (S→C) — JANGAN update dari asumsi client sendiri
```

### 3.2 HUD — StraviWidget
```
Posisi: AnchorPoint (1, 0), Position UDim2.new(1, -16, 0, 16)  -- pojok kanan atas
Ukuran: UDim2.new(0, 200, 0, 70)
Isi:
  - KOM Badge (ikon mahkota, warna Gold jika player pegang rekor di segment saat ini, abu-abu jika tidak)
  - Tombol "Give Kudos" (hanya aktif/berwarna saat player berada dekat pemegang rekor lain — disabled state abu-abu jika tidak applicable)
  - Teks kecil: nama pemegang rekor segment saat ini
Interaksi: klik tombol Kudos → RemoteEvent `StraviKudosEvent` → tombol disable sementara (cooldown visual) sampai konfirmasi server, MENCEGAH double-click spam sebelum response server datang
```

### 3.3 HUD — CoachWidget
```
Posisi: AnchorPoint (1, 0), Position UDim2.new(1, -16, 0, 96)  -- di bawah StraviWidget, gap 10px
Ukuran: UDim2.new(0, 200, 0, 60)
Isi:
  - Badge Efficiency (teks "1.5x" dsb, warna Secondary)
  - Progress bar Daily Quest (mis. "Treadmill 320/500m")
Update trigger: RemoteEvent dari CoachSystem setiap progress quest bertambah
```

### 3.4 Minigame — CadenceBarGui
```
Posisi: AnchorPoint (0.5, 1), Position UDim2.new(0.5, 0, 1, -40)  -- tengah bawah layar, dekat area jempol untuk mobile
Ukuran: UDim2.new(0, 320, 0, 60)
Isi:
  - Slider bar horizontal dengan 2 zona warna: Green Zone (Success) di tengah, Red Zone (Danger) di tepi
  - Indikator bentuk tambahan di Green Zone (mis. ikon centang kecil) SELAIN warna — wajib untuk aksesibilitas colorblind (lihat `00_PRD.md` §7)
  - Marker bergerak (posisi cadence real-time pemain)
Interaksi: tombol timing (tap di mobile, spacebar di PC) — hasil TimingScore dihitung LOKAL untuk feedback visual instan, TAPI validasi final tetap di server (client hanya untuk responsivitas, bukan sumber kebenaran)
```

### 3.5 Menu — ShopFrame
```
Posisi: AnchorPoint (0.5, 0.5), Position UDim2.new(0.5, 0, 0.5, 0)  -- tengah layar (modal)
Ukuran: UDim2.new(0.8, 0, 0.75, 0) di mobile, UDim2.new(0.5, 0, 0.7, 0) di PC (breakpoint via UIScale/AspectRatio check)
Struktur:
  - Header: judul "Toko Gear" + tombol close (pojok kanan atas, ikon X)
  - Tab horizontal: [Sepatu] [Outfit] [Consumable]
  - Grid item (ScrollingFrame + UIGridLayout): tiap card menampilkan ikon item, nama, harga, tombol "Beli"
  - Card state: default / hover (highlight border) / disabled (jika saldo tidak cukup — card jadi abu-abu, tombol Beli disabled)
Interaksi beli:
  1. Klik "Beli" → tombol berubah jadi loading spinner kecil (feedback instan, bukan diam menunggu tanpa indikasi)
  2. RemoteEvent `BuyGearEvent` dikirim ke server
  3. Response sukses → tombol berubah "Dimiliki"/checkmark, EconomyUpdated memperbarui StatsFrame
  4. Response gagal (saldo kurang, dsb.) → toast notification singkat di bawah layar ("Saldo tidak cukup"), card kembali ke state semula
```

### 3.6 Menu — CoachFrame
```
Posisi & Ukuran: sama pola dengan ShopFrame (modal tengah)
Struktur:
  - Header: judul "AI Training Coach"
  - Info Efficiency saat ini (besar, jadi fokus visual utama)
  - Daftar Daily Quest (checklist style, item yang selesai dicoret/centang hijau)
  - Tombol upgrade Coach Level (jika ada tier lanjutan, harga ditampilkan jelas sebelum konfirmasi)
```

### 3.7 Menu — StraviFrame
```
Posisi & Ukuran: sama pola modal
Struktur:
  - Header: judul "Stravi Feed"
  - List (ScrollingFrame): feed KOM terbaru direbut siapa, dengan tombol kudos di tiap entri (rate-limited sesuai §3.2)
  - Section terpisah: "KOM Saya" — daftar segment yang sedang dipegang player ini
```

### 3.8 RaceHUD — CheckpointTracker
```
Posisi: AnchorPoint (0.5, 0), Position UDim2.new(0.5, 0, 0, 16)  -- tengah atas, hanya muncul saat state = "RaceHUD" (sedang race)
Ukuran: UDim2.new(0, 300, 0, 50)
Isi: "Checkpoint 3/5" + progress bar horizontal kecil di bawah teks
Update trigger: RemoteEvent hasil validasi `RaceCheckEvent` dari server (bukan dihitung ulang di client)
```

### 3.9 RaceHUD — LiveLeaderboard
```
Posisi: AnchorPoint (1, 0.5), Position UDim2.new(1, -16, 0.5, 0)  -- tepi kanan tengah layar
Ukuran: UDim2.new(0, 180, 0, 200)
Isi: daftar top 5 pemain di race yang sama saat ini (nama, waktu berjalan), highlight baris pemain sendiri dengan warna Primary
Update trigger: interval polling ringan dari server (mis. tiap 2 detik) — HINDARI update per-frame yang membebani replication
```

### 3.10 Onboarding Overlay
```
Posisi: full-screen overlay dengan spotlight/highlight pada elemen yang sedang dijelaskan (dim area lain, terangkan 1 elemen fokus)
Struktur: tooltip box dekat elemen yang di-highlight + tombol "Lanjut"/"Lewati"
Urutan (sesuai `05_ROADMAP_TASKS.md` §1.8): highlight tombol lari dasar → highlight arah ke race pertama → highlight arah ke Gym
Aturan: tombol "Lewati" SELALU tersedia sejak awal (jangan paksa linear penuh tanpa exit, terutama untuk target usia anak yang mungkin sudah familiar dengan game serupa)
```

---

## 4. Responsif Mobile vs PC

| Breakpoint | Kondisi | Penyesuaian |
|---|---|---|
| Mobile Portrait/Landscape sempit | `AspectRatio` < 1.5 atau `ViewportSize.X` < 800 | Modal lebar 80-90% layar, font +10% lebih besar dari baseline PC, tombol minimal 44x44 px (target sentuh nyaman jari) |
| PC/Desktop | `ViewportSize.X` ≥ 1024 | Modal lebar 40-50% layar, HUD boleh sedikit lebih kecil karena presisi mouse lebih tinggi dari sentuhan jari |
| Console | Deteksi gamepad aktif | Tambahkan indikator navigasi D-pad/analog pada elemen yang bisa difokus (highlight border saat fokus gamepad) |

Semua Frame WAJIB pakai `Size` berbasis `Scale` (bukan `Offset` murni) untuk komponen utama, kombinasi `Scale`+`Offset` hanya untuk elemen kecil yang perlu ukuran minimum tetap (ikon, tombol close).

---

## 5. Aksesibilitas

- Colorblind-safe: setiap informasi yang disampaikan lewat warna (Cadence Zone, status saldo cukup/tidak) WAJIB punya penanda kedua non-warna (ikon, bentuk, teks) — lihat §3.4.
- Ukuran font minimum 14px baseline mobile (jangan lebih kecil, sulit dibaca di layar HP kecil).
- Kontras teks-latar minimum rasio 4.5:1 (standar WCAG AA) untuk semua teks fungsional (bukan dekoratif).
- Tombol interaktif minimum 44x44 px area sentuh di mobile (standar ukuran jari nyaman, bukan estimasi sembarang).

---

## 6. Feedback & Micro-interaction (Wajib Ada, Bukan Opsional)

| Aksi | Feedback Wajib |
|---|---|
| Klik tombol apa pun | Perubahan visual instan (scale-down kecil / highlight) SEBELUM response server datang, agar terasa responsif meski ada latency |
| Transaksi berhasil (beli, dapat reward) | Toast notification + suara singkat (opsional tapi disarankan) + angka currency di HUD ter-update dengan animasi count-up singkat (bukan lompat instan) |
| Transaksi gagal | Toast merah singkat dengan alasan jelas ("Saldo tidak cukup", bukan generic "Error") |
| Race checkpoint tercapai | Notifikasi kecil sesaat + progress bar CheckpointTracker terisi dengan animasi smooth (bukan snap instan) |
| KOM direbut (oleh player ini) | Perayaan visual lebih besar (particle/flash singkat) — momen ini penting secara sosial, layak feedback lebih kuat dari transaksi biasa |

---

## 7. Checklist Sebelum UI Screen Dianggap Selesai
- [ ] Semua warna/font mengambil dari `UIConstants.lua` (design token), bukan hardcode nilai baru per Frame.
- [ ] State mutually-exclusive dikontrol lewat `UIStateController`, bukan `Visible` diatur manual tersebar di banyak script.
- [ ] Update angka (Cash, Stamina, dsb.) HANYA dari RemoteEvent server, tidak ada asumsi/prediksi nilai di client.
- [ ] Sudah diuji minimal di 2 breakpoint (mobile & PC) sesuai §4.
- [ ] Elemen berbasis warna (Cadence Zone dsb.) sudah punya penanda non-warna sesuai §5.
- [ ] Feedback micro-interaction §6 sudah terpasang untuk aksi yang relevan pada screen tersebut.
