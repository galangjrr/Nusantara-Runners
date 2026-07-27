# ARCHITECTURE.md
## Arsitektur Teknis — Nusantara Runner

---

## 1. Toolchain yang Direkomendasikan

- **Rojo** untuk sinkronisasi kode antara filesystem (agar agent AI bisa menulis file `.lua`/`.luau` biasa) dan Roblox Studio.
- **Selene / StyLua** untuk lint & format Luau otomatis (opsional tapi disarankan agar konsisten antar-agent).
- **ProfileService** (by loleris) sebagai DataStore wrapper standar — jangan re-invent session-locking sendiri.
- Struktur repo:

```
src/
├── server/
│   ├── Systems/          -- 1 modul = 1 sistem gameplay
│   ├── Data/              -- ProfileService setup, schema, migration
│   └── init.server.lua
├── client/
│   ├── Controllers/
│   ├── UI/
│   └── init.client.lua
├── shared/
│   ├── Constants.lua      -- SEMUA magic number game di sini
│   ├── Types.lua          -- type export Luau (--!strict)
│   ├── RemoteContracts.lua -- definisi payload tiap RemoteEvent + validator
│   └── Utils/
└── assets/
    ├── maps/
    ├── models/
    └── animations/
```

---

## 2. Peta Modul Sistem (Server)

| Modul | Tanggung Jawab | Bergantung Pada |
|---|---|---|
| `MovementController` | Hitung WalkSpeed final, apply ke Humanoid | Constants, PlayerProfile |
| `StaminaSystem` | Drain/regen stamina, cadence quality | MovementController |
| `RaceSystem` | Checkpoint validation via Heartbeat+Magnitude, waktu, hasil | ProfileService |
| `PetSystem` | Spawn pet by zone, catch probability roll, minigame server-check | RaceSystem (untuk zona trail) |
| `ShopSystem` | Beli gear/consumable, validasi harga di server | ProfileService |
| `CoachSystem` | Efficiency multiplier, daily quest tracking | ProfileService |
| `StraviSystem` | KOM record, kudos, crown buff assignment | RaceSystem, ProfileService |
| `LeaderboardSystem` | All-time + weekly reset, OrderedDataStore | ProfileService |
| `EconomySystem` | Grant/deduct Cash/Rubies terpusat (single source of truth) | ProfileService |
| `MonetizationSystem` | ProcessReceipt, gamepass ownership check | EconomySystem |

**Aturan penting**: perubahan Cash/Rubies/Trophies HARUS selalu lewat `EconomySystem`, bukan modul lain yang menulis langsung ke profile. Ini mencegah bug ekonomi tersebar di banyak file.

---

## 3. CollectionService Tags (bukan manual array/path)

| Tag | Dipasang di | Dipakai oleh |
|---|---|---|
| `"Treadmill"` | Part gym | `CoachSystem` |
| `"RaceCheckpoint"` | Part checkpoint | `RaceSystem` |
| `"PetSpawnZone"` | Part/region zona trail | `PetSystem` |
| `"KOMSegmentStart"` / `"KOMSegmentEnd"` | Part segment Stravi | `StraviSystem` |
| `"ShopVendor"` | NPC/booth toko | `ShopSystem` |

Semua sistem mencari instance lewat `CollectionService:GetTagged(tag)`, bukan `Workspace.Map.Races.Monas.StartLine` hardcoded — path absolut boleh dipakai untuk dokumentasi/blockout awal saja, tapi implementasi final wajib pakai tag.

---

## 4. Attributes (bukan ValueBase)

Contoh state di-attach ke instance:
```
Part "Checkpoint_03" 
  Attribute: RaceId = "5K_Monas"
  Attribute: CheckpointIndex = 3
```
Dibaca via `instance:GetAttribute("CheckpointIndex")`. Menghindari `IntValue`/`StringValue` yang menambah instance count & lebih sulit dilacak.

---

## 5. DataStore Schema (revisi dari draft awal)

```json
{
  "SchemaVersion": 1,
  "UserId": 12345678,
  "Stats": {
    "Pace": 15.5,
    "StaminaMax": 120.0,
    "Cash": 2500,
    "Rubies": 150,
    "Trophies": 12
  },
  "Equipment": {
    "EquippedShoe": "DefaultSneakers",
    "EquippedOutfit": "Default",
    "EquippedPet": null
  },
  "Inventory": {
    "Shoes": ["DefaultSneakers"],
    "Pets": [],
    "Consumables": {}
  },
  "Stravi": {
    "KOMs": [],
    "KudosReceivedTotal": 0,
    "KudosGivenToday": 0,
    "KudosGivenResetAt": 0
  },
  "Coach": {
    "Level": 0,
    "Efficiency": 1.0,
    "DailyQuestDone": false,
    "DailyXPEarned": 0,
    "DailyResetAt": 0
  },
  "Meta": {
    "CreatedAt": 0,
    "LastLoginAt": 0
  }
}
```

Perubahan kunci vs draft awal:
- Tambah `SchemaVersion` — wajib untuk migration aman ke depan.
- Tambah field reset harian (`KudosGivenResetAt`, `DailyResetAt`, `DailyXPEarned`) — draft awal menyebut "Daily Workout Target" tapi tidak punya field untuk melacak cap harian.
- `EquippedPet` default `null`, bukan asumsi pemain baru sudah punya pet legendary.
- `Meta` block untuk analytics dasar (retention KPI di PRD §2 butuh data ini).

---

## 6. Remote Event Contract (revisi)

| Remote | Arah | Payload | Validasi Server Wajib |
|---|---|---|---|
| `TrainEvent` | C→S | `{Action: "Treadmill"\|"Squat", CadenceQuality: number}` | CadenceQuality dalam [0,1]; rate limit 1x/detik; cek player sedang overlap Tag "Treadmill" |
| `BuyGearEvent` | C→S | `{ItemId: string, Category: "Shoe"\|"Consumable"}` | ItemId ada di katalog; harga dicek dari Constants, bukan dari client; cek saldo cukup |
| `StraviKudosEvent` | C→S | `{TargetPlayerId: number, SegmentId: string}` | Target bukan diri sendiri; cek `KudosGivenToday` < cap; segment valid |
| `RaceCheckEvent` | C→S | `{RaceId: string, CheckpointIndex: number}` | Index harus persis lanjutan dari checkpoint terakhir tervalidasi (tidak boleh skip); jarak tempuh sejak checkpoint terakhir masuk akal secara waktu |
| `CatchPetEvent` | C→S | `{PetZoneId: string, BaitType: string, TimingScore: number}` | TimingScore dalam [0,1]; player benar-benar berada di zona (server-side position check, jangan percaya PetZoneId dari client mentah) |
| `RaceResultUpdated` | S→C | `{RaceId, Time, Rank}` | — (server→client, read-only) |
| `EconomyUpdated` | S→C | `{Cash, Rubies, Trophies}` | — (satu-satunya sumber UI update saldo) |

---

## 7. UI Architecture (State Machine, bukan banyak boolean toggle)

Gunakan satu `UIStateController` di client yang menyimpan `CurrentMenu: "None"|"Shop"|"Coach"|"Stravi"|"RaceHUD"` dan setiap Frame subscribe ke perubahan state ini — hindari pola "banyak `Frame.Visible = true/false` tersebar di banyak script" yang disebutkan draft awal tapi tidak dirinci caranya.

```
StarterGui/
├── HUD/ (selalu visible)
│   ├── StatsFrame
│   ├── StraviWidget
│   └── CoachWidget
├── Menus/ (dikontrol UIStateController, mutually exclusive)
│   ├── ShopFrame
│   ├── CoachFrame
│   └── StraviFrame
├── Minigames/
│   └── CadenceBarGui
└── RaceHUD/
    ├── CheckpointTracker
    └── LiveLeaderboard
```

---

## 8. Multi-Place vs Single-Place (keputusan arsitektur)

MVP: **single-place**, tiap "sub-place" adalah folder Map berbeda di `Workspace`, pindah pakai `CFrame` teleport lokal (bukan `TeleportService`) + `StreamingEnabled = true` supaya part di luar radius tidak termuat.

Fase 3: jika part count/kompleksitas asset sudah terlalu besar untuk satu server, migrasi ke multi-place dengan `TeleportService:TeleportToPlaceInstance` + data-passing via `ProfileService`/`MemoryStoreService` untuk state sementara antar tempat. Ini keputusan besar — butuh review manusia sebelum dieksekusi (lihat `01_AGENT_RULES.md` §7).
