# ASSET_GUIDELINES.md
## Pedoman Aset Dinamis & Realistis — Nusantara Runner

---

## 1. Prinsip Umum
- **Performance dulu, detail belakangan.** Setiap map wajib punya versi blockout (part primitif) yang playable sebelum diberi detail visual — agar sistem gameplay bisa dites lebih awal tanpa menunggu aset final.
- **Dinamis lewat data, bukan lewat duplikasi instance.** Variasi (mis. warna outfit per daerah, skin pet per rarity) sebisa mungkin dikendalikan lewat 1 model dasar + `Attribute`/`Color`/`MeshPart:ApplyMesh` swap, bukan menduplikasi seluruh model per varian.

## 2. Budget Performa (target mobile low-end)

| Elemen | Budget per Map/Sub-Place |
|---|---|
| Triangle count (visible sekaligus) | ≤ 250,000 |
| Part count non-streaming | ≤ 3,000 |
| Aktif `PointLight`/`SpotLight` | ≤ 15 |
| Ukuran texture per material | ≤ 512×512 (1024 hanya untuk landmark utama) |

- Aktifkan `Workspace.StreamingEnabled = true` untuk semua map berskala kota/gunung (Borobudur, Bromo, Raja Ampat) agar part di luar radius kamera tidak termuat sekaligus.
- Gunakan `LevelOfDetail`/manual LOD sederhana untuk objek jauh (mis. pohon low-poly di kejauhan, detail penuh hanya dalam radius ~100 studs).

## 3. Sensitivitas Budaya (WAJIB dibaca sebelum membuat aset kostum/pet ikonik)

Game ini memakai elemen budaya nyata (batik, udeng Bali, songket, atribut Papua, Dayak, Bugis, tenun NTT/NTB) serta simbol nasional (Garuda). Pedoman:

1. **Stilisasi, bukan replika presisi.** Desain kostum sebagai versi game yang jelas gaya "arcade/fantasi ringan" — bukan reproduksi 1:1 pakaian adat/upacara yang punya makna spesifik di komunitas asal (terutama atribut yang biasa dipakai dalam ritual/upacara adat, bukan sehari-hari).
2. **Hindari simbol negara sebagai item gacha biasa.** "Garuda Emas" sebagai pet secret sebaiknya didesain sebagai burung mitologis generik (emas, bersayap besar) — hindari elemen visual yang meniru presisi Lambang Garuda Pancasila (perisai, jumlah bulu simbolis, pita Bhinneka Tunggal Ika).
3. **Deskripsi item merayakan, bukan mereduksi jadi lucu-lucuan.** Tulis flavor text singkat yang informatif (mis. "terinspirasi motif Batik Megamendung, Jawa Barat") daripada hanya lelucon.
4. **Kalau ragu soal satu daerah tertentu, tandai sebagai item yang butuh review manusia** (lihat `01_AGENT_RULES.md` §7) — jangan menebak detail budaya yang tidak familiar.

## 4. Pipeline Aset per Kategori

### 4.1 Karakter & Outfit
- Base rig: R15 standar Roblox (kompatibel avatar Layered Clothing).
- Outfit budaya: gunakan Layered Clothing (bukan classic shirt/pants texture) agar bisa dipakai bersama avatar custom pemain tanpa clipping parah.
- Warna/motif: parameterisasi lewat `SurfaceAppearance`/texture atlas per daerah, satu mesh dasar dipakai ulang untuk beberapa varian warna.

### 4.2 Sepatu (Gear)
- Model sepatu dibuat dari siluet generik (bukan tracing logo asli — lihat `00_PRD.md` §8 soal risiko IP).
- Buff stat disimpan sebagai `Attribute` di model (`SpeedBoost = 0.3`), dibaca oleh `MovementController`, bukan dihardcode per nama item di banyak tempat.

### 4.3 Map Landmark (Monas, Borobudur, dll.)
- Landmark ikonik cukup direpresentasikan dengan bentuk siluet yang dikenali (bukan replika arsitektur presisi/tinggi asli) — ini juga mengurangi part count.
- Detail tinggi hanya pada radius interaksi pemain (start line, checkpoint), bagian latar bisa low-poly/skybox.

### 4.4 Pet
- Setiap pet: 1 mesh dasar + rarity-based tint/particle overlay (Common = tanpa partikel, Legendary/Secret = particle emitter + aura Attribute-driven) — hindari 5 model terpisah penuh jika bisa direduksi jadi varian dari template yang sama.
- Animasi idle/jalan pet dibuat generic per "tipe gerak" (mamalia darat, burung, reptil) agar dipakai ulang antar pet dengan skeleton mirip.

### 4.5 Environment Dinamis (realistis tapi ringan)
- Efek cuaca/waktu (mis. sunset di Prambanan) pakai `Lighting` property tween (`ClockTime`, `Ambient`) — bukan model 3D matahari statis per map.
- Air/ombak (Bali Coastal) pakai shader material bawaan Roblox (`Terrain` water) alih-alih custom mesh animasi berat.

## 5. Naming Convention Aset
```
<Category>_<Region/Theme>_<Variant>
Contoh:
Outfit_Jawa_BatikMegamendung
Shoe_Generic_CarbonSpeed01
Pet_Bromo_MonyetEmas
Map_SubPlace02_Borobudur
```
Konsisten dengan `ItemId` yang dipakai di `DataStore`/`Constants` (lihat `02_ARCHITECTURE.md` §5) — hindari nama tampilan (display name) dipakai langsung sebagai key data.

## 6. Checklist Sebelum Aset Dianggap "Final"
- [ ] Triangle count dicek, di bawah budget §2.
- [ ] Tidak ada tracing logo/siluet brand asli persis.
- [ ] Kostum/atribut budaya sudah melalui pedoman §3 (stilisasi, bukan replika presisi upacara adat).
- [ ] ItemId mengikuti naming convention §5 dan sudah terdaftar di `Constants`.
- [ ] Sudah dites di StreamingEnabled (tidak pop-in kasar dalam radius normal kamera).
