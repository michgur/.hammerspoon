hs.ipc.cliInstall("/opt/homebrew/", true)
hs.hotkey.bind({ "cmd", "alt" }, "r", function()
	hs.reload()
end)
hs.alert.show("Config loaded")

local function wait(seconds)
	local start = hs.timer.secondsSinceEpoch()
	while hs.timer.secondsSinceEpoch() - start < seconds do
	end
end

local function mouseDown(position)
	hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, position):post()
end

local function mouseUp(position)
	hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, position):post()
end

local function gotoSpace(i)
	hs.eventtap.event.newKeyEvent({ "alt" }, tostring(i), true):post()
	hs.eventtap.event.newKeyEvent({ "alt" }, tostring(i), false):post()
end

local function moveFocusedWindowToSpace(i)
	local window = hs.window.focusedWindow()
	local origin = hs.mouse.getRelativePosition()
	local topLeft = window:topLeft()
	local size = window:size()
	local point = {
		x = topLeft.x + (size.w / 2),
		y = topLeft.y + 5,
	}

	local waitTime = 0.01
	mouseDown(point)
	wait(waitTime)
	gotoSpace(i)
	wait(waitTime)
	mouseUp(point)
	wait(waitTime)
	mouseUp(origin)
end

for i = 1, 9, 1 do
	hs.hotkey.bind({ "shift", "alt" }, tostring(i), function()
		moveFocusedWindowToSpace(i)
	end)
end

local directions = {
	pageup = "north",
	home = "west",
	pagedown = "south",
	["end"] = "east",
}

for key, direction in pairs(directions) do
	hs.hotkey.bind({}, key, function()
		hs.execute("yabai -m window --focus " .. direction, true)
	end)
	hs.hotkey.bind({ "shift" }, key, function()
		hs.execute("yabai -m window --swap " .. direction, true)
	end)
end
