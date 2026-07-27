# 00_PROMPT_EXECUTION_GUIDE.md
## Panduan Step-by-Step Prompting AI Agent — Nusantara Runner

Dokumen ini berisi urutan eksekusi dan template prompt persis untuk diberikan ke AI agent di setiap tahap pengembangan game Roblox Nusantara Runner.

---

## 📋 Peta Urutan File Dokumen (Renamed by Role)

| No | Nama File Baru | Peran Utama | Kapan Di-mention dalam Prompt |
|---|---|---|---|
| 01 | `01_RULE_AGENT_OPERATIONAL.md` | Kontrak Kerja AI | **WAJIB di awal SETIAP prompt** |
| 02 | `02_PRD_PRODUCT_REQUIREMENTS.md` | Requirement Game & Formula | Saat eksekusi fitur gameplay & balancing |
| 03 | `03_ROADMAP_EXECUTION_CHECKLIST.md` | Checklist Task (Phase 0-3) | Untuk track progres & pilih task selanjutnya |
| 04 | `04_GDD_STAKEHOLDER_SUMMARY.md` | Ringkasan Konsep Game | Untuk konteks high-level stakeholder |
| 05 | `05_ARCH_SYSTEM_AND_DATASTORE.md` | Arsitektur & DataStore | Saat buat folder, schema DataStore, RemoteEvent |
| 06 | `06_CODE_LUAU_STANDARDS.md` | Standar Kode Luau | Saat agent menulis file `.luau` / `.lua` |
| 07 | `07_DATA_ITEM_CATALOG.md` | Katalog Sepatu, Outfit, Pet | Saat registrasi item ke `Constants` / Shop |
| 08 | `08_TEST_AUTOMATION_STRATEGY.md` | TestEZ Automation | Saat buat `.spec.lua` unit test modul |
| 09 | `09_MAP_DESIGN_PROMPTS.md` | Prompt Blockout Map & Landmark | Saat buat/blockout map GBK & Sub-Places |
| 10 | `10_ASSET_PERFORMANCE_GUIDELINES.md` | Budget Performance Asset | Saat impor/bikin 3D model & lighting |
| 11 | `11_ART_STYLE_BIBLE.md` | Panduan Visual & Budaya | Saat desain warna, landmark, & kostum adat |
| 12 | `12_UI_UX_STATE_AND_TOKENS.md` | State Machine UI & Design Tokens | Saat buat ScreenGui & script Client UI |
| 13 | `13_OPS_CI_CD_PIPELINE.md` | Pipeline GitHub Actions & Open Cloud | Saat setup CI/CD & automated publish |
| 14 | `14_OPS_LIVEOPS_AND_LAUNCH.md` | Telemetry & Soft-Launch | Saat pasang event Analytics & soft launch |
| 15 | `15_OPS_COMMUNITY_MARKETING.md` | Community & Social Channel | Pasca-rilis untuk engagement & bug report |

---

## 🚀 Alur Prompting Berurutan (Phase 0 s.d. Phase 3)

### STEP 1: Inisialisasi Proyek & Folder Structure (Fase 0)
- **File wajib di-attach/mention**: `01_RULE_AGENT_OPERATIONAL.md`, `05_ARCH_SYSTEM_AND_DATASTORE.md`, `06_CODE_LUAU_STANDARDS.md`, `03_ROADMAP_EXECUTION_CHECKLIST.md`.
- **Template Prompt**:
  > "Berdasarkan aturan di `01_RULE_AGENT_OPERATIONAL.md` dan arsitektur di `05_ARCH_SYSTEM_AND_DATASTORE.md`, siapkan struktur folder proyek (Rojo), file `shared/Constants.lua`, `shared/Types.lua`, dan `shared/RemoteContracts.lua`. Ikuti standar `06_CODE_LUAU_STANDARDS.md` (`--!strict`). Tandai checklist Fase 0 di `03_ROADMAP_EXECUTION_CHECKLIST.md` jika selesai."

---

### STEP 2: DataStore & Economy System (Fase 1.1)
- **File wajib di-attach/mention**: `01_RULE_AGENT_OPERATIONAL.md`, `05_ARCH_SYSTEM_AND_DATASTORE.md`, `06_CODE_LUAU_STANDARDS.md`, `08_TEST_AUTOMATION_STRATEGY.md`.
- **Template Prompt**:
  > "Implementasikan ProfileService DataStore schema dan modul `EconomySystem.lua` di `src/server/Systems/`. Selalu server-authoritative dan satu-satunya pintasan penambahan Cash/Rubies. Buat juga unit test TestEZ di `EconomySystem.spec.lua` sesuai `08_TEST_AUTOMATION_STRATEGY.md`."

---

### STEP 3: Movement & Stamina Mechanics (Fase 1.2)
- **File wajib di-attach/mention**: `01_RULE_AGENT_OPERATIONAL.md`, `02_PRD_PRODUCT_REQUIREMENTS.md` (§11), `05_ARCH_SYSTEM_AND_DATASTORE.md`, `06_CODE_LUAU_STANDARDS.md`, `08_TEST_AUTOMATION_STRATEGY.md`.
- **Template Prompt**:
  > "Buat `MovementController.lua` dan `StaminaSystem.lua` memakai formula WalkSpeed (§11.1 PRD) dengan hard cap 60. Pastikan tidak ada `wait()` usang dan nilai divalidasi server. Buat unit test `.spec.lua` untuk formula WalkSpeed dan Stamina."

---

### STEP 4: Main Hub GBK Senayan Blockout (Fase 1.3)
- **File wajib di-attach/mention**: `01_RULE_AGENT_OPERATIONAL.md`, `09_MAP_DESIGN_PROMPTS.md` (§1), `10_ASSET_PERFORMANCE_GUIDELINES.md`, `11_ART_STYLE_BIBLE.md`.
- **Template Prompt**:
  > "Lakukan blockout map Hub GBK Senayan sesuai prompt di `09_MAP_DESIGN_PROMPTS.md` §1. Gunakan CollectionService Tag `'Treadmill'` pada part latihan dan `'ShopVendor'` pada booth toko. Pastikan budget part < 3.000 sesuai `10_ASSET_PERFORMANCE_GUIDELINES.md`."

---

### STEP 5: Race System 5K Monas (Fase 1.4)
- **File wajib di-attach/mention**: `01_RULE_AGENT_OPERATIONAL.md`, `05_ARCH_SYSTEM_AND_DATASTORE.md`, `09_MAP_DESIGN_PROMPTS.md` (§2), `08_TEST_AUTOMATION_STRATEGY.md`.
- **Template Prompt**:
  > "Implementasikan `RaceSystem.lua` server-side dengan validasi checkpoint via `Heartbeat` + `Magnitude` (bukan `Touched`). Buat map rute 5K Monas dengan Tag `'RaceCheckpoint'`. Buat `RaceSystem.spec.lua` untuk menguji anti-skip checkpoint."

---

### STEP 6: Stravi App & Coach System (Fase 1.5 - 1.6)
- **File wajib di-attach/mention**: `01_RULE_AGENT_OPERATIONAL.md`, `02_PRD_PRODUCT_REQUIREMENTS.md` (§4), `05_ARCH_SYSTEM_AND_DATASTORE.md`, `07_DATA_ITEM_CATALOG.md`.
- **Template Prompt**:
  > "Buat `StraviSystem.lua` (KOM record & Give Kudos dengan daily cap) dan `CoachSystem.lua` (efficiency multiplier & Daily XP Cap). Validasi semua input dari Client via RemoteEvent."

---

### STEP 7: Shop System & Client UI State Machine (Fase 1.7 - 1.8)
- **File wajib di-attach/mention**: `01_RULE_AGENT_OPERATIONAL.md`, `12_UI_UX_STATE_AND_TOKENS.md`, `07_DATA_ITEM_CATALOG.md`, `05_ARCH_SYSTEM_AND_DATASTORE.md`.
- **Template Prompt**:
  > "Buat `UIStateController.lua` di client sebagai state machine (Shop, Coach, Stravi, RaceHUD). Implementasikan `ShopFrame` dan `StatsFrame` memakai token warna & font dari `12_UI_UX_STATE_AND_TOKENS.md`. Hubungkan tombol Beli ke RemoteEvent `BuyGearEvent`."

---

### STEP 8: Onboarding Tutorial (Fase 1.9)
- **File wajib di-attach/mention**: `01_RULE_AGENT_OPERATIONAL.md`, `02_PRD_PRODUCT_REQUIREMENTS.md` (§7), `12_UI_UX_STATE_AND_TOKENS.md`.
- **Template Prompt**:
  > "Buat alur onboarding/tutorial 60-90 detik untuk pemain baru (cara lari, cara ikut race, cara ke gym). Pastikan tidak ada dead-end UI dan integrasikan ke `UIStateController`."

---

### STEP 9: QA & Self-Test Fase 1 (Fase 1.10)
- **File wajib di-attach/mention**: `01_RULE_AGENT_OPERATIONAL.md` (§4), `03_ROADMAP_EXECUTION_CHECKLIST.md`.
- **Template Prompt**:
  > "Jalankan seluruh Self-Test Checklist Fase 1, playtest UI mobile low-end, dan siapkan rangkuman review item parody brand sebelum lanjut ke Fase 2."

---

### STEP 10: Expansion Sub-Places & Pet Hunting (Fase 2.1 - 2.2)
- **File wajib di-attach/mention**: `01_RULE_AGENT_OPERATIONAL.md`, `09_MAP_DESIGN_PROMPTS.md` (§3 - §6), `07_DATA_ITEM_CATALOG.md` (§6), `11_ART_STYLE_BIBLE.md` (§4 - §5).
- **Template Prompt**:
  > "Tambahkan Sub-Place 2 (Borobudur/Prambanan) dan Sub-Place 5 (Bromo/Rinjani). Buat `PetSystem.lua` minigame umpan & lasso dengan odds disclosure UI wajib. Sebelum rilis aset Garuda Emas/Papua, minta review sensitivitas budaya manusia."

---

### STEP 11: Dual Leaderboard System (Fase 2.3)
- **File wajib di-attach/mention**: `01_RULE_AGENT_OPERATIONAL.md`, `05_ARCH_SYSTEM_AND_DATASTORE.md`, `02_PRD_PRODUCT_REQUIREMENTS.md`.
- **Template Prompt**:
  > "Implementasikan `LeaderboardSystem.lua` server-side dengan dua mode: All-Time (OrderedDataStore) dan Weekly Reset (setiap Senin 00:00 WIB). Berikan reward otomatis untuk Rank 1 mingguan."

---

### STEP 12: QA & Review Budaya Fase 2 (Fase 2.4)
- **File wajib di-attach/mention**: `01_RULE_AGENT_OPERATIONAL.md`, `11_ART_STYLE_BIBLE.md`.
- **Template Prompt**:
  > "Jalankan Self-Test Checklist Fase 2 dan minta konfirmasi manusia untuk desain final Garuda Emas serta aset simbolik budaya."

---

### STEP 13: Telemetry & CI/CD Automated Publish (Fase 3 & Ops)
- **File wajib di-attach/mention**: `13_OPS_CI_CD_PIPELINE.md`, `14_OPS_LIVEOPS_AND_LAUNCH.md`, `15_OPS_COMMUNITY_MARKETING.md`.
- **Template Prompt**:
  > "Setup workflow GitHub Actions sesuai `13_OPS_CI_CD_PIPELINE.md` (Selene lint, Rojo build, TestEZ runner). Pasang event telemetry `AnalyticsService` sesuai taxonomy di `14_OPS_LIVEOPS_AND_LAUNCH.md`."

---

## 🛑 Aturan Emas Prompting (Golden Rules)

1. **Selalu sertakan `01_RULE_AGENT_OPERATIONAL.md`**: Memastikan agent tidak menggunakan API usang (`wait()`), tidak membocorkan validasi client-side, dan menjaga server-authoritative logic.
2. **Satu Prompt = Satu Modul/Sistem**: Jangan minta agent membangun "Race + Pet + UI + Shop" sekaligus dalam satu kali prompt.
3. **Minta Unit Test Sebelum Tandai Selesai**: Setiap fungsi logika server (Economy, Pace, Race) wajib lulus TestEZ `.spec.lua` sebelum task centang `[x]` di `03_ROADMAP_EXECUTION_CHECKLIST.md`.
4. **Hentikan Prompt Jika Butuh Human Review**: Untuk item berisiko IP (parody brand) dan representasi simbol adat (Papua/Garuda Emas), agent WAJIB berhenti dan minta approval manusia.
