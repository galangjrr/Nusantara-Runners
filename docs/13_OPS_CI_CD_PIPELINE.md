# CI_CD_PIPELINE.md
## Pipeline Build & Publish Otomatis — Nusantara Runner

---

## 1. Tujuan
Menghindari proses "copy manual file ke Studio lalu publish manual" yang rawan human error (lupa sync, publish versi lama, tidak ada jejak versi mana yang live). Pipeline ini membuat proses build → test → publish bisa diulang dengan hasil konsisten, dan bisa dijalankan oleh agent AI tanpa campur tangan manual di setiap langkah.

---

## 2. Komponen Pipeline

```
Git Push/Merge
     │
     ▼
GitHub Actions Trigger
     │
     ├─▶ Lint & Format Check (Selene + StyLua)
     │
     ├─▶ Build (Rojo build → .rbxlx/.rbxl)
     │
     ├─▶ Automated Test (TestEZ — lihat 08_TESTING_STRATEGY.md)
     │
     ├─▶ [Jika branch = staging] Publish ke Private/Staging Place (Open Cloud API)
     │
     └─▶ [Jika branch = main + tag rilis manual] Publish ke Production Place (Open Cloud API)
```

## 3. Environment / Place Terpisah

| Environment | Place ID | Tujuan | Siapa yang Akses |
|---|---|---|---|
| **Dev/Local** | Studio lokal | Development harian, iterasi cepat | Individual agent/developer |
| **Staging** | Place ID terpisah, private | Playtest internal (Fase Tahap A di `06_LIVEOPS_AND_LAUNCH.md`) | Tim internal via Private Server link |
| **Production** | Place ID publik final | Live game | Publik |

**Aturan penting**: TIDAK PERNAH publish langsung ke Production dari local Studio manual setelah pipeline ini aktif — semua perubahan production wajib lewat Staging dulu dan lolos automated test.

## 4. Konfigurasi GitHub Actions (contoh kerangka)

```yaml
name: build-and-check
on:
  push:
    branches: [main, staging]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Selene
        run: cargo install selene # atau pakai binary release
      - name: Run Lint
        run: selene src/

  build:
    needs: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Rojo
        run: cargo install rojo
      - name: Build Place File
        run: rojo build default.project.json -o build/place.rbxlx

  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Run TestEZ Suite
        run: ./scripts/run-tests.sh # jalankan lewat run-in-roblox atau CLI headless

  publish-staging:
    if: github.ref == 'refs/heads/staging'
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Publish via Open Cloud API
        env:
          ROBLOX_API_KEY: ${{ secrets.ROBLOX_STAGING_API_KEY }}
        run: ./scripts/publish.sh --place-id $STAGING_PLACE_ID
```

## 5. Publish via Open Cloud API (bukan publish manual Studio)

- Gunakan endpoint `POST /universes/{universeId}/places/{placeId}/versions` dari Roblox Open Cloud API dengan API Key yang di-scope HANYA untuk publish place (bukan full access token).
- API Key disimpan sebagai **GitHub Secrets**, tidak pernah di-commit ke repo dalam bentuk apa pun (termasuk di file config contoh/dokumentasi).
- Publish ke Production **wajib manual trigger** (mis. lewat Git tag `v1.0.0` atau tombol "Run workflow" manual), TIDAK auto-publish setiap push ke `main` — ini mencegah perubahan yang belum divalidasi manusia langsung live ke pemain.

## 6. Versioning & Rollback

- Setiap publish ke Production dicatat di `CHANGELOG.md` dengan format:
```
## v1.2.0 — 2026-XX-XX
- Fitur: Sub-Place 3 Bali Coastal dirilis
- Fix: RaceCheckEvent race condition saat 2 pemain checkpoint bersamaan
- Schema DataStore: SchemaVersion 1 → 2 (tambah field Coach.DailyResetAt)
```
- Roblox otomatis menyimpan version history place — jika publish baru bermasalah parah, **rollback ke versi sebelumnya lewat Studio (File → Place Version History)** sambil root cause diperbaiki di staging.
- Perubahan `SchemaVersion` DataStore HARUS backward-compatible (lihat `01_AGENT_RULES.md` §4) — rollback place version TIDAK me-rollback data pemain yang sudah tersimpan dengan schema baru, jadi migrasi data harus dirancang satu arah yang aman.

## 7. Checklist Sebelum Setup Pipeline Dianggap Siap

- [ ] Lint & format check berjalan otomatis di setiap push/PR.
- [ ] Build Rojo berhasil tanpa error di CI, bukan cuma di local machine developer.
- [ ] Automated test (lihat `08_TESTING_STRATEGY.md`) berjalan sebagai gate sebelum publish diizinkan.
- [ ] Publish ke Staging otomatis dari branch `staging`.
- [ ] Publish ke Production HANYA lewat trigger manual/tag rilis, dengan API Key ter-scope minimal.
- [ ] `CHANGELOG.md` ter-update di setiap publish Production.
