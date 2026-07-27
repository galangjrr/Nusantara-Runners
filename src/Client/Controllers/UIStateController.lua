--!strict
local UIStateController = {}

export type MenuState = "None" | "Shop" | "Coach" | "Stravi" | "RaceHUD" | "Onboarding"
UIStateController.CurrentState = "None" :: MenuState

UIStateController.Callbacks = {}

function UIStateController.Subscribe(callback: (MenuState) -> ())
	table.insert(UIStateController.Callbacks, callback)
end

function UIStateController.SetState(newState: MenuState)
	if UIStateController.CurrentState == newState then
		return
	end
	
	UIStateController.CurrentState = newState
	print("[UIState] State changed to:", newState)
	
	for _, cb in ipairs(UIStateController.Callbacks) do
		task.spawn(cb, newState)
	end
end

function UIStateController.ToggleState(state: MenuState)
	if UIStateController.CurrentState == state then
		UIStateController.SetState("None")
	else
		UIStateController.SetState(state)
	end
end

return UIStateController
