# CODING_STANDARDS.md
## Standar Kode Luau — Nusantara Runner

---

## 1. Tipe & Strictness
- Semua ModuleScript baru wajib diawali `--!strict`.
- Semua fungsi publik (di-export lewat `return Module`) wajib punya type annotation parameter & return.
- Definisikan tipe data bersama di `shared/Types.lua`, jangan duplikasi tipe yang sama di banyak file.

```lua
--!strict
type PlayerProfile = {
	Stats: { Pace: number, StaminaMax: number, Cash: number, Rubies: number, Trophies: number },
	Equipment: { EquippedShoe: string, EquippedOutfit: string, EquippedPet: string? },
}
```

## 2. Penamaan
- Module & Service: `PascalCase` (`RaceSystem`, `EconomySystem`).
- Variabel & fungsi lokal: `camelCase`.
- Constants: `SCREAMING_SNAKE_CASE` di dalam `Constants.lua` (`BASE_WALK_SPEED`, `MAX_KUDOS_PER_DAY`).
- RemoteEvent/RemoteFunction: `PascalCase` diakhiri kata jenis (`TrainEvent`, `RaceCheckEvent`).

## 3. Larangan API Usang
- Gunakan `task.wait()`, `task.spawn()`, `task.delay()` — jangan `wait()`, `spawn()`, `delay()`.
- Gunakan `Instance:GetAttribute/SetAttribute` — jangan `IntValue`/`StringValue`/`BoolValue` untuk state gameplay.
- Gunakan `CollectionService` untuk grouping instance — jangan manual array of instance reference yang di-hardcode.

## 4. Magic Number
Semua angka gameplay (base speed, drain rate, cap harian, harga item) WAJIB berada di `shared/Constants.lua`, tidak boleh ditulis literal di tengah logic. Ini agar balancing bisa diubah tanpa menyentuh banyak file, dan agar mudah di-review satu tempat.

```lua
-- shared/Constants.lua
return {
	BASE_WALK_SPEED = 16,
	PACE_STAT_MULTIPLIER = 0.25,
	WALK_SPEED_HARD_CAP = 60,
	BASE_STAMINA_DRAIN = 5.0,
	MAX_KUDOS_PER_DAY = 20,
	DAILY_XP_CAP = 500,
}
```

## 5. Validasi RemoteEvent (pola wajib)

Setiap handler `OnServerEvent` mengikuti pola berikut, tidak boleh langsung memproses payload:

```lua
RaceCheckEvent.OnServerEvent:Connect(function(player: Player, payload: unknown)
	-- 1. Type guard
	if typeof(payload) ~= "table" then return end
	local raceId = payload.RaceId
	local checkpointIndex = payload.CheckpointIndex
	if typeof(raceId) ~= "string" or typeof(checkpointIndex) ~= "number" then
		return
	end

	-- 2. Rate limit / state check
	if not RaceSystem.CanAdvanceCheckpoint(player, raceId, checkpointIndex) then
		return
	end

	-- 3. Business logic
	RaceSystem.AdvanceCheckpoint(player, raceId, checkpointIndex)
end)
```

Jangan pernah mempercayai `payload` sebagai kebenaran — anggap selalu berpotensi dimanipulasi.

## 6. Error Handling
- Panggilan yang bisa gagal (DataStore, MarketplaceService) wajib dibungkus `pcall` dan retry dengan backoff sederhana (maks 3x).
- Jangan biarkan error di satu sistem menjatuhkan seluruh server loop — isolasi dengan `pcall` di titik masuk tiap sistem besar (mis. `Heartbeat` connection utama RaceSystem).

## 7. Single Source of Truth untuk Economy
Semua penambahan/pengurangan Cash/Rubies/Trophies HANYA lewat fungsi `EconomySystem.Grant(player, currency, amount, reason)` / `EconomySystem.Deduct(...)`. Parameter `reason` wajib diisi (string, mis. `"RaceReward_5K_Monas"`) untuk memudahkan audit log jika ada dispute player.

## 8. Review Checklist Sebelum Commit
- [ ] Tidak ada `wait()`/`spawn()`/`delay()` legacy.
- [ ] Tidak ada literal angka gameplay di luar `Constants.lua`.
- [ ] Semua RemoteEvent baru punya validasi tipe + business rule di server.
- [ ] Tidak ada perubahan Cash/Rubies di luar `EconomySystem`.
- [ ] Modul baru punya `--!strict` dan type annotation di fungsi publik.
