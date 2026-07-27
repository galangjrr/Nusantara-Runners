# MAP_DESIGN_SPECS.md
## Prompt & Spesifikasi Pembangunan Map/Landmark — Nusantara Runner

Dokumen ini adalah **prompt siap pakai** untuk agent yang mengerjakan blockout & detailing map. Setiap landmark punya spesifikasi: silhouette, dimensi, material/warna, hierarki part, dan daftar prop. Gunakan bersama `04_ASSET_GUIDELINES.md` (budget performa) dan `09_ART_BIBLE.md` (palet warna & gaya).

**Penting soal akurasi**: spesifikasi dimensi & bentuk di bawah adalah **interpretasi game-ified/stylized**, bukan blueprint arsitektur presisi — tujuannya landmark dikenali lewat siluet & warna, bukan replika 1:1. Ini juga sejalan dengan `00_PRD.md` §8 soal menjaga jarak dari reproduksi presisi (berlaku juga untuk bangunan publik, agar desain tetap terasa "gamey" dan efisien secara performa).

---

## 0. Konvensi Global (Wajib Dibaca Sebelum Membangun Map Apa Pun)

### 0.1 Skala
- 1 stud Roblox ≈ representasi ~0.28 meter (standar humanoid Roblox: karakter tinggi ±5 stud ≈ orang dewasa).
- Landmark BESAR (Monas, Borobudur) tidak dibuat di skala asli 1:1 — gunakan **skala kompresi 40–60% dari rasio asli** supaya tetap terasa megah tapi tidak menghabiskan part budget dan tidak membuat jarak lari terasa tidak masuk akal secara gameplay. Contoh: jika tinggi asli suatu landmark adalah X, gunakan tinggi target sekitar 0.4–0.6 × X dalam satuan stud yang proporsional terhadap karakter.

### 0.2 Hierarki Workspace (wajib konsisten)
```
Workspace/
└── Map/
    ├── Hub_GBKSenayan/
    │   ├── Terrain_Ground
    │   ├── Landmarks/
    │   ├── Gym/
    │   ├── Shops/
    │   ├── TravelTerminal/
    │   └── SpawnPoints/
    ├── SubPlace01_MonasGBK/
    │   ├── Landmarks/
    │   ├── RaceTrack/
    │   ├── Checkpoints/  (tagged "RaceCheckpoint")
    │   └── KOMSegments/  (tagged "KOMSegmentStart"/"KOMSegmentEnd")
    ├── SubPlace02_BorobudurPrambanan/
    ├── SubPlace03_BaliToba/
    ├── SubPlace04_SuramaduAmpera/
    ├── SubPlace05_BromoRinjani/
    └── SubPlace06_RajaAmpatLabuanBajo/
```
Setiap Sub-Place adalah folder terpisah di bawah `Map`, bukan campur di satu folder generik — ini penting untuk `StreamingEnabled` bekerja rapi per area (lihat `02_ARCHITECTURE.md` §8).

### 0.3 Material & Ground Rules Umum
- Ground utama: `Terrain` (bukan Part flat besar) untuk area luas agar bisa dipahat (bukit, pantai) dan mendukung streaming.
- Path/rute lari: `Part` dengan material `Concrete`/`Cobblestone`/`Sand` sesuai tema, lebar konsisten **12–16 stud** (cukup untuk beberapa pemain berdampingan tanpa dempet).
- Semua part statis non-gameplay di-set `Anchored = true`, `CanCollide` sesuai kebutuhan (dekorasi murni non-collide untuk kurangi physics load).

### 0.4 Template Prompt per Landmark
Setiap entri landmark di bawah mengikuti format ini — pakai sebagai instruksi langsung ke agent pembangun map:

```
### [Nama Landmark]
- Peran gameplay: [Hub / Start Line / Checkpoint / Landmark latar / Zona pet]
- Deskripsi siluet: [bentuk dasar yang harus dikenali dari kejauhan]
- Dimensi target (stud): [Panjang x Lebar x Tinggi]
- Material & warna utama: [daftar]
- Hierarki part: [breakdown]
- Prop pendukung: [daftar objek kecil di sekitarnya]
- Tag/Attribute gameplay: [CollectionService tag yang wajib dipasang]
- Catatan performa: [part count target, LOD]
```

---

## 1. HUB UTAMA — GBK Senayan

### Peran
Pusat sosial: spawn awal, gym, shop, gacha, terminal travel ke semua Sub-Place. Map ini paling sering dikunjungi pemain → prioritas performa tertinggi.

### Deskripsi Siluet
Kompleks dengan 1 struktur stadion oval besar sebagai landmark utama (elemen pengenal: bentuk oval/elips raksasa dengan atap melengkung terbuka di tengah, mengelilingi lapangan hijau), dikelilingi area terbuka (plaza) yang menjadi ruang sosial pemain, dengan beberapa bangunan pendukung (gym, shop) di sekelilingnya berskala lebih kecil.

### Dimensi Target
- Struktur stadion utama (siluet, bukan interior detail): ±300 x 220 x 60 stud (oval).
- Plaza terbuka di sekitarnya: radius ±150 stud dari titik tengah spawn.
- Bangunan pendukung (Gym, Shop, Gacha): masing-masing ±40 x 40 x 20 stud, disebar melingkar di tepi plaza agar mudah dijangkau dari titik spawn tengah.

### Material & Warna Utama
- Struktur stadion: `Concrete` abu terang untuk dinding luar, aksen garis merah-putih tipis (netral, dekoratif, bukan elemen politis) pada trim atap.
- Plaza: `Concrete`/`Slate` abu muda untuk jalur pejalan, aksen hijau (`Grass`) di area taman tengah.
- Bangunan pendukung: warna berbeda per fungsi agar mudah dibedakan dari kejauhan — Gym (biru), Shop (kuning/emas), Gacha (ungu/pink sebagai penanda "spesial").

### Hierarki Part
```
Hub_GBKSenayan/
├── Landmarks/
│   └── StadiumOval (MeshPart/UnionOperation, siluet oval + atap melengkung terbuka)
├── Gym/
│   ├── GymBuilding (struktur)
│   └── TreadmillArea/ (berisi Part bertag "Treadmill", susun grid 4x5)
├── Shops/
│   ├── ShoeShopBooth (bertag "ShopVendor")
│   └── WarungSolBooth (bertag "ShopVendor")
├── GachaPetBooth/
├── TravelTerminal/
│   ├── BusStopPortal (untuk Sub-Place jarak dekat: Monas, Borobudur, Bali)
│   └── AirportGatePortal (untuk Sub-Place jarak jauh: Suramadu, Raja Ampat, Trail)
└── SpawnPoints/
    └── SpawnLocation (di tengah plaza, menghadap StadiumOval agar first impression langsung ke landmark utama)
```

### Prop Pendukung
- Bangku taman (10–15 unit tersebar di plaza).
- Lampu jalan bergaya modern (dekorasi, `PointLight` dibatasi sesuai budget di `04_ASSET_GUIDELINES.md` §2).
- Papan pengumuman event (dekat spawn, bisa menampilkan info event mingguan/leaderboard — terhubung ke `LeaderboardSystem` untuk data live, tapi part fisiknya statis).
- Bendera/umbul-umbul warna-warni di sepanjang plaza (dekorasi murni, non-collide).

### Tag/Attribute Gameplay
- `Treadmill` pada semua part latihan di Gym.
- `ShopVendor` pada semua booth.
- Portal travel memakai `ClickDetector`/`ProximityPrompt` custom (bukan CollectionService tag, karena aksinya unik per portal — didefinisikan di `RemoteContracts.lua`).

### Catatan Performa
- Target part count non-streaming: ≤ 3,000 (lihat budget di `04_ASSET_GUIDELINES.md` §2) — karena hub selalu ramai pemain bersamaan, prioritaskan union/mesh gabungan untuk struktur stadion daripada ratusan part kecil terpisah.
- `StreamingEnabled` tetap aktif meski hub relatif kompak, untuk jaga-jaga jumlah pemain besar bersamaan.

---

## 2. SUB-PLACE 1 — Monas & GBK (Race 5K)

### 2.1 Landmark: Monas (Monumen Nasional)

```
### Monas
- Peran gameplay: Landmark utama + area sekitar start line race 5K "Monas Car Free Day"
- Deskripsi siluet: menara tunggal ramping menjulang dari dasar persegi lebar, dengan elemen "api obor emas" di puncak sebagai penanda ikonik paling dikenali dari kejauhan
- Dimensi target: dasar 40x40 stud, menara meruncing ke atas hingga tinggi ±180 stud, elemen puncak (obor) ±15 stud tambahan
- Material & warna utama: badan menara `Marble`/`Concrete` putih-krem, elemen puncak emas (`Metal`/`Neon` warna kuning-emas agar tetap terlihat menyala dari jauh tanpa butuh light source berat)
- Hierarki part:
  Monas/
  ├── BaseStructure (persegi lebar, bisa dimasuki jadi area plaza kecil di sekitarnya)
  ├── TowerBody (union tunggal, bentuk meruncing)
  └── TorchTop (mesh kecil terpisah, warna emas/neon)
- Prop pendukung: pagar rendah dekoratif mengelilingi dasar, area taman/rumput di sekitar dasar menara, beberapa bangku
- Tag/Attribute gameplay: area di sekitar dasar Monas ditandai sebagai titik dekat Start Line race (Part start line terpisah, tag "RaceCheckpoint" index 0)
- Catatan performa: TowerBody sebaiknya 1 MeshPart/Union tunggal (bukan puluhan part bertumpuk) untuk efisiensi; visible dari jarak jauh sebagai landmark orientasi arah lari
```

### 2.2 Landmark Pendukung: Area GBK dalam Sub-Place ini
Karena Sub-Place 1 menggabungkan "Monas & GBK" sebagai satu rute 5K, area GBK di sini cukup direpresentasikan sebagai **segmen rute** (jalur lari melewati siluet oval stadion versi lebih kecil/simplified dari yang di Hub), bukan struktur penuh — karena fungsinya di sini sebagai latar rute, bukan hub sosial.

### 2.3 Race Track & Checkpoint (5K Monas Car Free Day)
- Rute berbentuk loop/out-and-back sepanjang jalur yang menghubungkan area Monas → segmen jalan (mengambil tema "Car Free Day": jalan lebar bebas kendaraan, dihiasi orang-orangan/prop dekoratif "penonton" statis non-NPC penuh untuk suasana ramai tanpa beban performa NPC AI).
- Checkpoint (tag `RaceCheckpoint`, dengan Attribute `RaceId="5K_MonasCFD"` dan `CheckpointIndex` berurutan 0–5): ditempatkan di titik: Start (dasar Monas) → Checkpoint 1 (pertigaan jalan) → Checkpoint 2 (dekat siluet GBK) → Checkpoint 3 (titik balik) → Checkpoint 4 (kembali ke jalan utama) → Finish (kembali ke dasar Monas, garis finish visual berbeda warna dari start).

### 2.4 KOM Segment (Stravi)
- "Segment Sprint Monas 200m": bagian lurus sepanjang ±200 stud terkonversi (bukan literal 200 meter, tapi cukup panjang untuk terasa sebagai sprint singkat dalam gameplay) di jalan utama Car Free Day.
- Tag `KOMSegmentStart` di titik awal segmen, `KOMSegmentEnd` di titik akhir — ditandai visual jelas di dunia (mis. gapura/banner kecil bertuliskan "Segment Start/Finish" agar pemain sadar sedang memasuki zona kompetisi).

---

## 3. SUB-PLACE 2 — Borobudur & Prambanan (Race 10K)

```
### Candi Borobudur
- Peran gameplay: Landmark + titik checkpoint tengah race 10K "Borobudur Heritage Run"
- Deskripsi siluet: struktur berundak (stepped-pyramid) dengan beberapa stupa kecil di setiap tingkat dan 1 stupa besar di puncak — dikenali dari bentuk berundak-tingkat yang jelas dari kejauhan
- Dimensi target: dasar 60x60 stud, tinggi total (semua undakan + stupa puncak) ±50 stud, 4-5 tingkat undakan yang disederhanakan (bukan jumlah tingkat asli persis)
- Material & warna utama: `Rock`/`Concrete` abu-coklat gelap untuk seluruh struktur, dengan tekstur ukiran disederhanakan jadi pola relief dekoratif ringan (bukan detail ukiran presisi)
- Hierarki part:
  CandiBorobudur/
  ├── BaseTier (tingkat dasar, terbesar)
  ├── MiddleTiers (union beberapa tingkat menengah)
  ├── TopStupas (kumpulan stupa kecil, bisa 1 mesh berulang/clone ringan)
  └── MainStupa (stupa puncak, sedikit lebih besar dari yang lain)
- Prop pendukung: pohon tropis di sekitar dasar, jalur setapak menuju candi, beberapa bangku wisata
- Tag/Attribute gameplay: checkpoint tengah race 10K di area dasar candi (RaceCheckpoint index sesuai urutan rute)
- Catatan performa: TopStupas gunakan teknik instance berulang dari 1 mesh dasar untuk hemat memory, bukan model unik per stupa
```

```
### Candi Prambanan
- Peran gameplay: Landmark + area finish race 10K "Prambanan Sunset Race", tema pencahayaan sunset
- Deskripsi siluet: kompleks beberapa menara ramping-tinggi berbentuk kerucut memanjang (silhouette "menjulang & ramping", kontras dengan Borobudur yang "berundak lebar") — menara utama di tengah lebih tinggi dari menara-menara pendamping di sekitarnya
- Dimensi target: menara utama tinggi ±70 stud, menara pendamping ±40-50 stud, tersusun dalam formasi cluster (1 menara utama dikelilingi beberapa menara lebih kecil)
- Material & warna utama: `Rock` abu-coklat (senada Borobudur untuk kesan "candi Jawa" konsisten), dengan pencahayaan `Lighting.ClockTime` diset ke golden hour (sunset) khusus di map ini sesuai tema "Sunset Race"
- Hierarki part:
  CandiPrambanan/
  ├── MainTower (menara pusat, tertinggi)
  ├── SecondaryTowers/ (beberapa menara lebih kecil mengelilingi, union/instance)
  └── FinishLineArea (plaza kecil di depan kompleks candi sebagai garis finish visual)
- Prop pendukung: pencahayaan ambient sunset (Lighting property, bukan model 3D matahari), siluet pohon di kejauhan sebagai latar
- Tag/Attribute gameplay: Finish Line race 10K Prambanan di plaza depan kompleks
- Catatan performa: gunakan 1 Lighting setting global untuk seluruh Sub-Place ini (bukan light instance per menara) agar efek sunset konsisten dan ringan
```

---

## 4. SUB-PLACE 3 — Bali Coastal & Danau Toba (Race 21K)

```
### Bali Coastal (Kuta–Sanur)
- Peran gameplay: Rute pantai untuk race 21K "Bali Beach Run"
- Deskripsi siluet: garis pantai panjang dengan air laut biru jernih di satu sisi, jalur lari berpasir/beton di sisi darat, dihiasi gapura/pura kecil bergaya Bali sebagai penanda titik-titik rute (bukan replika pura asli fungsional, sekadar elemen dekoratif bergaya)
- Dimensi target: rute pantai memanjang ±800-1000 stud (dipecah beberapa segmen dengan checkpoint), lebar jalur lari 12-16 stud, air laut menggunakan Terrain Water Roblox bawaan
- Material & warna utama: `Sand` untuk area pantai, `Terrain Water` untuk laut, gapura kecil dari `WoodPlanks`/`Rock` dengan aksen emas ukiran sederhana
- Hierarki part:
  BaliCoastal/
  ├── BeachTerrain (Terrain, pantai + air)
  ├── RunPath (jalur lari sepanjang pantai)
  ├── DecorativeGates/ (gapura kecil di titik checkpoint, instance berulang dari 1-2 model dasar)
  └── Checkpoints/ (RaceCheckpoint tag sesuai jarak 21K)
- Prop pendukung: payung pantai, pohon kelapa (instance berulang), perahu nelayan kecil sebagai dekorasi di tepi air
- Catatan performa: gunakan Terrain Water bawaan (bukan custom mesh air animasi) sesuai `04_ASSET_GUIDELINES.md` §4.5
```

```
### Danau Toba
- Peran gameplay: Rute dataran tinggi untuk race 21K "Half Marathon Danau Toba"
- Deskripsi siluet: danau besar dikelilingi perbukitan hijau, jalur lari mengikuti tepi danau dengan pemandangan Pulau Samosir (siluet pulau kecil di tengah danau) sebagai landmark visual arah
- Dimensi target: danau (Terrain Water) radius besar sebagai latar (tidak seluruhnya perlu dijelajahi, cukup terlihat), jalur lari di tepi ±700-900 stud
- Material & warna utama: `Grass` hijau untuk perbukitan, `Terrain Water` biru gelap (danau vulkanik, warna sedikit lebih dalam dari laut Bali untuk pembeda visual), rumah adat kecil bergaya "atap runcing melengkung" sebagai dekorasi titik checkpoint (bukan replika presisi rumah adat, versi stilisasi sederhana)
- Hierarki part:
  DanauToba/
  ├── LakeTerrain (Terrain, danau + perbukitan sekitar)
  ├── SamosirSilhouette (pulau kecil di tengah danau, siluet saja, tidak perlu dijelajahi)
  ├── RunPath (jalur tepi danau)
  └── Checkpoints/
- Prop pendukung: pohon pinus dataran tinggi, dekorasi rumah adat kecil (stilisasi) di titik-titik checkpoint
- Catatan performa: SamosirSilhouette cukup sebagai objek jauh low-poly (bukan area yang dimuat detail penuh, karena tidak dikunjungi pemain)
```

---

## 5. SUB-PLACE 4 — Suramadu & Ampera (Race 42K)

```
### Jembatan Suramadu
- Peran gameplay: Rute utama race 42K "Full Marathon Suramadu Bridge"
- Deskripsi siluet: jembatan panjang lurus dengan menara pylon kabel-tarik (cable-stayed) di beberapa titik sebagai penanda visual berulang sepanjang rute — dikenali dari pola pylon-kabel yang berulang, bukan detail struktural presisi
- Dimensi target: panjang jembatan direpresentasikan ±1200-1500 stud (dikompresi dari panjang asli yang jauh lebih besar), lebar jalur lari di jembatan 16-20 stud (lebih lebar dari rute biasa karena ini rute utama 42K yang ramai), tinggi pylon ±80-100 stud
- Material & warna utama: `Metal`/`Concrete` abu-biru untuk struktur jembatan, kabel pylon `Metal` tipis (Part kecil memanjang, bukan mesh kompleks)
- Hierarki part:
  JembatanSuramadu/
  ├── BridgeDeck (union panjang, jalur utama)
  ├── Pylons/ (beberapa unit berulang sepanjang jembatan, instance dari 1 model dasar)
  ├── CableLines/ (Part tipis memanjang dari pylon ke deck, bisa disederhanakan drastis jumlahnya demi performa)
  └── Checkpoints/
- Prop pendukung: lampu jalan di sepanjang jembatan (instance berulang, PointLight dibatasi jumlahnya sesuai budget), pembatas jalan
- Catatan performa: karena ini rute terpanjang (42K), WAJIB StreamingEnabled dan LOD pylon (versi low-poly untuk pylon yang jauh dari posisi pemain saat ini)
```

```
### Jembatan Ampera
- Peran gameplay: Rute race 42K "Full Marathon Ampera Bridge" (Palembang)
- Deskripsi siluet: jembatan dengan struktur menara kembar vertikal di tengah bentang (ciri khas: 2 menara besar berdampingan di titik tengah jembatan) melintasi sungai lebar
- Dimensi target: panjang jembatan ±600-800 stud, menara kembar tinggi ±90 stud di titik tengah, sungai di bawahnya (Terrain Water) lebar ±150-200 stud
- Material & warna utama: `Metal` merah-oranye untuk struktur menara (ciri khas warna ikonik), `Concrete` untuk jalur jembatan, `Terrain Water` coklat-kehijauan (sungai, beda warna dari laut/danau untuk variasi visual)
- Hierarki part:
  JembatanAmpera/
  ├── TwinTowers (2 menara kembar di tengah, elemen paling dikenali)
  ├── BridgeDeck
  ├── RiverTerrain (Terrain Water di bawah jembatan)
  └── Checkpoints/
- Prop pendukung: perahu kecil di sungai sebagai dekorasi, bangunan tepi sungai bergaya rumah panggung sederhana sebagai latar
- Catatan performa: TwinTowers adalah fokus visual utama — boleh detail lebih tinggi dari elemen lain di map ini, tapi tetap dalam budget total
```

---

## 6. SUB-PLACE 5 — Trail Bromo & Rinjani (Trail + Pet Hunting Zone)

```
### Gunung Bromo
- Peran gameplay: Trail run + zona spawn pet Common ("Monyet Emas")
- Deskripsi siluet: kawah gunung berbentuk kerucut terpotong (crater) di tengah lautan pasir luas (kawasan datar berpasir mengelilingi gunung) — dikenali dari kombinasi "gunung kerucut + hamparan pasir luas di sekitarnya"
- Dimensi target: area lautan pasir radius ±500 stud, gunung kerucut tinggi ±150 stud dengan bagian puncak berongga (kawah)
- Material & warna utama: `Sand` abu-coklat untuk lautan pasir (bukan pasir pantai kuning cerah — beda warna dari Bali), `Rock` gelap untuk badan gunung, efek asap tipis dari puncak (particle emitter ringan, jumlah dibatasi)
- Hierarki part:
  GunungBromo/
  ├── SandSea (Terrain, area pasir luas)
  ├── VolcanoCone (union, bentuk kerucut dengan rongga puncak)
  ├── TrailPath (jalur trail lari mengelilingi/mendaki sebagian gunung)
  └── PetSpawnZone_Bromo (tag "PetSpawnZone", area untuk Monyet Emas)
- Prop pendukung: pura kecil di kaki gunung (stilisasi, dekoratif), kuda/jeep dekoratif statis (non-interaktif) sebagai suasana wisata
- Catatan performa: SandSea sebagai Terrain datar luas cukup ringan; VolcanoCone jadi fokus detail utama
```

```
### Gunung Rinjani
- Peran gameplay: Trail run summit + zona spawn pet Secret ("Garuda Emas")
- Deskripsi siluet: gunung tinggi dengan danau kawah berwarna di dekat puncak (danau segara anak) — dikenali dari "gunung tinggi + danau kecil berwarna di ketinggian", kontras dari Bromo yang tidak memiliki danau puncak
- Dimensi target: tinggi gunung keseluruhan (dikompresi) ±250 stud (tertinggi di antara semua trail map, sesuai tema "Summit" sebagai tantangan trail tersulit), danau kawah radius ±60 stud dekat puncak
- Material & warna utama: `Rock` abu gelap untuk lereng, `Grass`/`Snow`-tint ringan di ketinggian tertentu untuk variasi vegetasi (bukan salju asli karena gunung tropis, gunakan warna hijau pucat/abu terang), danau kawah `Terrain Water` hijau kebiruan
- Hierarki part:
  GunungRinjani/
  ├── MountainBody (union besar, mengikuti kontur naik dari kaki ke puncak)
  ├── SummitLake (danau kawah dekat puncak)
  ├── TrailPath (jalur trail terpanjang & paling menanjak di antara semua trail map)
  └── PetSpawnZone_RinjaniSummit (tag "PetSpawnZone", khusus dekat area puncak — sesuai desain "Garuda Emas hanya di titik tersulit")
- Prop pendukung: batu-batu besar sepanjang jalur pendakian (dekorasi + penanda visual jalur), bendera checkpoint pendakian
- Catatan performa: karena ini rute terpanjang/tertinggi, gunakan LOD bertingkat berdasarkan jarak — detail penuh hanya dalam radius pemain, bagian jauh di atas/bawah cukup siluet
```

---

## 7. SUB-PLACE 6 — Raja Ampat & Labuan Bajo (Ultra 100K) — Template Ringkas (Fase 3)

```
### Raja Ampat Karst
- Peran gameplay: Ultra 100K, area terluas di seluruh game
- Deskripsi siluet: gugusan pulau karst kecil-kecil berbentuk kubah/jamur menonjol dari laut biru jernih (ciri paling dikenali: banyak pulau kecil berbentuk "jamur/kubah" tersebar di air)
- Dimensi target: perlu direncanakan ulang saat Fase 3 dimulai (area ultra 100K butuh perencanaan rute non-linear yang lebih kompleks, sebaiknya dirancang detail setelah Fase 1-2 selesai dan tim punya pengalaman rute lebih panjang)
- Catatan: DETAIL LENGKAP DITUNDA ke awal Fase 3 — cukup dicatat sebagai placeholder arah desain, karena keputusan multi-place architecture (lihat `02_ARCHITECTURE.md` §8) perlu diputuskan lebih dulu sebelum membangun map seluas ini
```

```
### Labuan Bajo Komodo
- Peran gameplay: Ultra 100K + area tematik satwa Komodo (Legendary pet)
- Deskripsi siluet: perbukitan sabana kering kecoklatan berpadu garis pantai berpasir merah muda (pink beach, ciri khas ikonik area ini)
- Dimensi target: sama seperti Raja Ampat, ditunda perencanaan detailnya ke Fase 3
- Catatan: PetSpawnZone Komodo sebaiknya di area sabana terbuka (bukan pantai), agar minigame lasso punya ruang gerak cukup
```

---

## 8. Checklist Sebelum Map Dianggap Selesai
- [ ] Siluet landmark dikenali dalam uji thumbnail kecil (lihat `09_ART_BIBLE.md` §3).
- [ ] Hierarki Workspace mengikuti struktur §0.2 (tidak taruh sembarang folder).
- [ ] Semua tag CollectionService yang disebutkan di tiap landmark sudah terpasang di part yang tepat.
- [ ] Part count & light count dalam budget `04_ASSET_GUIDELINES.md` §2.
- [ ] Warna & material sesuai palet wilayah di `09_ART_BIBLE.md` §2.
- [ ] `StreamingEnabled` diuji tidak menyebabkan pop-in kasar dalam radius kamera normal.
- [ ] Untuk landmark dengan catatan performa khusus (union, instance berulang, LOD) — sudah diimplementasikan, bukan part terpisah manual berulang.
