display.setStatusBar(display.DefaultStatusBar)

_SCREEN = {
	HEIGHT = display.contentHeight,
	WIDTH = display.contentWidth
}

_SCREEN.CENTER = {
	x = display.contentCenterX,
	y = display.contentCenterY
}

local timeBegin
local timeEnd

local widget = require("widget")
local numbers = require("numbers")
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
	
	if(e.phase == "press") then
		timeBegin = system.getTimer()
	elseif(e.phase == "release") then
		timeEnd = system.getTimer()
		if(timeEnd - timeBegin > 1000) then
			pasteboard.copy("string", row.rowText.text)
			toast.show("Copied")
		end
	end
end

local tableView = widget.newTableView({
	left = 0,
	top = 0,
	height = _SCREEN.HEIGHT,
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
			default = {28/255,32/255,33/255},
			over = {90/255,90/255,90/255}
		},
		params = {
			title = number
		}
	}
	tableView:insertRow(params)
end

