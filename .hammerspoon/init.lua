-------------------- REMAP CAPS_LOCK -------------------------------
-- Tap for ESC, hold to activate CTRL
-- https://gist.github.com/zcmarine/f65182fe26b029900792fa0b59f09d7f
--------------------------------------------------------------------
len = function(t)
    local length = 0
    for k, v in pairs(t) do
    	length = length + 1
    end
    return length
end


send_escape = false
prev_modifiers = {}

modifier_handler = function(evt)
    -- evt:getFlags() holds the modifiers that are currently held down
    local curr_modifiers = evt:getFlags()

    if curr_modifiers["ctrl"] and len(curr_modifiers) == 1 and len(prev_modifiers) == 0 then
        -- We need this here because we might have had additional modifiers, which
        -- we don't want to lead to an escape, e.g. [Ctrl + Cmd] —> [Ctrl] —> [ ]
        send_escape = true
    elseif prev_modifiers["ctrl"]  and len(curr_modifiers) == 0 and send_escape then
		send_escape = false
        hs.eventtap.keyStroke({}, "ESCAPE")
    else
        send_escape = false
	end
    prev_modifiers = curr_modifiers
	return false
end


-- Call the modifier_handler function anytime a modifier key is pressed or released
modifier_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, modifier_handler)
modifier_tap:start()


-- If any non-modifier key is pressed, we know we won't be sending an escape
non_modifier_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(evt)
    send_escape = false
	return false
end)
non_modifier_tap:start()

--
-------------------- REMAP CTRL -------------------------------
-- Use CTRL+h,j,k,l as arrow keys, just like vim
-- https://github.com/kkamdooong/hammerspoon-control-hjkl-to-arrow/blob/master/init.lua
---------------------------------------------------------------
local function pressFn(mods, key)
  if key == nil then
    key = mods
    mods = {}
  end
  return function() hs.eventtap.keyStroke(mods, key, 1000) end
end

local function remap(mods, key, pressFn)
  hs.hotkey.bind(mods, key, pressFn, nil, pressFn)	
end


remap({'ctrl'}, 'h', pressFn('left'))
remap({'ctrl'}, 'j', pressFn('down'))
remap({'ctrl'}, 'k', pressFn('up'))
remap({'ctrl'}, 'l', pressFn('right'))

remap({'ctrl', 'shift'}, 'h', pressFn({'shift'}, 'left'))
remap({'ctrl', 'shift'}, 'j', pressFn({'shift'}, 'down'))
remap({'ctrl', 'shift'}, 'k', pressFn({'shift'}, 'up'))
remap({'ctrl', 'shift'}, 'l', pressFn({'shift'}, 'right'))

remap({'ctrl', 'cmd'}, 'h', pressFn({'cmd'}, 'left'))
remap({'ctrl', 'cmd'}, 'j', pressFn({'cmd'}, 'down'))
remap({'ctrl', 'cmd'}, 'k', pressFn({'cmd'}, 'up'))
remap({'ctrl', 'cmd'}, 'l', pressFn({'cmd'}, 'right'))

remap({'ctrl', 'alt'}, 'h', pressFn({'alt'}, 'left'))
remap({'ctrl', 'alt'}, 'j', pressFn({'alt'}, 'down'))
remap({'ctrl', 'alt'}, 'k', pressFn({'alt'}, 'up'))
remap({'ctrl', 'alt'}, 'l', pressFn({'alt'}, 'right'))

remap({'ctrl', 'shift', 'cmd'}, 'h', pressFn({'shift', 'cmd'}, 'left'))
remap({'ctrl', 'shift', 'cmd'}, 'j', pressFn({'shift', 'cmd'}, 'down'))
remap({'ctrl', 'shift', 'cmd'}, 'k', pressFn({'shift', 'cmd'}, 'up'))
remap({'ctrl', 'shift', 'cmd'}, 'l', pressFn({'shift', 'cmd'}, 'right'))

remap({'ctrl', 'shift', 'alt'}, 'h', pressFn({'shift', 'alt'}, 'left'))
remap({'ctrl', 'shift', 'alt'}, 'j', pressFn({'shift', 'alt'}, 'down'))
remap({'ctrl', 'shift', 'alt'}, 'k', pressFn({'shift', 'alt'}, 'up'))
remap({'ctrl', 'shift', 'alt'}, 'l', pressFn({'shift', 'alt'}, 'right'))

remap({'ctrl', 'cmd', 'alt'}, 'h', pressFn({'cmd', 'alt'}, 'left'))
remap({'ctrl', 'cmd', 'alt'}, 'j', pressFn({'cmd', 'alt'}, 'down'))
remap({'ctrl', 'cmd', 'alt'}, 'k', pressFn({'cmd', 'alt'}, 'up'))
remap({'ctrl', 'cmd', 'alt'}, 'l', pressFn({'cmd', 'alt'}, 'right'))

remap({'ctrl', 'cmd', 'alt', 'shift'}, 'h', pressFn({'cmd', 'alt', 'shift'}, 'left'))
remap({'ctrl', 'cmd', 'alt', 'shift'}, 'j', pressFn({'cmd', 'alt', 'shift'}, 'down'))
remap({'ctrl', 'cmd', 'alt', 'shift'}, 'k', pressFn({'cmd', 'alt', 'shift'}, 'up'))
remap({'ctrl', 'cmd', 'alt', 'shift'}, 'l', pressFn({'cmd', 'alt', 'shift'}, 'right'))

