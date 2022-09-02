local _G = _G or getfenv(0)

local module = ShaguTweaks:register({
    title = "Mouseover Bottom Left",
    description = "Hide the Bottom Left ActionBar and show on mouseover. The action bar must be enabled in 'Interface Options' > 'Advanced Options'. Please reload the UI after enabling or disabling the action bar.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Action Bar",
    enabled = nil,
})

local modLoaded
local timer
local mouseOverBar
local mouseOverButton
    
local function hide(bar)
    bar:Hide()
end
  
local function show(bar)
    bar:Show()
end
  
local function mouseover(bar)
    local function setTimer()
        local time = GetTime() + 2
        timer:SetScript("OnUpdate", function()
            if GetTime() >= time then
                hide(bar)
                timer:SetScript("OnUpdate", nil)
            end
        end)
    end

    local tooltipVisible = GameTooltip:IsVisible()
    if (not tooltipVisible) and (mouseOverButton or mouseOverBar) then
        timer:SetScript("OnUpdate", nil)
        show(bar)
    elseif (not tooltipVisible) and (not mouseOverBar) and (not mouseOverButton) then
        setTimer()
    end
end

local function barEnter(frame, bar)
    frame:SetScript("OnEnter", function()
        mouseOverBar = true
        mouseover(bar)
    end)
end
  
local function barLeave(frame, bar)
    frame:SetScript("OnLeave", function()
        mouseOverBar = false     
        mouseover(bar)
    end)
end
  
local function buttonEnter(frame, bar)
    frame:SetScript("OnEnter", function()
        mouseOverButton = true
        frame:EnableMouse(false)
        mouseover(bar)        
    end)
end
  
local function buttonLeave(frame, bar)
    frame:SetScript("OnLeave", function()
        mouseOverButton = false
        frame:EnableMouse(true)
        mouseover(bar)
    end)
end
  
local function mouseoverButton(button, bar)
    local frame = CreateFrame("Frame", nil, UIParent)    
    frame:SetAllPoints(button)
    frame:EnableMouse(true)
    frame:SetFrameStrata("DIALOG")    
    buttonEnter(frame, bar)
    buttonLeave(frame, bar)
end
  
local function mouseoverBar(bar)
    local frame = CreateFrame("Frame", nil, UIParent)
    local x, y = 5, 10
    frame:SetPoint("TOPLEFT", bar ,"TOPLEFT", -x, y)
    frame:SetPoint("BOTTOMRIGHT", bar ,"BOTTOMRIGHT", x, -y)
    frame:EnableMouse(true)
    barEnter(frame, bar) 
    barLeave(frame, bar)
end
  
local function setup(bar)
    if not bar:IsVisible() then return end
    if not modLoaded then
        modLoaded = true
        timer = CreateFrame("Frame", nil, UIParent)
        for i = 1, 12 do
            for _, button in pairs(
                    {
                    _G[bar:GetName()..'Button'..i],
                }
            ) do
                mouseoverButton(button, bar)
            end
        end
        mouseoverBar(bar)
        hide(bar)
    end
end
  
module.enable = function(self)

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:SetScript("OnEvent", function()
        setup(MultiBarBottomLeft)
    end)

end