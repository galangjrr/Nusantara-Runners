# ITEM_CATALOG.md
## Spesifikasi Properti Item Lengkap — Nusantara Runner

Dokumen ini melengkapi `04_ASSET_GUIDELINES.md` (pedoman umum pembuatan aset) dengan **properti spesifik per item** yang dibutuhkan agent untuk membuat model + menghubungkannya ke sistem gameplay (`Attribute`, `ItemId`, harga). Setiap entri di bawah adalah "prompt siap pakai".

---

## 1. Format Standar per Item

```
### [Nama Item]
- ItemId: [key unik, dipakai di DataStore & Constants]
- Kategori: [Shoe / Outfit / Pet / Consumable]
- Rarity: [Common/Rare/Epic/Legendary/Secret — khusus Pet]
- Properti gameplay (Attribute): [daftar attribute & nilai]
- Deskripsi visual: [bentuk, warna, ciri khas]
- Harga & currency: [Cash/Rubies, tier harga relatif — angka final ditentukan saat economy balancing, bukan final di sini]
- Sumber didapat: [Shop / Gacha / Quest Reward / Event]
- Catatan produksi: [hal khusus untuk modeler]
```

---

## 2. Sepatu (Shoe)

> **Catatan penting sebelum membaca tabel ini**: nama & properti di bawah adalah versi **rebrand yang direkomendasikan** menggantikan nama dari draft awal ("Niko VaporFly" dsb.) sesuai catatan risiko IP di `00_PRD.md` §8. Nama di bawah adalah opsi fiksi penuh yang tidak lagi jadi permainan kata dari merek asli — silakan sesuaikan lagi sebelum final jika tim ingin nama lain, tapi hindari kembali ke pola "plesetan nama brand".

```
### Default Sneakers
- ItemId: Shoe_Default
- Kategori: Shoe
- Properti gameplay: SpeedMultiplier = 1.0, StaminaMultiplier = 1.0
- Deskripsi visual: sepatu lari generik putih-abu polos, tanpa aksen mencolok
- Harga: gratis (starter item)
- Sumber: default saat akun baru dibuat
- Catatan produksi: model paling sederhana, jadi base mesh untuk varian sepatu lain (swap warna/tekstur)
```

```
### Garuda Sprint Carbon
- ItemId: Shoe_SpeedCarbon01
- Kategori: Shoe
- Properti gameplay: SpeedMultiplier = 1.3
- Deskripsi visual: sepatu ramping berwarna merah-putih dengan garis aerodinamis di sisi, sol tebal warna oranye menyala (aksen "carbon plate")
- Harga: tier tinggi, Cash
- Sumber: Shop (Shoe Shop, tersedia sejak Fase 1 MVP)
- Catatan produksi: siluet ramping, hindari elemen yang meniru logo brand asli manapun (lihat `00_PRD.md` §8)
```

```
### Nusantara Balance Runner
- ItemId: Shoe_BalanceSpeed01
- Kategori: Shoe
- Properti gameplay: SpeedMultiplier = 1.2, StaminaMultiplier = 1.1
- Deskripsi visual: sepatu dua warna (hijau-putih), bentuk lebih membulat/nyaman dibanding versi carbon, kesan "seimbang" bukan "agresif"
- Harga: tier menengah, Cash
- Sumber: Shop
```

```
### Sprint-X Acceleration
- ItemId: Shoe_SprintAccel01
- Kategori: Shoe
- Properti gameplay: SprintAccelerationMultiplier = 1.25
- Deskripsi visual: sepatu rendah dengan sol tipis bergerigi di bagian depan (kesan sepatu sprint track, bukan sepatu jalan biasa)
- Harga: tier menengah, Cash
- Sumber: Shop
```

```
### CloudStep Cushion
- ItemId: Shoe_CushionStamina01
- Kategori: Shoe
- Properti gameplay: StaminaSaverMultiplier = 1.4
- Deskripsi visual: sol sangat tebal berwarna putih/pastel, bentuk membulat besar (kesan empuk/nyaman), kontras jelas dengan sepatu speed yang ramping
- Harga: tier menengah, Cash
- Sumber: Shop
```

```
### TrailGrip Offroad
- ItemId: Shoe_TrailHill01
- Kategori: Shoe
- Properti gameplay: HillSpeedMultiplier = 1.5
- Deskripsi visual: sepatu trail dengan sol tebal bergerigi kasar (pola grip terlihat jelas dari bawah), warna coklat-hijau tema outdoor, sedikit tinggi menutupi mata kaki
- Harga: tier tinggi, Cash/Rubies
- Sumber: Shop, khusus tersedia sejak Fase 2 (Trail Bromo/Rinjani dibuka)
- Catatan produksi: pastikan siluet berbeda jelas dari sepatu speed/carbon — ini kategori "trail", bukan "race"
```

---

## 3. Aksesori & Gadget

```
### Pace Tracker Watch
- ItemId: Gadget_PaceWatch
- Kategori: Outfit (slot aksesori tangan)
- Properti gameplay: UI-only (menampilkan pace real-time di layar saat dipakai) — tidak ada stat buff, murni kosmetik/fungsi UI
- Deskripsi visual: jam tangan sport dengan layar digital kecil menyala, tali warna bisa dikustomisasi (variant warna)
- Harga: tier rendah, Cash
- Sumber: Shop
```

---

## 4. Outfit Budaya (per Attribute, lihat `09_ART_BIBLE.md` §4 untuk panduan desain wajib)

```
### Batik Megamendung Jersey (Jawa)
- ItemId: Outfit_Jawa_Megamendung
- Kategori: Outfit
- Properti gameplay: tidak ada stat buff (murni kosmetik) — KEPUTUSAN DESAIN: outfit budaya sebaiknya kosmetik murni, bukan pay-to-win lewat stat, agar semua daerah terasa setara dan tidak ada insentif ekonomi untuk "budaya mana yang lebih kuat"
- Deskripsi visual: jersey lari dengan pola motif awan Megamendung (motif bergelombang, gradasi biru-putih) di bagian dada & lengan, dipadu Blangkon Running Cap sebagai item terpisah
- Harga: tier menengah, Cash/Rubies
- Sumber: Shop, terbuka sejak Fase 1
```

```
### Udeng Bali Set
- ItemId: Outfit_Bali_Udeng
- Kategori: Outfit
- Properti gameplay: kosmetik murni
- Deskripsi visual: ikat kepala (Udeng) motif kotak-kotak khas + celana pendek atletik bermotif Kamen sederhana
- Harga: tier menengah
- Sumber: Shop, terbuka sejak Fase 2 (Bali Sub-Place)
```

```
### Songket Runner Vest (Sumatra/Melayu)
- ItemId: Outfit_Sumatra_Songket
- Kategori: Outfit
- Properti gameplay: kosmetik murni
- Deskripsi visual: rompi lari dengan aksen tenun emas di tepi (versi disederhanakan dari motif songket), dipadu Tanjak versi "atletik" (lebih rendah/simpel dari tanjak formal asli)
- Harga: tier tinggi (motif detail lebih rumit)
- Sumber: Shop/Event
```

```
### Cendrawasih Spirit Set (Papua) — PERLU REVIEW MANUSIA
- ItemId: Outfit_Papua_Cendrawasih
- Kategori: Outfit
- Properti gameplay: kosmetik murni
- Deskripsi visual: mahkota bergaya bulu berwarna oranye-kuning cerah (STILISASI KUAT — bentuk bulu disederhanakan jadi pola dekoratif geometris, bukan reproduksi bulu presisi), dipadu rok/rumbai pendek atletik warna senada
- Harga: tier tinggi
- Sumber: Shop/Event
- Catatan produksi: WAJIB melalui proses review §4.2 & §4.3 di `09_ART_BIBLE.md` sebelum masuk build final — jangan produksi final tanpa review ini
```

```
### Enggang Trail Vest (Dayak) — PERLU REVIEW MANUSIA
- ItemId: Outfit_Dayak_Enggang
- Kategori: Outfit
- Properti gameplay: kosmetik murni
- Deskripsi visual: rompi bertekstur "kulit kayu" (pola ukiran permukaan, bukan bahan asli), dipadu ikat kepala dengan aksen bulu bergaya (stilisasi kuat, bukan reproduksi presisi bulu Enggang)
- Harga: tier tinggi
- Sumber: Shop/Event
- Catatan produksi: WAJIB review manusia sebelum final (lihat `09_ART_BIBLE.md` §4.3)
```

```
### Baju Bodo Athletic (Bugis)
- ItemId: Outfit_Bugis_BajuBodo
- Kategori: Outfit
- Properti gameplay: kosmetik murni
- Deskripsi visual: versi lengan pendek atletik dari siluet Baju Bodo (warna cerah solid, bukan detail formal penuh), dipadu Passapu (ikat kepala) versi simpel
- Harga: tier menengah
- Sumber: Shop/Event
```

```
### Tenun Ikat Runner (NTT/NTB)
- ItemId: Outfit_NTT_TenunIkat
- Kategori: Outfit
- Properti gameplay: kosmetik murni
- Deskripsi visual: jersey dengan pola tenun ikat geometris di bagian bawah/pinggir (motif garis-garis khas tenun, disederhanakan jadi pola berulang)
- Harga: tier menengah
- Sumber: Shop/Event
```

---

## 5. Consumable

```
### Elektro Splash
- ItemId: Consumable_ElectrolyteBoost
- Kategori: Consumable
- Properti gameplay: StaminaInstantRestore = 50
- Deskripsi visual: botol minuman isotonik warna biru cerah, ikon botol kecil dengan efek splash saat dipakai (particle ringan, sekali pakai — bukan aura permanen)
- Harga: tier rendah, Cash
- Sumber: Shop, stok bisa dibeli berulang
```

```
### Herbal Anti-Kram Gel
- ItemId: Consumable_AntiCrampGel
- Kategori: Consumable
- Properti gameplay: InfiniteStaminaDuration = 30 detik
- Deskripsi visual: kemasan gel sachet kecil warna hijau herbal, ikon daun sederhana
- Harga: tier menengah, Cash
- Sumber: Shop
```

```
### Energi Karbo Bar
- ItemId: Consumable_CarboEnergyBar
- Kategori: Consumable
- Properti gameplay: SpeedBurstMultiplier = 2.0, Duration = 5 detik
- Deskripsi visual: bungkus snack bar warna oranye-coklat, ikon gandum sederhana
- Harga: tier rendah, Cash
- Sumber: Shop/Quest Reward
```

---

## 6. Pet (lihat matrix probabilitas lengkap di `05_ROADMAP_TASKS.md` §2.2)

```
### Monyet Emas
- ItemId: Pet_Bromo_MonyetEmas
- Kategori: Pet
- Rarity: Common
- Properti gameplay: StaminaBuff = +5%
- Deskripsi visual: monyet kecil proporsi chibi, bulu keemasan solid, tanpa efek partikel (rarity Common = tanpa aura)
- Sumber: Catch di PetSpawnZone_Bromo
```

```
### Elang Jawa
- ItemId: Pet_GedePangrango_ElangJawa
- Kategori: Pet
- Rarity: Rare
- Properti gameplay: SpeedBuff = +10%
- Deskripsi visual: burung elang chibi, jambul khas di kepala (ciri pengenal Elang Jawa), warna coklat-putih, efek partikel bulu halus ringan saat terbang mengikuti pemain
- Sumber: Catch di Trail Gede Pangrango
```

```
### Harimau Sumatra
- ItemId: Pet_Toba_HarimauSumatra
- Kategori: Pet
- Rarity: Epic
- Properti gameplay: AccelerationBuff = +20%
- Deskripsi visual: harimau chibi bergaris oranye-hitam khas, efek partikel jejak kaki bercahaya ringan saat berlari mengikuti pemain (rarity Epic = efek gerak mulai terlihat)
- Sumber: Catch di area Trail Danau Toba
```

```
### Komodo
- ItemId: Pet_LabuanBajo_Komodo
- Kategori: Pet
- Rarity: Legendary
- Properti gameplay: SpeedBuff = +25%, StaminaBuff = +25%
- Deskripsi visual: komodo chibi dengan lidah bercabang kecil sebagai ciri khas, warna abu-hijau, aura partikel hijau redup mengelilingi badan (rarity Legendary = aura mulai permanen terlihat)
- Sumber: Catch di area Labuan Bajo (Fase 3)
```

```
### Garuda Emas
- ItemId: Pet_Rinjani_GarudaEmas
- Kategori: Pet
- Rarity: Secret
- Properti gameplay: AllStatsBuff = +50%
- Deskripsi visual: burung mitologis emas chibi dengan sayap besar bercahaya — DESAIN WAJIB berbeda jelas dari Lambang Garuda Pancasila resmi (lihat `09_ART_BIBLE.md` §4.1 poin 4): hindari perisai di dada, hindari jumlah bulu simbolis, hindari pita semboyan. Efek aura emas penuh + partikel bercahaya kuat (rarity Secret = efek visual paling mencolok di antara semua pet)
- Sumber: Catch di Rinjani Summit (rate 1%, area tersulit)
- Catatan produksi: WAJIB melalui review manusia sebelum final (lihat `01_AGENT_RULES.md` §7 dan `09_ART_BIBLE.md` §4.1 poin 4)
```

---

## 7. Prinsip Penentuan Harga (Placeholder, Bukan Final)

Karena angka harga final bergantung pada hasil economy balancing (lihat `06_LIVEOPS_AND_LAUNCH.md` §5), dokumen ini hanya memberi **tier relatif**, bukan angka pasti:

| Tier | Cash (indikatif) | Rubies (indikatif) | Contoh Item |
|---|---|---|---|
| Rendah | ratusan | — | Consumable dasar, aksesori kosmetik kecil |
| Menengah | ribuan | puluhan | Sepatu non-carbon, outfit budaya standar |
| Tinggi | puluhan ribu | ratusan | Sepatu carbon/trail, outfit detail tinggi |

Angka pasti ditentukan tim/agent setelah data economy health (§5 `06_LIVEOPS_AND_LAUNCH.md`) mulai terkumpul dari soft-launch — jangan finalisasi harga di tahap desain awal.

---

## 8. Checklist Item Sebelum Masuk Build Final
- [ ] `ItemId` unik & konsisten dengan naming convention `04_ASSET_GUIDELINES.md` §5.
- [ ] Properti gameplay disimpan sebagai `Attribute` pada model, dibaca oleh sistem terkait (bukan hardcode per nama di banyak tempat — lihat `03_CODING_STANDARDS.md` §4).
- [ ] Item dengan tanda "PERLU REVIEW MANUSIA" sudah direview sebelum build final.
- [ ] Outfit budaya sudah dikonfirmasi kosmetik murni (tidak ada stat buff) sesuai prinsip kesetaraan daerah.
- [ ] Untuk item random/gacha (Pet), rate sudah tercatat di `05_ROADMAP_TASKS.md` dan siap ditampilkan sebagai odds disclosure di UI (`00_PRD.md` §9).
