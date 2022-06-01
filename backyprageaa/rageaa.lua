-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_current_threat, client_exec, client_latency, client_log, client_random_int, client_screen_size, client_set_clan_tag, client_set_event_callback, client_system_time, client_userid_to_entindex, entity_get_all, entity_get_classname, entity_get_local_player, entity_get_player_name, entity_get_player_weapon, entity_get_prop, entity_is_alive, entity_is_dormant, entity_set_prop, globals_absoluteframetime, globals_curtime, globals_realtime, globals_tickcount, globals_tickinterval, math_abs, math_floor, math_max, math_min, math_random, math_randomseed, math_sin, math_sqrt, panorama_open, renderer_gradient, renderer_measure_text, renderer_rectangle, renderer_text, require, string_format, string_gsub, string_upper, table_insert, table_remove, ui_get, ui_new_button, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_hotkey, ui_new_label, ui_new_multiselect, ui_reference, ui_set, ui_set_callback, ui_set_visible = client.current_threat, client.exec, client.latency, client.log, client.random_int, client.screen_size, client.set_clan_tag, client.set_event_callback, client.system_time, client.userid_to_entindex, entity.get_all, entity.get_classname, entity.get_local_player, entity.get_player_name, entity.get_player_weapon, entity.get_prop, entity.is_alive, entity.is_dormant, entity.set_prop, globals.absoluteframetime, globals.curtime, globals.realtime, globals.tickcount, globals.tickinterval, math.abs, math.floor, math.max, math.min, math.random, math.randomseed, math.sin, math.sqrt, panorama.open, renderer.gradient, renderer.measure_text, renderer.rectangle, renderer.text, require, string.format, string.gsub, string.upper, table.insert, table.remove, ui.get, ui.new_button, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_hotkey, ui.new_label, ui.new_multiselect, ui.reference, ui.set, ui.set_callback, ui.set_visible


local images = require("gamesense/images") or client_log("This LUA requires gamesense/images to operate which can be found at: https://gamesense.pub/forums/viewtopic.php?id=22917")
local colorful = require('colorful_text')
local js = panorama_open()
local bit = require 'bit'
local build = _G.obex_build == nil and 'Source' or _G.obex_build
local username = _G.obex_name == nil and 'Admin' or _G.obex_name
client_exec("clear")
print("Galaxy.Systems loaded!")
print("welcome back ".. username .. ".")
print("For any problems contact me on discord lumiel#0001")

local ref = {
    aa = {
        pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
        yaw = {ui_reference("AA", "Anti-aimbot angles", "Yaw")},
        yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw Base"),
        jitter = { ui_reference("AA", "Anti-aimbot angles", "Yaw jitter") },
        body_yaw = { ui_reference("AA", "Anti-aimbot angles", "Body yaw") },
        fs_body_yaw = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        fake_limit = ui_reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
        edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    },
    slow = { ui_reference("AA", "other", "Slow motion") },
    slide = ui_reference("AA", "Other", "Leg movement"),
    dt_hc = ui_reference("RAGE", "Other", "Double tap hit chance"),
    mupc = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
    hs = { ui_reference("AA", "Other", "On shot anti-aim") },
    baim = ui_reference("Rage", "Other", "Force body aim"),
    sp = ui_reference("Rage", "Aimbot", "Force safe point"),
    fs = { ui_reference("AA", "Anti-aimbot angles", "Freestanding") },
    dt = { ui_reference("Rage", "Other", "Double tap") },
    fd = ui_reference("Rage", "Other", "Duck peek assist"),
    gstag = ui_reference("Misc", "Miscellaneous", "Clan tag spammer"),
    roll = ui_reference('AA', 'Anti-aimbot angles', 'Roll'),
}

local main = {
    l_start = ui_new_label("LUA", "B", "----------------- [" .. colorful:text(true, { { 168, 210, 255 }, { 189, 162, 251 }, "Galaxy" } ) .. "] -----------------"),
    l_space = ui_new_label("LUA", "B", " "),

    enable = ui.new_checkbox ("LUA", "B", "[" .. colorful:text(true, { { 168, 210, 255 }, { 189, 162, 251 }, "Galaxy" } ) .. "] Enable"),
    aa = ui_new_checkbox("LUA", "B", "[" .. colorful:text(true, { { 168, 210, 255 }, { 189, 162, 251 }, "Galaxy" } ) .. "] AA"),
    aa_c = ui_new_combobox("LUA", "B", "Modes", "Mode 1", "Mode 2", "Mode 3"),

    aa_roll_e = ui_new_checkbox("LUA", "B", "[" .. colorful:text(true, { { 168, 210, 255 }, { 189, 162, 251 }, "Galaxy" } ) .. "] Roll"),
    aa_roll_h = ui_new_hotkey("LUA", "B", "Roll", true),
    aa_roll = ui.new_slider("LUA", "B", "Amount", -50, 50, 0),

    manual_aa = ui_new_checkbox("LUA", "B", "[" .. colorful:text(true, { { 168, 210, 255 }, { 189, 162, 251 }, "Galaxy" } ) .. "] AA Manual"),

    back = ui_new_hotkey("LUA", "B", "Back"),
    left = ui_new_hotkey("LUA", "B", "Left", false, 0x06),
    right = ui_new_hotkey("LUA", "B", "Right", false, 0x05),

    fs_disabler = ui_new_checkbox("LUA", "B", "[" .. colorful:text(true, { { 168, 210, 255 }, { 189, 162, 251 }, "Galaxy" } ) .. "] FS disablers"),
    fs_disabler_m = ui_new_multiselect("LUA", "B", "States", "Standing", "Ducking", "Slowwalking", "Running", "Usage", "Jumping"),

    leg_breaker = ui_new_checkbox("LUA", "B", "[" .. colorful:text(true, { { 168, 210, 255 }, { 189, 162, 251 }, "Galaxy" } ) .. "] Leg Breakers"),
    leg_breaker_m = ui_new_combobox("LUA", "B", "Versions", "Jitter", "Slide", "Break"),

    anim_breaker = ui_new_checkbox("LUA", "B", "[" .. colorful:text(true, { { 168, 210, 255 }, { 189, 162, 251 }, "Galaxy" } ) .. "] Animation Breaker"),

    legit_aa = ui_new_checkbox("LUA", "B", "[" .. colorful:text(true, { { 168, 210, 255 }, { 189, 162, 251 }, "Galaxy" } ) .. "] Legit AA"),
    legit_aa_h = ui_new_hotkey("LUA", "B", "Legit AA", true, 0x45),

    watermark = ui_new_checkbox("LUA", "B", "[" .. colorful:text(true, { { 168, 210, 255 }, { 189, 162, 251 }, "Galaxy" } ) .. "] Watermark"),
    watermark_c = ui_new_color_picker("LUA", "B", "Watermark", 35, 35, 35, 200),

    aa_ind = ui_new_checkbox("LUA", "B", "[" .. colorful:text(true, { { 168, 210, 255 }, { 189, 162, 251 }, "Galaxy" } ) .. "] Indicators Mode"),
    aa_ind_m = ui_new_combobox("LUA", "B", "Styles", "v1"),

    label = ui_new_label("Lua", "B", "Bar Color"),
	color = ui_new_color_picker("Lua", "B", 'Color Bar', 110, 181, 255, 255),
    label1 = ui_new_label("Lua", "B", "Text Color"),
    color1 = ui_new_color_picker("Lua", "B", 'Text color Bar', 110, 181, 255, 255),

    ind_v = ui_new_label("LUA", "B", "Version"),
    ind_v_c = ui_new_color_picker("LUA", "B", "Color", 192, 211, 255, 255),

    ind_l_h = ui_new_label("LUA", "B", "Hotkeys"),
    ind_h_c = ui_new_color_picker("LUA", "B", "Hotkeys", 255, 255, 255, 255),

    ind_l_s = ui_new_label("LUA", "B", "AA State"),
    ind_s_c = ui_new_color_picker("LUA", "B", "AA State", 255, 255, 255, 255),

    threat_l = ui_new_label("LUA", "B", "Threat"),
    threat_c = ui_new_color_picker("LUA", "B", 'Color', 255, 255, 255, 255),

    fake_yaw_l = ui_new_label("LUA", "B", "Fake Yaw State"),
    fake_yaw_c = ui_new_color_picker("LUA", "B", "Fake Yaw State", 255, 255, 255, 255),


    ind_v_2 = ui_new_label("LUA", "B", "Version"),
    ind_v_c_2 = ui_new_color_picker("LUA", "B", "Color", 192, 211, 255, 255),

    ind_l_h_2 = ui_new_label("LUA", "B", "Hotkeys"),
    ind_h_c_2 = ui_new_color_picker("LUA", "B", "Hotkeys", 255, 255, 255, 255),

    ind_l_s_2 = ui_new_label("LUA", "B", "AA State"),
    ind_s_c_2 = ui_new_color_picker("LUA", "B", "AA State", 255, 255, 255, 255),


    l_space1 = ui_new_label("LUA", "B", " "),
    l_end = ui_new_label("LUA", "B", "----------------- [" .. colorful:text(true, { { 168, 210, 255 }, { 189, 162, 251 }, "Galaxy" } ) .. "] -----------------"),
}

local x, y = client_screen_size()
local c_x, c_y = x/2, y/2

local function includes(table, key)
    local state = false
    for i=1, #table do
        if table[i] == key then
            state = true
            break
        end
    end 
    return state
end

local function round(b,c)
	local d=10^(c or 0)
	return math_floor(b*d+0.5)/d 
end

local leftReady = false
local rightReady = false
local mode = "back"

local function manual_aa()
    if not ui_get(main.enable) or not ui_get(main.manual_aa) then return end

    local threat = client_current_threat()

    if ui_get(main.back) then
        mode = "back"
    elseif ui_get(main.left) and leftReady then
        if mode == "left" then
            mode = "back"
        else
            mode = "left"
        end
        leftReady = false
    elseif ui_get(main.right) and rightReady then
        if mode == "right" then
            mode = "back"
        else
            mode = "right"
        end
        rightReady = false
    end

    if ui_get(main.left) == false then
        leftReady = true
    end

    if ui_get(main.right) == false then
        rightReady = true
    end

    if mode == "back" then
        -- ui_set(ref.aa.yaw[2], 0)
    elseif mode == "left" then
        if entity_is_dormant(threat) or threat == nil then
            ui_set(ref.aa.yaw[2], 0)
        else
            ui_set(ref.aa.yaw[2], -90)
            if ui_get(main.aa_roll_h) then
                ui_set(ref.aa.pitch, "Default")
                ui_set(ref.aa.yaw[1], "180")
                ui_set(ref.aa.jitter[1], "Off")
                ui_set(ref.aa.jitter[2], 0)
                ui_set(ref.aa.body_yaw[1], "Static")
                ui_set(ref.aa.body_yaw[2], -141)
                ui_set(ref.aa.fake_limit, 60)
                ui_set(main.aa_roll, 50)
            end
        end
    elseif mode == "right" then
        if entity_is_dormant(threat) or threat == nil then
            ui_set(ref.aa.yaw[2], 0)
        else
            ui_set(ref.aa.yaw[2], 90)
            if ui_get(main.aa_roll_h) then
                ui_set(ref.aa.pitch, "Default")
                ui_set(ref.aa.yaw[1], "180")
                ui_set(ref.aa.jitter[1], "Off")
                ui_set(ref.aa.jitter[2], 0)
                ui_set(ref.aa.body_yaw[1], "Static")
                ui_set(ref.aa.body_yaw[2], 141)
                ui_set(ref.aa.fake_limit, 60)
                ui_set(main.aa_roll, -50)
            end
        end
    end
end

local function roll_aa(cmd)
    if not ui_get(main.enable) or not ui_get(main.aa_roll_e) then return end

    local active = ui.get(main.aa_roll_h)
    local amount = ui.get(main.aa_roll)

    if active then
        ui.set(ref.roll, 0)
        cmd.roll = amount
    else
        ui.set(ref.roll, amount)
    end
end

local function aa()
    local s_r = math_random(30,59 )
    local fy_l_r = math_random(59, 60)
    local y_r = math_random(-5, 10)

    local local_player = entity_get_local_player()
    local local_alive = entity_is_alive(local_player)
    if not entity_is_alive(entity_get_local_player()) then return end

    local function in_air(player)
        local flags = entity_get_prop(player, "m_fFlags")
        
        if bit.band(flags, 1) == 0 then
            return true
        end
        
        return false
    end
    
    local function is_crouching(player)
        local flags = entity_get_prop(player, "m_fFlags")
        
        if bit.band(flags, 4) == 4 then
            return true
        end
        
        return false
    end
    
    function VectorLength(x, y, z) 
        return math_sqrt(x * x + y * y + z * z);
    end
    
    function get_velocity(ent) 
        local vecvelocity = { entity_get_prop(ent, "m_vecVelocity") }
        return VectorLength(vecvelocity[1],vecvelocity[2],vecvelocity[3])
    end
    
    local me = entity_get_local_player()
    
    local vel = get_velocity(me)

    states = {
        ducking = is_crouching(me),
        standing = (vel < 1.1),
        slowwalking = ui_get(ref.slow[2]),
        running = (vel >= 80),
        usage = ui_get(main.legit_aa_h),
        jumping = in_air(me)
    }

    if not ui_get(main.enable) or not ui_get(main.aa) then return end

    if ui_get(main.aa_c) == "Mode 1" then
        if states.standing then
            if ui_get(main.aa_roll_h) then
                ui_set(ref.aa.pitch, "Default")
                ui_set(ref.aa.yaw[1], "180")
                ui_set(ref.aa.yaw[2], 0)
                ui_set(ref.aa.jitter[1], "Off")
                ui_set(ref.aa.jitter[2], 0)
                ui_set(ref.aa.body_yaw[1], "Static")
                ui_set(ref.aa.body_yaw[2], 141)
                ui_set(ref.aa.fake_limit, 60)
                if includes(ui_get(main.fs_disabler_m), "Standing") then
                    ui_set(ref.fs[1], "-")
                else
                    ui_set(ref.fs[1], "Default")
                end
            else
                ui_set(ref.aa.pitch, "Down")
                ui_set(ref.aa.yaw[1], "180")
                ui_set(ref.aa.yaw[2], 0)
                ui_set(ref.aa.jitter[1], "Center")
                ui_set(ref.aa.jitter[2], 25)
                ui_set(ref.aa.body_yaw[1], "Jitter")
                ui_set(ref.aa.body_yaw[2], 0)
                ui_set(ref.aa.fake_limit, fy_l_r)
                if includes(ui_get(main.fs_disabler_m), "Standing") then
                    ui_set(ref.fs[1], "-")
                else
                    ui_set(ref.fs[1], "Default")
                end
            end
        end
        if states.running then
            ui_set(ref.aa.pitch, "Down")
            ui_set(ref.aa.yaw[1], "180")
            ui_set(ref.aa.yaw[2], 0)
            ui_set(ref.aa.jitter[1], "Center")
            ui_set(ref.aa.jitter[2], 79)
            ui_set(ref.aa.body_yaw[1], "Jitter")
            ui_set(ref.aa.body_yaw[2], 0)
            ui_set(ref.aa.fake_limit, fy_l_r)
            if includes(ui_get(main.fs_disabler_m), "Running") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
        if states.slowwalking then
            ui_set(ref.aa.pitch, "Down")
            ui_set(ref.aa.yaw[1], "180")
            ui_set(ref.aa.yaw[2], 0)
            ui_set(ref.aa.jitter[1], "Center")
            ui_set(ref.aa.jitter[2], 0)
            ui_set(ref.aa.body_yaw[1], "Jitter")
            ui_set(ref.aa.body_yaw[2], -79)
            ui_set(ref.aa.fake_limit, s_r)
            if includes(ui_get(main.fs_disabler_m), "Slowwalking") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
        if states.jumping then
            ui_set(ref.aa.pitch, "Down")
            ui_set(ref.aa.yaw[1], "180")
            ui_set(ref.aa.yaw[2], 5)
            ui_set(ref.aa.jitter[1], "Center")
            ui_set(ref.aa.jitter[2], 48)
            ui_set(ref.aa.body_yaw[1], "Jitter")
            ui_set(ref.aa.body_yaw[2], 0)
            ui_set(ref.aa.fake_limit, fy_l_r)
            if includes(ui_get(main.fs_disabler_m), "Jumping") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
        if states.ducking then
            ui_set(ref.aa.pitch, "Down")
            ui_set(ref.aa.yaw[1], "180")
            ui_set(ref.aa.yaw[2], y_r)
            ui_set(ref.aa.jitter[1], "Center")
            ui_set(ref.aa.jitter[2], 35)
            ui_set(ref.aa.body_yaw[1], "Jitter")
            ui_set(ref.aa.body_yaw[2], 0)
            ui_set(ref.aa.fake_limit, fy_l_r)
            if includes(ui_get(main.fs_disabler_m), "Ducking") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
        if states.usage then
            ui_set(ref.aa.pitch, "Off")
            ui_set(ref.aa.yaw[1], "Off")
            ui_set(ref.aa.yaw[2], 0)
            ui_set(ref.aa.body_yaw[1], "Static")
            ui_set(ref.aa.body_yaw[2], "180")
            ui_set(ref.aa.fake_limit, 60)
            if includes(ui_get(main.fs_disabler_m), "Usage") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
    end
        
    if ui_get(main.aa_c) == "Mode 2" then
        if states.standing then
            if ui_get(main.aa_roll_h) then
                ui_set(ref.aa.pitch, "Default")
                ui_set(ref.aa.yaw[1], "180")
                ui_set(ref.aa.yaw[2], 0)
                ui_set(ref.aa.jitter[1], "Off")
                ui_set(ref.aa.jitter[2], 0)
                ui_set(ref.aa.body_yaw[1], "Static")
                ui_set(ref.aa.body_yaw[2], 141)
                ui_set(ref.aa.fake_limit, 60)
                if includes(ui_get(main.fs_disabler_m), "Standing") then
                    ui_set(ref.fs[1], "-")
                else
                    ui_set(ref.fs[1], "Default")
                end
            else
                ui_set(ref.aa.pitch, "Default")
                ui_set(ref.aa.yaw[1], "180")
                ui_set(ref.aa.yaw[2], 0)
                ui_set(ref.aa.jitter[1], "Center")
                ui_set(ref.aa.jitter[2], 25)
                ui_set(ref.aa.body_yaw[1], "Jitter")
                ui_set(ref.aa.body_yaw[2], 0)
                ui_set(ref.aa.fake_limit, 60)
                if includes(ui_get(main.fs_disabler_m), "Standing") then
                    ui_set(ref.fs[1], "-")
                else
                    ui_set(ref.fs[1], "Default")
                end
            end
        end
        if states.running then
            ui_set(ref.aa.pitch, "Default")
            ui_set(ref.aa.yaw[1], "180")
            ui_set(ref.aa.yaw[2], 0)
            ui_set(ref.aa.jitter[1], "Center")
            ui_set(ref.aa.jitter[2], 79)
            ui_set(ref.aa.body_yaw[1], "Jitter")
            ui_set(ref.aa.body_yaw[2], 0)
            ui_set(ref.aa.fake_limit, 60)
            if includes(ui_get(main.fs_disabler_m), "Running") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
        if states.slowwalking then
            ui_set(ref.aa.pitch, "Default")
            ui_set(ref.aa.yaw[1], "180")
            ui_set(ref.aa.yaw[2], 5)
            ui_set(ref.aa.jitter[1], "Center")
            ui_set(ref.aa.jitter[2], 0)
            ui_set(ref.aa.body_yaw[1], "Jitter")
            ui_set(ref.aa.body_yaw[2], -79)
            ui_set(ref.aa.fake_limit, math_random(30,45))
            if includes(ui_get(main.fs_disabler_m), "Slowwalking") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
        if states.jumping then
            ui_set(ref.aa.pitch, "Default")
            ui_set(ref.aa.yaw[1], "180")
            ui_set(ref.aa.yaw[2], 0)
            ui_set(ref.aa.jitter[1], "Center")
            ui_set(ref.aa.jitter[2], 25)
            ui_set(ref.aa.body_yaw[1], "Jitter")
            ui_set(ref.aa.body_yaw[2], 0)
            ui_set(ref.aa.fake_limit, 60)
            if includes(ui_get(main.fs_disabler_m), "Jumping") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
        if states.ducking then
            ui_set(ref.aa.pitch, "Default")
            ui_set(ref.aa.yaw[1], "180")
            ui_set(ref.aa.yaw[2], math_random(5,-10))
            ui_set(ref.aa.jitter[1], "Center")
            ui_set(ref.aa.jitter[2], 0)
            ui_set(ref.aa.body_yaw[1], "Jitter")
            ui_set(ref.aa.body_yaw[2], -79)
            ui_set(ref.aa.fake_limit, math_random(30,45))
            if includes(ui_get(main.fs_disabler_m), "Ducking") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
        if states.usage then
            ui_set(ref.aa.pitch, "Off")
            ui_set(ref.aa.yaw[1], "Off")
            ui_set(ref.aa.yaw[2], 0)
            ui_set(ref.aa.body_yaw[1], "Static")
            ui_set(ref.aa.body_yaw[2], "180")
            ui_set(ref.aa.fake_limit, 60)
            if includes(ui_get(main.fs_disabler_m), "Usage") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
    end

    if ui_get(main.aa_c) == "Mode 3" then
        if states.standing then
            if ui_get(main.aa_roll_h) then
                ui_set(ref.aa.pitch, "Default")
                ui_set(ref.aa.yaw[1], "180")
                ui_set(ref.aa.yaw[2], 0)
                ui_set(ref.aa.jitter[1], "Off")
                ui_set(ref.aa.jitter[2], 0)
                ui_set(ref.aa.body_yaw[1], "Static")
                ui_set(ref.aa.body_yaw[2], 141)
                ui_set(ref.aa.fake_limit, 60)
                if includes(ui_get(main.fs_disabler_m), "Standing") then
                    ui_set(ref.fs[1], "-")
                else
                    ui_set(ref.fs[1], "Default")
                end
            else
                ui_set(ref.aa.pitch, "Default")
                ui_set(ref.aa.yaw[1], "180")
                ui_set(ref.aa.yaw[2], 0)
                ui_set(ref.aa.jitter[1], "Random")
                ui_set(ref.aa.jitter[2], 7)
                ui_set(ref.aa.body_yaw[1], "Static")
                ui_set(ref.aa.body_yaw[2], -95)
                ui_set(ref.aa.fake_limit, 60)
                if includes(ui_get(main.fs_disabler_m), "Standing") then
                    ui_set(ref.fs[1], "-")
                else
                    ui_set(ref.fs[1], "Default")
                end
            end
        end
        if states.running then
            ui_set(ref.aa.pitch, "Default")
            ui_set(ref.aa.yaw[1], "180")
            ui_set(ref.aa.yaw[2], 0)
            ui_set(ref.aa.jitter[1], "Center")
            ui_set(ref.aa.jitter[2], 60)
            ui_set(ref.aa.body_yaw[1], "Jitter")
            ui_set(ref.aa.body_yaw[2], 0)
            ui_set(ref.aa.fake_limit, 60)
            if includes(ui_get(main.fs_disabler_m), "Running") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
        if states.slowwalking then
            ui_set(ref.aa.pitch, "Default")
            ui_set(ref.aa.yaw[1], "180")
            ui_set(ref.aa.yaw[2], "0")
            ui_set(ref.aa.jitter[1], "Offset")
            ui_set(ref.aa.jitter[2], math_random(0,60))
            ui_set(ref.aa.body_yaw[1], "Jitter")
            ui_set(ref.aa.body_yaw[2], "0")
            ui_set(ref.aa.fake_limit, 60)
            if includes(ui_get(main.fs_disabler_m), "Slowwalking") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
        if states.jumping then
            ui_set(ref.aa.pitch, "Default")
            ui_set(ref.aa.yaw[1], "180")
            ui_set(ref.aa.yaw[2], 0)
            ui_set(ref.aa.jitter[1], "Center")
            ui_set(ref.aa.jitter[2], 35)
            ui_set(ref.aa.body_yaw[1], "Jitter")
            ui_set(ref.aa.body_yaw[2], 0)
            ui_set(ref.aa.fake_limit, 60)
            if includes(ui_get(main.fs_disabler_m), "Jumping") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
        if states.ducking then
            ui_set(ref.aa.pitch, "Default")
            ui_set(ref.aa.yaw[1], "180")
            ui_set(ref.aa.yaw[2], 0)
            ui_set(ref.aa.jitter[1], "Random")
            ui_set(ref.aa.jitter[2], 7)
            ui_set(ref.aa.body_yaw[1], "Static")
            ui_set(ref.aa.body_yaw[2], -95)
            ui_set(ref.aa.fake_limit, 60)
            if includes(ui_get(main.fs_disabler_m), "Ducking") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
        if states.usage then
            ui_set(ref.aa.pitch, "Off")
            ui_set(ref.aa.yaw[1], "Off")
            ui_set(ref.aa.yaw[2], 0)
            ui_set(ref.aa.body_yaw[1], "Static")
            ui_set(ref.aa.body_yaw[2], "180")
            ui_set(ref.aa.fake_limit, 60)
            if includes(ui_get(main.fs_disabler_m), "Usage") then
                ui_set(ref.fs[1], "-")
            else
                ui_set(ref.fs[1], "Default")
            end
        end
    end
end

local function legbreaker_net_update_end()
    if not ui_get(main.enable) or not ui_get(main.leg_breaker) then return end
    if ui_get(main.leg_breaker_m) == "Jitter" then
        entity_set_prop(entity_get_local_player(), "m_flPoseParameter", 1, 0)
    end
end

local function legbreaker1()
    if not ui_get(main.enable) or not ui_get(main.leg_breaker) then return end
    if ui_get(main.leg_breaker_m) == "Jitter" then
        p = client_random_int(1, 3)
        if p == 1 then
            ui_set(ref.slide, "Off")
        elseif p == 2 then
            ui_set(ref.slide, "Always slide")
        elseif p == 3 then
            ui_set(ref.slide, "Off")
        end
    end
end

local function legbreaker2()
    if not ui_get(main.enable) or not ui_get(main.leg_breaker) then return end
    if ui_get(main.leg_breaker_m) == "Slide" then
        local state = true

        state = not state
        if state then
            ui_set(ref.slide, "never slide")
        else
            ui_set(ref.slide, "always slide")
        end
    end
end

local function legbreaker3()
    if not ui_get(main.enable) or not ui_get(main.leg_breaker) then return end
    if ui_get(main.leg_breaker_m) == "Break" then
        local legs_int = math_random(0, 10)
        if legs_int <= 4 then
            ui_set(ref.slide, "always slide")
        end
        if legs_int == 0 then
            ui_set(ref.slide, "never slide")
        end
        if legs_int >= 5 then
            ui_set(ref.slide, "never slide")
        end
    end
end

local function animation_breaker()
    if not ui_get(main.enable) or not ui_get(main.anim_breaker) then return end
    entity_set_prop(entity_get_local_player(), "m_flPoseParameter", 1, 0)
    entity_set_prop(entity_get_local_player(), "m_flPoseParameter", 1, 6)    
end


local function legit_aa(e)
    local weapon = entity_get_player_weapon()
    if not ui_get(main.enable) or not ui_get(main.legit_aa) then return end
    if weaponn ~= nil and entity_get_classname(weapon) == "CC4" then
        if e.in_attack == 1 then
            e.in_attack = 0 
            e.in_use = 1
        end
    else
        if e.chokedcommands == 0 then
            e.in_use = 0
        end
    end
end

local frametimes = {}
local fps_prev = 0
local value_prev = {}
local last_update_time = 0

local function accumulate_fps()
	local rt, ft = globals_realtime(), globals_absoluteframetime()

	if ft > 0 then
		table_insert(frametimes, 1, ft)
	end

	local count = #frametimes
	if count == 0 then
		return 0
	end

	local accum = 0
	local i = 0
	while accum < 0.5 do
		i = i + 1
		accum = accum + frametimes[i]
		if i >= count then
			break
		end
	end

	accum = accum / i

	while i < count do
		i = i + 1
		table_remove(frametimes)
	end

	local fps = 1 / accum
	local time_since_update = rt - last_update_time
	if math_abs(fps - fps_prev) > 4 or time_since_update > 1 then
		fps_prev = fps
		last_update_time = rt
	else
		fps = fps_prev
	end

	return math_floor(fps + 0.5)
end


local function watermark()
    local p_res = entity_get_all("CCSPlayerResource")[1]
	local me = entity_get_local_player()

    local local_player = entity_get_local_player()
    local local_alive = entity_is_alive(local_player)
    if not entity_is_alive(entity_get_local_player()) then return end

    local steamid64 = js.MyPersonaAPI.GetXuid()
    local avatar = images.get_steam_avatar(steamid64)
	
	local screen_width, screen_height = client_screen_size()
	local latency = math_floor(client_latency()*1000+0.5)
	local tickrate = 1/globals_tickinterval()
	local hours, minutes, seconds = client_system_time()
    local fps = accumulate_fps()
    local api = js.MyPersonaAPI
    local name = api.GetName()

    local kdr
    local resources = { get_kills = entity_get_prop(p_res, "m_iKills", me), get_deaths = entity_get_prop(p_res, "m_iDeaths", me) }

    if resources.get_deaths ~= 0 then
		local temp = resources.get_kills / resources.get_deaths
		kdr = round(temp, 2)
	elseif resources.get_kills ~= 0 then
		kdr = resources.get_kills
	else kdr = 0 end

    local r, g, b, a = ui_get(main.watermark_c)

	local text = "      Galaxy.Systems | " .. build .. " | " .. username .. " | " .. kdr .. " KD" .. " | " .. string_format("%d fps", fps)

	local margin, padding, flags = 30, 1, nil

	local text_width, text_height = renderer_measure_text(flags, text)

    --image:measure(width, height)
    local avatar_x, avatar_y = avatar:measure()

    if not ui_get(main.enable) or not ui_get(main.watermark) then return end
    renderer_rectangle(screen_width-text_width-margin-padding, margin-padding, text_width+padding*1, text_height+padding*2, r, g, b, a)
    renderer_text(screen_width-text_width-margin, margin, 235, 235, 235, 255, flags, 0, text)
    avatar:draw(screen_width-text_width-margin, margin, 12, 12, 255, 255, 255, 255)
end

local function threat()
    local local_player = entity_get_local_player()
    local local_alive = entity_is_alive(local_player)
    if not entity_is_alive(entity_get_local_player()) then return end
    local me = entity_get_local_player()
    local threat = client_current_threat()
    -- if threat == nil then return end
    local threat_name = entity_get_player_name(threat)
    local r, g, b, a = ui_get(main.threat_c)
    -- if entity_is_dormant(threat) then return end

    if not ui_get(main.enable) or not ui_get(main.aa_ind) then return end
    if ui_get(main.aa_ind_m) == "v1" then 
        if threat == nil then
            renderer_text(c_x + 8, c_y + 45, r, g, b, a, 'cd-', 0, "T: NIL")
        else
            renderer_text(c_x + 2, c_y + 45, r, g, b, a, 'cd-', 0, "T: ")
            renderer_text(c_x + 8, c_y + 40, r, g, b, a, 'd-', 0, string_upper(threat_name))
        end
    end
end

local function dt_charge_state()
    if not ui_get(main.enable) then return end
    if not ui_get(ref.dt[2]) or ui_get(ref.fd) then return false end

    if not entity_is_alive(entity_get_local_player()) or entity_get_local_player() == nil then return end

    local weapon = entity_get_prop(entity_get_local_player(), "m_hActiveWeapon")

    if weapon == nil then return false end

    local next_attack = entity_get_prop(entity_get_local_player(), "m_flNextAttack") + 0.25
    local jewfag = entity_get_prop(weapon, "m_flNextPrimaryAttack")
    
    if jewfag == nil then return end
    
    local next_primary_attack = jewfag + 0.5

    if next_attack == nil or next_primary_attack == nil then return false end

    return next_attack - globals_curtime() < 0 and next_primary_attack - globals_curtime() < 0
end

local function indicator()
    local local_player = entity_get_local_player()
    local local_alive = entity_is_alive(local_player)
    if not entity_is_alive(entity_get_local_player()) then return end
    -- if states == nil then return end

    local r, g, b, a = ui_get(main.ind_v_c)
    local r2, g2, b2, a2 = ui_get(main.ind_h_c)
    local r3, g3, b3, a3 = ui_get(main.ind_s_c)
    local r4, g4, b4, a4 = ui_get(main.fake_yaw_c)
    if states == nil then return end

    local af = math_floor( math_sin( globals_realtime() * 2) * 127 + 128 )

    if not ui_get(main.enable) or not ui_get(main.aa_ind) then return end
    if ui_get(main.aa_ind_m) == "v1" then 
        renderer_text(c_x + 11, c_y + 15, 255, 255, 255, 255, "cd-", 0, "GALAXY")
        renderer_text(c_x + 38, c_y + 15, r, g, b, af, "cd-", 0, "BETA")
        
        if mode == "left" then
            renderer_text(c_x - 40, c_y, r2, g2, b2, a2, "cdb", 0, "⮘")
        end
        if mode == "right" then
            renderer_text(c_x + 40, c_y, r2, g2, b2, a2, "cdb", 0, "⮚")
        end

        if ui_get(ref.baim) then
            renderer_text(c_x + 7, c_y + 25, r2, g2, b2, a2, "cd-", 0, "BAIM")
        else
            renderer_text(c_x + 7, c_y + 25, 255, 255, 255, 150, "cd-", 0, "BAIM")
        end
        if ui_get(ref.sp) then
            renderer_text(c_x + 23, c_y + 25, r2, g2, b2, a2, "cd-", 0, "SP")
        else
            renderer_text(c_x + 23, c_y + 25, 255, 255, 255, 150, "cd-", 0, "SP")
        end
        if ui_get(ref.fs[2]) then
            renderer_text(c_x + 34, c_y + 25, r2, g2, b2, a2, "cd-", 0, "FS")
        else
            renderer_text(c_x + 34, c_y + 25, 255, 255, 255, 150, "cd-", 0, "FS")
        end
        if ui_get(ref.hs[2]) then
            renderer_text(c_x + 46, c_y + 25, r2, g2, b2, a2, "cd-", 0, "OS")
        else
            renderer_text(c_x + 46, c_y + 25, 255, 255, 255, 150, "cd-", 0, "OS")
        end
        if ui_get(ref.dt[2]) then
            if dt_charge_state() then
                renderer_text(c_x + 58, c_y + 25, 162, 235, 5, 255, "cd-", 0, "DT")
            else
                renderer_text(c_x + 58, c_y + 25, 222, 0, 0, 255, "cd-", 0, "DT")
            end
        end

        local body_yaw = math_floor(math_max(-60, math_min(60, round((entity_get_prop(local_player, "m_flPoseParameter", 11) or 0)*120-60+0.5, 1))))

        local threat = client_current_threat()

        if entity_is_dormant(threat) or threat == nil then
            renderer_text(c_x + 20, c_y + 35, r4, g4, b4, a4, "cd-", 0, "FAKE YAW: O")
        elseif body_yaw >= 0 then
            renderer_text(c_x + 20, c_y + 35, r4, g4, b4, a4, "cd-", 0, "FAKE YAW: R")
        elseif body_yaw <= 0 then
            renderer_text(c_x + 19, c_y + 35, r4, g4, b4, a4, "cd-", 0, "FAKE YAW: L")
        end
    end
end

client.set_event_callback("shutdown", function ()
    ui_set_visible(ref.aa.pitch, true)
    ui_set_visible(ref.aa.yaw[1], true)
    ui_set_visible(ref.aa.yaw[2], true)
    ui_set_visible(ref.aa.jitter[1], true)
    ui_set_visible(ref.aa.jitter[2], true)
    ui_set_visible(ref.aa.body_yaw[1], true)
    ui_set_visible(ref.aa.body_yaw[2], true)
    ui_set_visible(ref.aa.fake_limit, true)
    ui_set_visible(ref.aa.fs_body_yaw, true)
    ui_set_visible(ref.aa.yaw_base, true)
    ui_set_visible(ref.aa.fake_limit, true)
    ui_set_visible(ref.aa.edge_yaw, true)
    
    ui_set(ref.aa.body_yaw[1], "Off")
    ui_set(ref.aa.body_yaw[2], 0)
    ui_set(ref.aa.jitter[1], "Off")
    ui_set(ref.aa.jitter[2], 0)
    ui_set(ref.aa.fake_limit, 0)

end) 

local function handleGUI()
    local on = ui_get(main.enable)
    local on2 = ui_get(main.aa_ind)

    if on then
        ui_set_visible(main.aa, true)
        ui_set_visible(main.aa_c, true)

        ui_set_visible(ref.aa.pitch, false)
        ui_set_visible(ref.aa.yaw[1], false)
        ui_set_visible(ref.aa.yaw[2], false)
        ui_set_visible(ref.aa.jitter[1], false)
        ui_set_visible(ref.aa.jitter[2], false)
        ui_set_visible(ref.aa.body_yaw[1], false)
        ui_set_visible(ref.aa.body_yaw[2], false)
        ui_set_visible(ref.aa.fake_limit, false)
        ui_set_visible(ref.aa.fs_body_yaw, false)
        ui_set_visible(ref.aa.yaw_base, false)
        ui_set_visible(ref.aa.fake_limit, false)
        ui_set_visible(ref.aa.edge_yaw, false)

        ui_set_visible(main.aa_roll_e, true)
        ui_set_visible(main.aa_roll_h, true)
        ui_set_visible(main.aa_roll, true)

        ui_set_visible(main.manual_aa, true)
        ui_set_visible(main.back, false)
        ui_set_visible(main.left, true)
        ui_set_visible(main.right, true)

        ui_set_visible(main.fs_disabler, true)
        ui_set_visible(main.fs_disabler_m, true)

        ui_set_visible(main.leg_breaker, true)
        ui_set_visible(main.leg_breaker_m, true)

        ui_set_visible(main.anim_breaker, true)

        ui_set_visible(main.legit_aa, true)
        ui_set_visible(main.legit_aa_h, true)

        ui_set_visible(main.watermark, true)
        ui_set_visible(main.watermark_c, true)

        ui_set_visible(main.aa_ind, true)
        ui_set_visible(main.aa_ind_m, true)

        ui_set_visible(main.label, true)
        ui_set_visible(main.color, true)
        ui_set_visible(main.label1, true)
        ui_set_visible(main.color1, true)

        ui_set_visible(main.ind_v, true)
        ui_set_visible(main.ind_v_c, true)

        ui_set_visible(main.ind_l_h, true)
        ui_set_visible(main.ind_h_c, true)

        ui_set_visible(main.ind_l_s, true)
        ui_set_visible(main.ind_s_c, true)

        ui_set_visible(main.threat_l, true)
        ui_set_visible(main.threat_c, true)

        ui_set_visible(main.fake_yaw_l, true)
        ui_set_visible(main.fake_yaw_c, true)

        ui_set_visible(main.ind_v_2, true)
        ui_set_visible(main.ind_v_c_2, true)

        ui_set_visible(main.ind_l_h_2, true)
        ui_set_visible(main.ind_h_c_2, true)

        ui_set_visible(main.ind_l_s_2, true)
        ui_set_visible(main.ind_s_c_2, true)
    else
        ui_set_visible(main.aa, false)
        ui_set_visible(main.aa_c, false)

        ui_set_visible(ref.aa.pitch, false)
        ui_set_visible(ref.aa.yaw[1], false)
        ui_set_visible(ref.aa.yaw[2], false)
        ui_set_visible(ref.aa.jitter[1], false)
        ui_set_visible(ref.aa.jitter[2], false)
        ui_set_visible(ref.aa.body_yaw[1], false)
        ui_set_visible(ref.aa.body_yaw[2], false)
        ui_set_visible(ref.aa.fake_limit, false)
        ui_set_visible(ref.aa.fs_body_yaw, false)
        ui_set_visible(ref.aa.yaw_base, false)
        ui_set_visible(ref.aa.edge_yaw, false)

        ui_set_visible(main.aa_roll_e, false)
        ui_set_visible(main.aa_roll_h, false)
        ui_set_visible(main.aa_roll, false)

        ui_set_visible(main.manual_aa, false)
        ui_set_visible(main.back, false)
        ui_set_visible(main.left, false)
        ui_set_visible(main.right, false)

        ui_set_visible(main.fs_disabler, false)
        ui_set_visible(main.fs_disabler_m, false)

        ui_set_visible(main.leg_breaker, false)
        ui_set_visible(main.leg_breaker_m, false)

        ui_set_visible(main.anim_breaker, false)

        ui_set_visible(main.legit_aa, false)
        ui_set_visible(main.legit_aa_h, false)

        ui_set_visible(main.watermark, false)
        ui_set_visible(main.watermark_c, false)

        ui_set_visible(main.aa_ind, false)
        ui_set_visible(main.aa_ind_m, false)

        ui_set_visible(main.label, false)
        ui_set_visible(main.color, false)
        ui_set_visible(main.label1, false)
        ui_set_visible(main.color1, false)

        ui_set_visible(main.ind_v, false)
        ui_set_visible(main.ind_v_c, false)

        ui_set_visible(main.ind_l_h, false)
        ui_set_visible(main.ind_h_c, false)

        ui_set_visible(main.ind_l_s, false)
        ui_set_visible(main.ind_s_c, false)

        ui_set_visible(main.threat_l, false)
        ui_set_visible(main.threat_c, false)

        ui_set_visible(main.fake_yaw_l, false)
        ui_set_visible(main.fake_yaw_c, false)

        ui_set_visible(main.ind_v_2, false)
        ui_set_visible(main.ind_v_c_2, false)

        ui_set_visible(main.ind_l_h_2, false)
        ui_set_visible(main.ind_h_c_2, false)

        ui_set_visible(main.ind_l_s_2, false)
        ui_set_visible(main.ind_s_c_2, false)
    end

    if ui_get(main.aa) then 
        ui_set_visible(main.aa_c, on)
    else
        ui_set_visible(main.aa_c, false)
    end

    if ui_get(main.aa_roll_e) then 
        ui_set_visible(main.aa_roll_h, on)
        ui_set_visible(main.aa_roll, on)
    else
        ui_set_visible(main.aa_roll_h, false)
        ui_set_visible(main.aa_roll, false)
    end

    if ui_get(main.manual_aa) then
        ui_set_visible(main.left, on)
        ui_set_visible(main.right, on)
        ui_set_visible(main.back, false)
    else
        ui_set_visible(main.left, false)
        ui_set_visible(main.right, false)
        ui_set_visible(main.back, false)
    end

    if ui_get(main.fs_disabler) then
        ui_set_visible(main.fs_disabler_m, on)
    else
        ui_set_visible(main.fs_disabler_m, false)
    end

    if ui_get(main.leg_breaker) then
        ui_set_visible(main.leg_breaker_m, on)
    else
        ui_set_visible(main.leg_breaker_m, false)
    end

    if ui_get(main.legit_aa) then
        ui_set_visible(main.legit_aa_h, on)
    else
        ui_set_visible(main.legit_aa_h, false)
    end

    if ui_get(main.watermark) then
        ui_set_visible(main.watermark_c, on)
    else
        ui_set_visible(main.watermark_c, false)
    end

    if ui_get(main.aa_ind) then
        ui_set_visible(main.aa_ind_m, on)
    else
        ui_set_visible(main.aa_ind_m, false)
    end

    if ui_get(main.aa_ind_m) == "v1" then 
        ui_set_visible(main.ind_v, on and on2)
        ui_set_visible(main.ind_v_c, on and on2)
        ui_set_visible(main.ind_h_c, on and on2)
        ui_set_visible(main.ind_s_c, on and on2)
        ui_set_visible(main.ind_l_h, on and on2)
        ui_set_visible(main.ind_l_s, on and on2)
        ui_set_visible(main.threat_l, on and on2)
        ui_set_visible(main.threat_c, on and on2)
        ui_set_visible(main.fake_yaw_l, on and on2)
        ui_set_visible(main.fake_yaw_c, on and on2)
    else
        ui_set_visible(main.ind_v, false)
        ui_set_visible(main.ind_v_c, false)
        ui_set_visible(main.ind_h_c, false)
        ui_set_visible(main.ind_s_c, false)
        ui_set_visible(main.ind_l_h, false)
        ui_set_visible(main.ind_l_s, false)
        ui_set_visible(main.threat_l, false)
        ui_set_visible(main.threat_c, false)
        ui_set_visible(main.fake_yaw_l, false)
        ui_set_visible(main.fake_yaw_c, false)
    end
    
    if ui_get(main.aa_ind_m) == "v2" then 
        ui_set_visible(main.label, on and on2)
        ui_set_visible(main.color, on and on2)
        ui_set_visible(main.label1, on and on2)
        ui_set_visible(main.color1, on and on2)
    else
        ui_set_visible(main.label, false)
        ui_set_visible(main.color, false)
        ui_set_visible(main.label1, false)
        ui_set_visible(main.color1, false)
    end

    if ui_get(main.aa_ind_m) == "v3" then 
        ui_set_visible(main.ind_v_2, on and on2)
        ui_set_visible(main.ind_v_c_2, on and on2)
        ui_set_visible(main.ind_h_c_2, on and on2)
        ui_set_visible(main.ind_s_c_2, on and on2)
        ui_set_visible(main.ind_l_h_2, on and on2)
        ui_set_visible(main.ind_l_s_2, on and on2)
    else
        ui_set_visible(main.ind_v_2, false)
        ui_set_visible(main.ind_v_c_2, false)
        ui_set_visible(main.ind_h_c_2, false)
        ui_set_visible(main.ind_s_c_2, false)
        ui_set_visible(main.ind_l_h_2, false)
        ui_set_visible(main.ind_l_s_2, false)
    end
end

local function loadsettings()
    ui_set(main.enable, true)
    ui_set(main.aa, true)
    ui_set(main.aa_c, "Mode 2")
    ui_set(main.fs_disabler, true)
    ui_set(main.fs_disabler_m, "Jumping")
    ui_set(main.leg_breaker, true)
    ui_set(main.leg_breaker_m, "Jitter")
    ui_set(main.anim_breaker, true)
    ui_set(main.legit_aa, true)
    ui_set(main.watermark, false)
    ui_set(main.aa_ind, true)
    ui_set(main.aa_ind_m, "v1")
end

local load_button = ui_new_button("LUA", "B", "Recommended Settings", loadsettings)

client_set_event_callback("run_command", function()
    aa()
    manual_aa()
end)

client_set_event_callback("setup_command", function(e)
    legit_aa(e)
end)

client_set_event_callback("setup_command", function(cmd)
    roll_aa(cmd)
end)

client_set_event_callback("run_command", function(ctx)
    legbreaker1()
end)

client_set_event_callback("net_update_end", function()
    legbreaker_net_update_end()
end)

client_set_event_callback("net_update_start", function()
    legbreaker2()
end)

client_set_event_callback("pre_render", function()
    animation_breaker()
end)

client_set_event_callback("paint_ui", function()
    legbreaker3()
    watermark()
    threat()
    indicator()
    handleGUI()
end)