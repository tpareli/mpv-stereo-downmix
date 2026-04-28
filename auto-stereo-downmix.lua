local mp = require 'mp'
local msg = require 'mp.msg'

--------------------------------------------
-- Define downmix presets for all layouts --
--------------------------------------------
local downmix_presets = {
    -- 2.1: Stereo + LFE
    [3] = "lavfi=[pan=stereo|FL=FL+0.3*LFE|FR=FR+0.3*LFE]",

    -- 4.0: Stereo + Side Surround (SL, SR)
    [4] = "lavfi=[pan=stereo|FL=FL+0.5*SL|FR=FR+0.5*SR]",

    -- 5.1: Stereo + Center + LFE + Side Surround (SL, SR)
    [6] = "lavfi=[pan=stereo|FL=FL+0.707*FC+0.5*SL+0.3*LFE|FR=FR+0.707*FC+0.5*SR+0.3*LFE]",

    -- 7.1: Stereo + Center + LFE + Side Surround (SL, SR) + Rear Surround (BL, BR)
    [8] = "lavfi=[pan=stereo|FL=FL+0.5*FC+0.5*SL+0.5*BL+0.2*LFE|FR=FR+0.5*FC+0.5*SR+0.5*BR+0.2*LFE]",
}

------------------------------------------------------
-- Track if the downmix filter is currently applied --
------------------------------------------------------
local downmix_active = false

--------------------------------------------
-- Helper: Remove downmix filter if active --
--------------------------------------------
local function remove_downmix_filter()
    if downmix_active then
        mp.command("af remove @auto-downmix")
        downmix_active = false
        msg.debug("Removed downmix filter.")
    end
end

--------------------------------------------
-- Function to detect audio channel count --
--------------------------------------------
local function get_audio_channels()
    local tracks = mp.get_property_native("track-list", {})
    for _, track in ipairs(tracks) do
        if track.type == "audio" and track.selected then
            return track["audio-channels"]
        end
    end
    return nil
end

--------------------------------------
-- Function to apply downmix filter --
--------------------------------------
local function apply_downmix()
    local channels = get_audio_channels()
    if not channels then
        remove_downmix_filter()
        return
    end

    local preset = downmix_presets[channels]
    if not preset then
        remove_downmix_filter()
        msg.debug(string.format("No downmix preset for %d channels. Using default stereo.", channels))
        return
    end

    -- Remove existing filter first (if any)
    remove_downmix_filter()

    -- Apply the new filter
    mp.command("af add @auto-downmix:" .. preset)
    downmix_active = true
    msg.debug(string.format("Detected %d channels. Applied downmix: %s", channels, preset))
end

----------------------------------------------
-- Register event handlers
----------------------------------------------
mp.register_event("file-loaded", function()
    mp.add_timeout(0.5, apply_downmix)  -- Wait for audio to initialize
end)
mp.register_event("track-switched", apply_downmix)
mp.register_event("end-file", remove_downmix_filter)
mp.register_event("shutdown", remove_downmix_filter)
