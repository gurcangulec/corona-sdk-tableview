display.setStatusBar(display.TranslucentStatusBar)

--Screen adjustment
_SCREEN = {
	HEIGHT = display.contentHeight,
	WIDTH = display.contentWidth
}

_SCREEN.CENTER = {
	x = display.contentCenterX,
	y = display.contentCenterY
}

--Numbers table
local numbers = {}

numbers[1] = { name = "12355" }
numbers[2] = { name = "889823" }
numbers[3] = { name = "123444" }
numbers[4] = { name = "432133" }
numbers[5] = { name = "123423" }
numbers[6] = { name = "432112" }
numbers[7] = { name = "123464" }
numbers[8] = { name = "432175" }
numbers[9] = { name = "123478" }
numbers[10] = { name = "432134" }
numbers[11] = { name = "123465" }
numbers[12] = { name = "432177" }
numbers[13] = { name = "123422" }
numbers[14] = { name = "432115" }
numbers[15] = { name = "432167" }
numbers[16] = { name = "123487" }
numbers[17] = { name = "432194" }
numbers[18] = { name = "123434" }
numbers[19] = { name = "432126" }
numbers[20] = { name = "432167" }
numbers[21] = { name = "123426" }
numbers[22] = { name = "432173" }
numbers[23] = { name = "123474" }
numbers[24] = { name = "432174" }
numbers[25] = { name = "432155" }
numbers[26] = { name = "123412" }
numbers[27] = { name = "432174" }
numbers[28] = { name = "123426" }
numbers[29] = { name = "432173" }
numbers[30] = { name = "432175" }

--Creating timer variables
local timeBegin
local timeEnd

local statusBarHeight = display.topStatusBarContentHeight

print(statusBarHeight)

--Widgets and plugins that are going to be used
local widget = require("widget")
local toast = require("plugin.toast")
local pasteboard = require("plugin.pasteboard")

local function onRowRender(e)
	local row = e.row
	local rowIndex = row.index
	
	local rowLabel = e.row.params.title
	
	row.rowText = display.newText(rowIndex .. ".", 0, 0, "Helvetica", 26)
	row.rowText.anchorX = 1
	row.rowText.x = - 40
	row.rowText.y = row.height * 0.5
	row.rowText.fill = {255, 255, 255}
	row.rowText.alpha = 0.38

	row.rowText2 = display.newText(rowLabel, 0, 0, "Helvetica", 26)
	row.rowText2.anchorX = 0.5
	row.rowText2.x = 10
	row.rowText2.y = row.height * 0.5
	row.rowText2.fill = {255, 255, 255}
	
	local group = display.newGroup()
	group:insert(row.rowText)
	group:insert(row.rowText2)
	group.x = _SCREEN.CENTER.x

	row:insert(group)
end

--Creating onRowTouch function
local function onRowTouch(e)
	
	local row = e.target

	local function holdListener()
		pasteboard.copy("string", e.row.params.title)
		toast.show("Copied", {duration = "short"})
		e.row = e.row.params.color
	end
	
	if(e.phase == "press") then
		timeBegin = system.getTimer()
		holdTimer = timer.performWithDelay( 750, holdListener)
	elseif(e.phase == "release") then
		timeEnd = system.getTimer()
		if(timeEnd - timeBegin < 750) then
		timer.cancel( holdTimer )
		end
	end
	
end

--Using tableView widget
local tableView = widget.newTableView({
	left = 0,
	top = statusBarHeight,
	height = _SCREEN.HEIGHT,
	width = _SCREEN.WIDTH,
	onRowRender = onRowRender,
	onRowTouch = onRowTouch,
	hideBackground = true
})

--Creating rows according to the number of numbers
for i = 1, #numbers do
	local number = numbers[i].name
	local color = {50/255,50/255,50/255}
	local params = {
		rowHeight = 60,
		lineColor = {33/255,33/255,33/255},
		rowColor = {
			default = {48/255,48/255,48/255},
			over = {66/255,66/255,66/255}
		},
		params = {
			title = number,
			color = color
		}
	}
	tableView:insertRow(params)
end