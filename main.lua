display.setStatusBar(display.DefaultStatusBar)

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

numbers[1] = { name = "1" }
numbers[2] = { name = "8888" }
numbers[3] = { name = "1234" }
numbers[4] = { name = "4321" }
numbers[5] = { name = "1234" }
numbers[6] = { name = "4321" }
numbers[7] = { name = "1234" }
numbers[8] = { name = "4321" }
numbers[9] = { name = "1234" }
numbers[10] = { name = "4321" }
numbers[11] = { name = "1234" }
numbers[12] = { name = "4321" }
numbers[13] = { name = "1234" }
numbers[14] = { name = "4321" }

local a = math.random()
print(a)

local timeBegin
local timeEnd

local statusBarHeight = display.topStatusBarContentHeight

--Widgets and plugins that are going to be used
local widget = require("widget")
local toast = require("plugin.toast")
local pasteboard = require("plugin.pasteboard")

local function onRowRender(e)
	local row = e.row
	local rowIndex = row.index
	
	local rowLabel = e.row.params.title
	
	row.rowText = display.newText(rowIndex .. ".", 0, 0, "Helvetica", 18)
	row.rowText.anchorX = 0
	row.rowText.x = 17
	row.rowText.y = row.height * 0.5 + 7
	row.rowText.fill = {255, 255, 255}

	row.rowText2 = display.newText(rowLabel, 0, 0, "Helvetica", 26)
	row.rowText2.anchorX = 0.5
	row.rowText2.anchorY = 0.4
	row.rowText2.x = _SCREEN.CENTER.x
	row.rowText2.y = row.height * 0.5
	row.rowText2.fill = {255, 255, 255}
	
	row:insert(row.rowText)
	row:insert(row.rowText2)
end



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

