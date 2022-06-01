local rage_ref, rage_hk_ref = ui.reference("RAGE", "Aimbot", "Enabled")
local hk1_ref = ui.new_hotkey("RAGE", "Other", "Aimbot hotkey 1")
local hk2_ref = ui.new_hotkey("RAGE", "Other", "Aimbot hotkey 2")

local function run_command()
    ui.set(rage_hk_ref, (ui.get(hk1_ref) or ui.get(hk2_ref)) and "Always on" or "On hotkey")
end

client.set_event_callback("run_command", run_command)