# AGENT_RULES.md
## Aturan Operasional untuk Agentic AI — Nusantara Runner (Roblox)

Dokumen ini adalah "kontrak kerja" untuk AI agent (atau tim AI agent) yang membangun game ini.
Baca file ini di awal SETIAP sesi kerja sebelum menyentuh kode/aset apa pun.

---

## 1. Prinsip Dasar (Tidak Bisa Ditawar)

1. **Server-authoritative, selalu.** Tidak ada nilai gameplay (speed, cash, catch pet, race checkpoint) yang boleh dipercaya dari client tanpa validasi ulang di server.
2. **Tidak ada breaking change diam-diam.** Perubahan pada `RemoteEvent` payload, `DataStore` schema, atau nama Attribute wajib dicatat di `CHANGELOG.md` (buat jika belum ada) sebelum lanjut ke task berikutnya.
3. **Ikuti urutan fase.** Jangan mengerjakan Fase 2/3 sebelum checklist Fase 1 di `05_ROADMAP_TASKS.md` selesai dan lulus self-check (§4 di bawah).
4. **Satu task = satu unit kerja yang bisa diuji.** Jangan menggabung banyak sistem sekaligus dalam satu commit/perubahan besar tanpa checkpoint di antaranya.
5. **Tidak mereproduksi merek/IP asli secara presisi.** Untuk nama, logo, atau model yang terinspirasi brand nyata, selalu ambil jarak kreatif (lihat `00_PRD.md` §8). Jika ragu, pilih opsi yang lebih jauh dari brand asli, bukan yang lebih dekat.
6. **Konten budaya diperlakukan dengan hormat.** Sebelum membuat aset kostum/atribut adat, cek `04_ASSET_GUIDELINES.md` §3 (Sensitivitas Budaya) — jangan mendesain berdasarkan asumsi/stereotip tanpa referensi yang jelas.

---

## 2. Urutan Kerja Wajib (Build Order)

Agent WAJIB mengerjakan dengan urutan berikut untuk setiap fitur baru, tidak boleh dibalik:

```
1. Data & Contract   → Definisikan schema DataStore / payload RemoteEvent dulu (lihat 02_ARCHITECTURE.md)
2. Server Logic      → Modul server (validasi, kalkulasi, state) sebelum ada UI
3. Map / Aset Statis  → Blockout ruang/level, placeholder part dulu, detail belakangan
4. Client Read-Only UI → Tampilkan data dari server (read-only) sebelum ada tombol aksi
5. Client Interaction → Tombol/aksi yang memanggil RemoteEvent
6. Polish & Asset Dinamis → Animasi, partikel, sound, model final
7. Self-Test Checklist → Jalankan checklist §4 sebelum menandai task selesai
```

Alasan: membangun map/aset detail duluan sebelum logika inti sering menyebabkan rework besar begitu formula/kontrak data berubah. Data & server logic adalah fondasi yang paling mahal untuk diubah belakangan, jadi dikerjakan lebih dulu.

---

## 3. Struktur Kerja per Sistem

Untuk setiap sistem baru (mis. PetSystem, RaceSystem), agent harus menghasilkan:

- `ModuleScript` di lokasi sesuai `02_ARCHITECTURE.md` §2 (jangan taruh sembarang folder).
- Tipe data eksplisit (`--!strict` + type annotation Luau) untuk semua fungsi publik modul.
- Minimal 1 fungsi validasi server yang menolak input tidak masuk akal (mis. `TimingScore` di luar 0–1, `CheckpointIndex` melompat urutan).
- Dokumentasi singkat (3–5 baris komentar) di atas modul: tujuan modul, siapa yang memanggil, dependency.
- Entry di `05_ROADMAP_TASKS.md` ditandai selesai (checkbox) HANYA setelah lolos §4.

---

## 4. Self-Test Checklist (Wajib sebelum menandai task "Selesai")

- [ ] Semua RemoteEvent yang terlibat divalidasi ulang di server (tipe data, range, rate limit)?
- [ ] Tidak ada nilai stat/cash yang bisa berubah hanya lewat client tanpa server acknowledge?
- [ ] Sudah dites dengan minimal 2 pemain simulasi (race condition dasar, mis. dua pemain rebut KOM bersamaan)?
- [ ] Path Workspace yang direferensikan pakai `CollectionService` tag atau path absolut yang didokumentasikan (bukan `WaitForChild` berantai yang rapuh)?
- [ ] Tidak ada `wait()` deprecated — gunakan `task.wait()`?
- [ ] Tidak ada magic number baru di luar `Constants` module?
- [ ] UI baru sudah dicek di aspect ratio mobile (bukan cuma layar PC)?
- [ ] Perubahan schema DataStore sudah backward-compatible (ada default value untuk field baru agar profile lama tidak error)?

Jika ada satu poin gagal, task belum boleh ditandai selesai — perbaiki dulu sebelum lanjut task berikutnya.

---

## 5. Larangan Eksplisit

- Jangan gunakan `ValueBase` (`IntValue`, `StringValue`, dst.) untuk state gameplay — gunakan **Attributes** atau state di modul server (lihat rekomendasi §16.5 draft awal, ini dipertahankan).
- Jangan gunakan `BasePart.Touched` untuk logika race checkpoint — gunakan kalkulasi jarak di `Heartbeat`.
- Jangan hardcode reward economy (Cash/Rubies) langsung di dalam UI script — semua angka reward berasal dari server response.
- Jangan membuat sistem baru yang belum ada di `00_PRD.md`/roadmap tanpa mencatat alasan penambahan (scope creep harus terlihat, bukan diam-diam masuk).
- Jangan reproduksi logo/siluet merek asli secara presisi pada model sepatu/gear.

---

## 6. Format Pelaporan Progres

Setiap sesi kerja, agent menutup dengan ringkasan singkat:

```
## Progress Report — <tanggal/sesi>
- Task selesai: [daftar, merujuk id task di 05_ROADMAP_TASKS.md]
- Task in-progress: [...]
- Blocker/keputusan yang butuh review manusia: [...]
- File yang diubah: [...]
```

Ini membantu agent (atau agent lain) berikutnya melanjutkan tanpa membaca ulang seluruh riwayat percakapan.

---

## 7. Kapan Harus Berhenti dan Bertanya ke Manusia

- Perubahan yang menyentuh monetisasi nyata (harga Robux, gamepass baru).
- Keputusan yang menyentuh isu IP/trademark (nama brand, desain logo).
- Keputusan yang menyentuh representasi budaya yang berpotensi sensitif (simbol adat/religius/nasional).
- Perubahan schema DataStore yang tidak backward-compatible (berisiko data loss pemain lama).
