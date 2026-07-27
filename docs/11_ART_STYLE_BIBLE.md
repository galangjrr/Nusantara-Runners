# ART_BIBLE.md
## Panduan Visual & Gaya — Nusantara Runner
*(Dokumen ini untuk artist/3D modeler — tidak berisi istilah teknis kode. Untuk aturan performa teknis, lihat `04_ASSET_GUIDELINES.md`.)*

---

## 1. Mood & Referensi Visual Keseluruhan

**Kata kunci gaya**: cerah, ramah anak, sedikit stylized (bukan realistis fotografis), warna saturasi tinggi khas game arcade Roblox populer (Pet Simulator X, Speed Run 4), TAPI tetap membawa identitas visual Indonesia yang jelas dikenali — bukan generic "tropical game" tanpa ciri khas.

**Yang DIHINDARI**:
- Gaya realistis/gelap/gritty (tidak cocok target usia & platform Roblox).
- Karikatur budaya yang terkesan mengejek/menyederhanakan (lihat §4).
- Palet warna kusam/desaturasi — game ini harus terasa "colorful & inviting" dari thumbnail sekalipun.

---

## 2. Palet Warna per Wilayah

| Wilayah | Warna Utama | Warna Aksen | Mood |
|---|---|---|---|
| Jakarta (Monas/GBK) | Abu urban terang, putih | Merah-putih (netral, bukan politis) | Energic, kota modern |
| Jawa Tengah/DIY (Borobudur/Prambanan) | Coklat batu candi, hijau lembut | Emas pucat (sunset) | Tenang, heritage |
| Bali | Biru laut, putih pasir | Emas ukiran | Segar, tropis |
| Sumatra (Toba) | Hijau danau, biru gelap | Coklat kayu | Sejuk, dataran tinggi |
| Jawa Timur/Madura (Suramadu) | Biru selat, abu jembatan | Kuning matahari | Megah, industrial-tropis |
| Trail/Gunung (Bromo/Rinjani/Gede/Merbabu) | Coklat tanah, hijau savana | Oranye kawah/sunrise | Petualangan |
| Papua Barat/NTT (Raja Ampat/Labuan Bajo) | Biru laut jernih, hijau karst | Karang oranye/pink | Eksotis, ultra-remote |

Prinsip: setiap wilayah harus bisa dikenali HANYA dari palet warna + siluet landmark, bahkan tanpa teks label — penting untuk keterbacaan cepat saat pemain lari (gameplay fast-paced).

---

## 3. Silhouette-First Design (Landmark)

Semua landmark (Monas, Borobudur, jembatan Suramadu, dll.) didesain dengan prinsip **siluet terlebih dahulu**: dari kejauhan/thumbnail, bentuknya harus langsung dikenali sebagai landmark tersebut hanya dari garis luarnya, meski detailnya disederhanakan drastis untuk performa (lihat budget di `04_ASSET_GUIDELINES.md` §2).

Checklist siluet:
- [ ] Bisa dikenali dalam ukuran thumbnail kecil (uji dengan screenshot di-resize ke 150px lebar).
- [ ] Tidak bergantung pada teks/tulisan untuk dikenali sebagai landmark tertentu.
- [ ] Proporsi disederhanakan (bukan skala 1:1 dari bangunan asli) demi keterbacaan gameplay, bukan akurasi arsitektur.

---

## 4. Panduan Representasi Budaya (WAJIB dibaca sebelum desain kostum/karakter)

Ini adalah bagian paling sensitif dari keseluruhan proyek karena game ini secara eksplisit mengangkat identitas budaya nyata dari berbagai daerah Indonesia.

### 4.1 Prinsip Utama
1. **Merayakan, bukan mereduksi.** Setiap elemen budaya (motif batik, udeng, songket, atribut Papua, Dayak, Bugis, tenun NTT/NTB) harus terasa seperti penghormatan ringan, bukan lelucon atau stereotip yang menyederhanakan satu daerah jadi satu ciri tunggal yang dangkal.
2. **Stilisasi konsisten, bukan realistis literal.** Karena karakter game berbentuk avatar Roblox (proporsi kartun), semua kostum budaya otomatis sudah "distilisasi" — jangan tambah elemen yang membuatnya terasa seperti reproduksi presisi pakaian upacara adat/ritual (lihat `04_ASSET_GUIDELINES.md` §3 untuk aturan teknis lengkapnya).
3. **Riset dulu, desain kemudian.** Sebelum membuat aset kostum daerah tertentu yang belum familiar, cari referensi visual yang jelas (bukan menebak dari asosiasi umum/stereotip populer). Jika referensi tidak tersedia/tidak yakin, tandai item tersebut untuk **review manusia** sebelum lanjut produksi (lihat `01_AGENT_RULES.md` §7).
4. **Simbol nasional diperlakukan khusus.** Elemen yang berasosiasi dengan simbol negara (mis. burung Garuda) didesain sebagai karakter fiksi/mitologis yang jelas berbeda dari Lambang Garuda Pancasila resmi (hindari perisai, jumlah bulu simbolis, pita semboyan).

### 4.2 Proses Desain per Kostum Daerah

```
1. Riset referensi visual (2-3 sumber berbeda per daerah)
2. Sketsa stilisasi awal → identifikasi elemen KHAS (bukan generik "budaya Indonesia")
3. Cek terhadap prinsip §4.1 (terutama poin 2 & 4)
4. Review internal (jika ragu → tandai untuk review manusia)
5. Produksi model final
```

### 4.3 Daftar Kostum & Catatan Khusus

| Daerah | Elemen | Catatan Desain |
|---|---|---|
| Jawa | Batik Megamendung/Parang, Blangkon | Motif batik boleh detail (bukan atribut sakral), aman untuk didetailkan |
| Bali | Udeng, Kamen | Udeng dipakai sehari-hari selain upacara, relatif aman, tetap stilisasi warna cerah |
| Sumatra/Melayu | Songket, Tanjak | Tanjak historis terasosiasi kebangsawanan — desain sebagai versi "atletik" yang jelas game-ified, bukan replika formal |
| Papua | Mahkota Bulu Cendrawasih, Rumbai | **Perlu kehati-hatian tinggi** — bulu Cendrawasih & rumbai punya makna adat mendalam; desain versi jelas fantasi (warna non-natural, bentuk disederhanakan drastis) agar tidak terbaca sebagai reproduksi atribut adat asli |
| Dayak | Rompi Kulit Kayu, Bulu Enggang | Sama seperti Papua — enggang adalah simbol adat penting Dayak, stilisasi kuat diperlukan |
| Bugis | Baju Bodo, Passapu | Baju Bodo punya makna status sosial di budaya asli — desain sebagai versi kasual/atletik yang jelas berbeda dari pakaian formal adat |
| NTT/NTB | Tenun Ikat | Motif tenun aman untuk didetailkan sebagai pola tekstil (mirip prinsip batik) |

---

## 5. Gaya Pet

- Semua pet memakai proporsi "chibi/cute" konsisten (kepala besar, badan kecil) — TIDAK realistis anatomis, agar terasa sebagai maskot koleksi, bukan representasi hewan liar yang serius (menghindari kesan game ini mendorong perburuan satwa liar sungguhan).
- Efek rarity (Common → Secret) dibedakan lewat **cahaya/partikel/warna**, bukan lewat membuat pet terlihat "lebih ganas" — supaya tetap ramah anak di semua tingkat rarity.
- Komodo & Harimau Sumatra (satwa dilindungi asli) didesain jelas sebagai versi maskot lucu — hindari referensi ke isu konservasi/perburuan liar secara serius dalam flavor text (game ini merayakan kekayaan hayati, bukan membahas isu perburuan nyata).

---

## 6. Tipografi & UI Visual
- Font UI: sans-serif rounded, mudah dibaca di layar kecil (mobile), hindari font dekoratif/kaligrafi berat untuk teks fungsional (angka stat, tombol) — dekorasi tradisional cukup di elemen non-fungsional (border/frame kosmetik).
- Warna UI HUD: kontras tinggi terhadap background gameplay (karena background berubah-ubah per Sub-Place) — gunakan outline/shadow konsisten pada teks, bukan bergantung pada satu warna latar tetap.

---

## 7. Checklist Final Sebelum Aset Budaya Dianggap Selesai
- [ ] Sudah melalui proses riset §4.2 (bukan tebakan/stereotip).
- [ ] Lolos prinsip §4.1 (stilisasi, bukan reproduksi presisi; simbol nasional diperlakukan khusus).
- [ ] Untuk daerah dengan catatan khusus (§4.3: Papua, Dayak, Bugis) — sudah direview manusia sebelum masuk build final.
- [ ] Konsisten dengan gaya "cerah, ramah anak, stylized" di §1, bukan realistis/gelap.
