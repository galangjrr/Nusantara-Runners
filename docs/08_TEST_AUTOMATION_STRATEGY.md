# TESTING_STRATEGY.md
## Automated Testing — Nusantara Runner

---

## 1. Prinsip
Self-Test Checklist manual di `01_AGENT_RULES.md` §4 cukup untuk validasi cepat per task, tapi tidak mencegah **regresi** — perubahan di satu modul yang diam-diam merusak modul lain yang sudah "selesai" sebelumnya. Automated test menutup celah ini, terutama untuk modul yang menyentuh ekonomi & fairness gameplay, karena bug di area ini langsung merusak kepercayaan pemain.

## 2. Tooling
- **TestEZ** (framework testing Lua paling umum di ekosistem Roblox) untuk unit test & integration test modul.
- Dijalankan headless lewat `run-in-roblox` CLI di CI (lihat `07_CI_CD_PIPELINE.md` §4), bukan manual klik "Run" di Studio.

## 3. Prioritas Modul yang WAJIB Punya Test (bukan opsional)

| Modul | Alasan Prioritas Tinggi |
|---|---|
| `EconomySystem` | Kesalahan di sini = duplikasi/kehilangan currency pemain, dampak langsung ke kepercayaan & risiko exploit finansial |
| `RaceSystem` (validasi checkpoint) | Kesalahan = race bisa di-skip/dicurangi, merusak fairness leaderboard |
| Formula `MovementController` (WalkSpeed) | Kesalahan cap = speedhack tak terdeteksi |
| `StaminaSystem` | Kesalahan = stamina infinite/negatif |
| `CoachSystem` (Daily XP Cap) | Kesalahan = bypass cap harian, merusak balancing progres |
| `StraviSystem` (Crown assignment, Kudos cap) | Kesalahan = buff permanen tak semestinya, farming kudos |
| `ProfileService` migration/schema | Kesalahan = data loss pemain saat update |

Modul UI murni (Frame visibility, animasi kosmetik) **tidak wajib** unit test detail — cukup manual QA, karena risiko kegagalannya rendah dan biaya testing otomatisnya tidak sepadan.

## 4. Contoh Struktur Test (TestEZ)

```lua
-- server/Systems/EconomySystem.spec.lua
return function()
	local EconomySystem = require(script.Parent.EconomySystem)

	describe("EconomySystem.Grant", function()
		it("should increase currency by exact amount", function()
			local mockProfile = { Stats = { Cash = 100 } }
			EconomySystem.Grant(mockProfile, "Cash", 50, "TestReward")
			expect(mockProfile.Stats.Cash).to.equal(150)
		end)

		it("should reject negative grant amount", function()
			local mockProfile = { Stats = { Cash = 100 } }
			local ok = EconomySystem.Grant(mockProfile, "Cash", -50, "TestReward")
			expect(ok).to.equal(false)
			expect(mockProfile.Stats.Cash).to.equal(100) -- tidak berubah
		end)

		it("should always require a reason string", function()
			local mockProfile = { Stats = { Cash = 100 } }
			expect(function()
				EconomySystem.Grant(mockProfile, "Cash", 50, nil)
			end).to.throw()
		end)
	end)
end
```

```lua
-- server/Systems/RaceSystem.spec.lua
return function()
	local RaceSystem = require(script.Parent.RaceSystem)

	describe("RaceSystem.CanAdvanceCheckpoint", function()
		it("should allow sequential checkpoint", function()
			local state = { LastCheckpoint = 2 }
			expect(RaceSystem.CanAdvanceCheckpoint(state, 3)).to.equal(true)
		end)

		it("should reject skipped checkpoint", function()
			local state = { LastCheckpoint = 2 }
			expect(RaceSystem.CanAdvanceCheckpoint(state, 5)).to.equal(false)
		end)

		it("should reject checkpoint going backward", function()
			local state = { LastCheckpoint = 4 }
			expect(RaceSystem.CanAdvanceCheckpoint(state, 2)).to.equal(false)
		end)
	end)
end
```

## 5. Jenis Test yang Dibutuhkan per Modul Kritikal

1. **Unit test murni** — fungsi kalkulasi tanpa dependency Roblox API (formula WalkSpeed, StaminaDrain, StatGain) — paling mudah & murah untuk dites, harus 100% coverage untuk cabang formula (termasuk edge case: nilai 0, nilai maksimum, nilai negatif yang seharusnya ditolak).
2. **Integration test dengan mock profile** — modul yang butuh `PlayerProfile` (Economy, Coach, Stravi) diuji dengan mock data, bukan pemain asli, supaya bisa jalan headless di CI tanpa perlu server Roblox penuh.
3. **Simulasi multi-pemain (khusus RaceSystem & StraviSystem)** — test skenario 2+ "pemain virtual" merebut KOM/checkpoint bersamaan, untuk pastikan tidak ada race condition (lihat `01_AGENT_RULES.md` §4 poin race condition).

## 6. Kapan Test Dijalankan
- **Setiap push/PR** (lewat CI, lihat `07_CI_CD_PIPELINE.md`) — wajib lulus sebelum merge ke `main`/`staging` diizinkan.
- **Sebelum tiap publish ke Production** — test suite penuh dijalankan ulang sebagai gate terakhir, bukan hanya mengandalkan hasil test dari push sebelumnya (kode bisa berubah lagi di antara waktu itu).

## 7. Definition of Done untuk Modul Kritikal (§3)
Sebuah modul di daftar §3 baru boleh dianggap "selesai" (menandai checklist di `05_ROADMAP_TASKS.md`) jika:
- [ ] Ada file `.spec.lua` dengan minimal 3 skenario: kasus normal, kasus batas (edge case), kasus input tidak valid.
- [ ] Semua test lulus di CI, bukan cuma lokal.
- [ ] Coverage mencakup semua percabangan formula (if/else) di modul tersebut.
- [ ] Lolos Self-Test Checklist manual di `01_AGENT_RULES.md` §4 (automated test melengkapi, bukan menggantikan checklist manual).
