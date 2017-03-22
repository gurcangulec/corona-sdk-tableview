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

numbers[1] = { name = "1234" }
numbers[2] = { name = "4321" }
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

local timeBegin
local timeEnd

local statusBarHeight = display.statusBarHeight

--Widgets and plugins that are going to be used
local widget = require("widget")
local toast = require("plugin.toast")
local pasteboard = require("plugin.pasteboard")

local function onRowRender(e)
	local row = e.row
	local rowIndex = row.index
	
	local rowLabel = e.row.params.title
	
	row.rowText = display.newText(rowIndex .. ". ".. rowLabel, 0, 0, native.systemFontBold, 20)
	row.rowText.anchorX = 0
	row.rowText.x = 17
	row.rowText.y = row.height * 0.5
	row.rowText.fill = {30/255,144/255,255/255}
	
	row:insert(row.rowText)
end



local function onRowTouch(e)
	
	local row = e.target

	local function holdListener()
		pasteboard.copy("string", e.row.params.title)
		toast.show("Copied")
	end
	
	if(e.phase == "press") then
		timeBegin = system.getTimer()
		display.getCurrentStage( ):setFocus( row )
		row.hasFocus = true
		holdTimer = timer.performWithDelay( 750, holdListener)
	elseif(e.phase == "release") then
		timeEnd = system.getTimer()
		if(timeEnd - timeBegin < 750) then
		timer.cancel( holdTimer )
		display.getCurrentStage():setFocus(nil)
		row.hasFocus = false
		end
	end
	
end

--Using tableView widget
local tableView = widget.newTableView({
	left = 0,
	top = statusBarHeight,
	height = _SCREEN.HEIGHT - statusBarHeight,
	width = _SCREEN.WIDTH,
	onRowRender = onRowRender,
	onRowTouch = onRowTouch,
	hideBackground = true
})

for i = 1, #numbers do
	local number = numbers[i].name
	local params = {
		rowHeight = 60,
		rowColor = {
			default = {50/255,50/255,50/255},
			over = {25/255,25/255,25/255}
		},
		params = {
			title = number
		}
	}
	tableView:insertRow(params)
end

